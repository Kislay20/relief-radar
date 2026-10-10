import 'dart:convert';
import 'dart:io';

import '../generated/protocol.dart';

/// Service powering AI-driven emergency distress analysis and automated triage.
class AiTriageService {
  /// Regex matching emojis, surrogate pairs, and extended Unicode symbols
  /// that can crash JSON encoding or standard text pipelines.
  static final RegExp _emojiAndHighUnicodeRegex = RegExp(
    r'[\uD800-\uDBFF][\uDC00-\uDFFF]|' // UTF-16 surrogate pairs (e.g. 🚨, 🆘, 🔥, 🌊, 🏥, etc.)
    r'[\uD800-\uDFFF]|' // Unpaired surrogates
    r'[\u{1F000}-\u{1FFFF}]|' // Supplementary Multilingual Plane
    r'[\u2600-\u27BF]|' // Misc symbols & Dingbats (⚠️, ⚡, ✈️, ❌, etc.)
    r'[\u2300-\u23FF]|' // Misc technical (⏰, ⏳, etc.)
    r'[\u2B00-\u2BFF]|' // Miscellaneous Symbols and Arrows
    r'[\uFE00-\uFE0F]|' // Variation Selectors
    r'[\u200D]', // Zero-width joiner
    unicode: true,
  );

  /// Strips emojis and invalid/unsupported Unicode characters from text.
  static String sanitizeText(String text) {
    if (text.isEmpty) return text;
    final cleaned = text.replaceAll(_emojiAndHighUnicodeRegex, '');
    return cleaned.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
  }

  /// Analyzes a raw SOS message using Gemini AI with deterministic emergency NLP fallback.
  static Future<AiTriageResult> analyzeSos(String rawDescription) async {
    final cleanText = sanitizeText(rawDescription);
    if (cleanText.isEmpty) {
      return AiTriageResult(
        severity: 'LOW',
        summary: 'Empty or unspecified distress telemetry.',
        tags: ['General'],
        rawDescription: rawDescription,
      );
    }

    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        final geminiResult = await _callGeminiApi(apiKey, cleanText);
        if (geminiResult != null) {
          return geminiResult;
        }
      } catch (e) {
        // Fall back gracefully to deterministic emergency NLP engine
      }
    }

    return _fallbackDeterministicTriage(cleanText);
  }

  /// Supported Gemini model identifiers in order of preference.
  static const List<String> _geminiModels = [
    'gemini-2.5-flash',
    'gemini-2.0-flash',
    'gemini-1.5-flash',
    'gemini-3.8-flash',
    'gemini-flash-latest',
    'gemini-2.5-flash-lite',
  ];

  /// Direct REST integration with Google Gemini with JSON structured response.
  static Future<AiTriageResult?> _callGeminiApi(
    String apiKey,
    String rawText,
  ) async {
    for (final modelName in _geminiModels) {
      try {
        final result = await _callGeminiModel(apiKey, rawText, modelName);
        if (result != null) {
          return result;
        }
      } catch (e) {
        stdout.writeln(
          '[AiTriageService] Model $modelName failed: $e. Trying next model...',
        );
      }
    }
    return null;
  }

  static Future<AiTriageResult?> _callGeminiModel(
    String apiKey,
    String rawText,
    String modelName,
  ) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey',
    );

    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8);

    try {
      final request = await httpClient.postUrl(uri);
      request.headers.set('content-type', 'application/json');

      final prompt =
          'You are an emergency disaster response triage AI. Analyze this raw distress/SOS message and return ONLY a valid, raw JSON object (do not wrap in markdown or code fences). '
          'JSON schema:\n'
          '{\n'
          '  "severity": "CRITICAL" | "HIGH" | "MODERATE" | "LOW",\n'
          '  "summary": "Concise 1-sentence tactical situation summary",\n'
          '  "tags": ["Tag1", "Tag2", "Tag3"]\n'
          '}\n\n'
          'Severity constraints: Must be exactly one of "CRITICAL", "HIGH", "MODERATE", or "LOW".\n'
          'Tags: 2 to 5 short tactical tags (e.g. "Medical", "Flood", "Evacuation", "Structural", "Trauma", "Fire", "Elderly", "Infant", "Supplies").\n\n'
          'Raw SOS: $rawText';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'temperature': 0.1,
        },
      };

      request.write(jsonEncode(requestBody));
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );

      if (response.statusCode == 200) {
        final responseString = await response.transform(utf8.decoder).join();
        final json = jsonDecode(responseString) as Map<String, dynamic>;
        final candidates = json['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates.first['content'] as Map<String, dynamic>?;
          final parts = content?['parts'] as List<dynamic>?;
          if (parts != null && parts.isNotEmpty) {
            final rawJsonText = parts.first['text'] as String?;
            if (rawJsonText != null && rawJsonText.trim().isNotEmpty) {
              String cleanedJson = rawJsonText.trim();
              if (cleanedJson.startsWith('```json')) {
                cleanedJson = cleanedJson.substring(7);
              } else if (cleanedJson.startsWith('```')) {
                cleanedJson = cleanedJson.substring(3);
              }
              if (cleanedJson.endsWith('```')) {
                cleanedJson = cleanedJson.substring(
                  0,
                  cleanedJson.length - 3,
                );
              }
              cleanedJson = cleanedJson.trim();

              final match = RegExp(r'\{[\s\S]*\}').firstMatch(cleanedJson);
              if (match != null) {
                cleanedJson = match.group(0)!;
              }

              final parsed = jsonDecode(cleanedJson) as Map<String, dynamic>;
              final rawSev =
                  parsed['severity']?.toString().toUpperCase() ?? 'MODERATE';
              final sev =
                  ['CRITICAL', 'HIGH', 'MODERATE', 'LOW'].contains(rawSev)
                  ? rawSev
                  : 'MODERATE';
              final summary = parsed['summary']?.toString() ?? rawText;
              final rawTags = parsed['tags'] as List<dynamic>?;
              final tags = rawTags != null
                  ? rawTags.map((t) => t.toString()).toList()
                  : <String>['Emergency'];

              stdout.writeln(
                '[AiTriageService] Successfully classified SOS with $modelName -> $sev [${tags.join(', ')}]',
              );

              return AiTriageResult(
                severity: sev,
                summary: summary,
                tags: tags,
                rawDescription: rawText,
              );
            }
          }
        }
      } else {
        stdout.writeln(
          '[AiTriageService] $modelName returned HTTP ${response.statusCode}',
        );
      }
    } finally {
      httpClient.close(force: true);
    }

    return null;
  }

  /// High-reliability deterministic emergency NLP triage engine.
  /// Operates offline with zero external network latency.
  static AiTriageResult _fallbackDeterministicTriage(String rawText) {
    final lower = rawText.toLowerCase();

    // Critical Keywords (immediate threat to life/limb, entrapment, collapse)
    final criticalKeywords = [
      'trapped',
      'drowning',
      'chest pain',
      'heart attack',
      'unconscious',
      'not breathing',
      'severe bleeding',
      'crushed',
      'building collapse',
      'roof collapsed',
      'collapsed',
      'life threatening',
      'dying',
      'suffocating',
      'asphyxiation',
      'gas leak',
      'explosion',
      'sweep away',
      'infant trapped',
      'stroke',
    ];

    // High Keywords (urgent medical, vulnerable isolated, rising water, spreading hazard)
    final highKeywords = [
      'broken',
      'fracture',
      'rising water',
      'flash flood',
      'flood surge',
      'fire spreading',
      'burns',
      'hypothermia',
      'elderly',
      'infant',
      'baby',
      'pregnant',
      'diabetic',
      'injured',
      'urgent',
      'bleeding',
      'cut off',
      'stranded',
      'rooftop',
      'submerged',
    ];

    // Moderate Keywords (essential logistics, rations, road blocks, temporary shelter)
    final moderateKeywords = [
      'food',
      'water',
      'ration',
      'potable',
      'supply',
      'supplies',
      'shelter',
      'first aid',
      'blocked road',
      'power outage',
      'blackout',
      'generator',
      'medicine',
      'medication',
      'blanket',
    ];

    String severity = 'LOW';
    if (criticalKeywords.any((k) => lower.contains(k))) {
      severity = 'CRITICAL';
    } else if (highKeywords.any((k) => lower.contains(k))) {
      severity = 'HIGH';
    } else if (moderateKeywords.any((k) => lower.contains(k))) {
      severity = 'MODERATE';
    }

    // Dynamic Tag extraction
    final tags = <String>{};

    if (lower.contains('medic') ||
        lower.contains('injur') ||
        lower.contains('bleed') ||
        lower.contains('pain') ||
        lower.contains('doctor') ||
        lower.contains('paramedic') ||
        lower.contains('hospital') ||
        lower.contains('unconscious') ||
        lower.contains('breath') ||
        lower.contains('fracture') ||
        lower.contains('burn')) {
      tags.add('Medical');
    }

    if (lower.contains('flood') ||
        lower.contains('water') ||
        lower.contains('drown') ||
        lower.contains('submerged') ||
        lower.contains('river') ||
        lower.contains('overflow') ||
        lower.contains('inundat')) {
      tags.add('Flood');
    }

    if (lower.contains('fire') ||
        lower.contains('burn') ||
        lower.contains('smoke') ||
        lower.contains('flame') ||
        lower.contains('blaze')) {
      tags.add('Fire');
    }

    if (lower.contains('trapped') ||
        lower.contains('evacuat') ||
        lower.contains('rescue') ||
        lower.contains('rooftop') ||
        lower.contains('stranded') ||
        lower.contains('airlift') ||
        lower.contains('boat')) {
      tags.add('Evacuation');
    }

    if (lower.contains('collaps') ||
        lower.contains('rubble') ||
        lower.contains('debris') ||
        lower.contains('structur') ||
        lower.contains('wall') ||
        lower.contains('roof')) {
      tags.add('Structural');
    }

    if (lower.contains('food') ||
        lower.contains('water') ||
        lower.contains('ration') ||
        lower.contains('suppl') ||
        lower.contains('blanket') ||
        lower.contains('cloth')) {
      tags.add('Supplies');
    }

    if (lower.contains('elder') ||
        lower.contains('infant') ||
        lower.contains('baby') ||
        lower.contains('child') ||
        lower.contains('pregnant') ||
        lower.contains('disab')) {
      tags.add('Vulnerable');
    }

    if (tags.isEmpty) {
      tags.add('Field Report');
    }

    // Generate concise summary
    String summary;
    if (rawText.length > 90) {
      summary = '${rawText.substring(0, 87)}...';
    } else {
      summary = rawText;
    }

    return AiTriageResult(
      severity: severity,
      summary: summary,
      tags: tags.toList(),
      rawDescription: rawText,
    );
  }
}
