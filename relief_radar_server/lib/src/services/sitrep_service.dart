import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Tactical AI Situation Report (SitRep) generation engine.
class SitrepService {
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

  /// Supported Gemini model identifiers in order of preference.
  static const List<String> _geminiModels = [
    'gemini-2.5-flash',
    'gemini-2.0-flash',
    'gemini-1.5-flash',
    'gemini-3.8-flash',
    'gemini-flash-latest',
    'gemini-2.5-flash-lite',
  ];

  /// Fetches all OPEN and CRITICAL incidents from the database.
  static Future<List<Incident>> fetchOpenAndCriticalIncidents(
    Session session,
  ) async {
    return await Incident.db.find(
      session,
      where: (t) =>
          t.status.equals(IncidentStatus.open) |
          t.status.equals(IncidentStatus.escalated) |
          (t.severity >= 4),
      orderBy: (t) => t.severity.desc(),
    );
  }

  /// Synthesizes a structured Situation Report from database incidents via Gemini AI.
  static Future<SituationReport> generateSitrep(Session session) async {
    final incidents = await fetchOpenAndCriticalIncidents(session);
    final zones = await DisasterZone.db.find(session);

    final totalHeadcount = incidents.fold<int>(
      0,
      (sum, i) => sum + (i.headcount ?? 1),
    );
    final criticalCount = incidents
        .where((i) => i.severity >= 4 || i.aiSeverity == 'CRITICAL')
        .length;
    final openCount = incidents
        .where((i) => i.status == IncidentStatus.open)
        .length;

    const defaultTitle = 'RELIEF RADAR OPERATIONAL SITUATION REPORT';
    final defaultThreat = criticalCount > 0
        ? 'CRITICAL'
        : (incidents.isNotEmpty ? 'HIGH' : 'NOMINAL');

    if (incidents.isEmpty) {
      return SituationReport(
        title: defaultTitle,
        timestamp: DateTime.now(),
        threatLevel: 'NOMINAL',
        executiveSummary:
            'All disaster sectors report nominal status. No active critical distress beacons or open escalation tickets.',
        criticalIncidentsCount: 0,
        openIncidentsCount: 0,
        totalHeadcountAtRisk: 0,
        keyPriorities: [
          'Maintain situational awareness and perimeter sensor monitoring.',
          'Verify field responder telemetry and radio mesh communications.',
        ],
        resourceRecommendations: [
          'Keep standard rapid response units on standby.',
        ],
        generatedBy: 'Relief Radar Autonomous Engine',
      );
    }

    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        final aiResult = await _generateSitrepWithGemini(
          apiKey: apiKey,
          incidents: incidents,
          zones: zones,
          totalHeadcount: totalHeadcount,
          criticalCount: criticalCount,
        );
        if (aiResult != null) {
          final prioritiesRaw = aiResult['keyPriorities'] as List<dynamic>?;
          final recommendationsRaw =
              aiResult['resourceRecommendations'] as List<dynamic>?;

          return SituationReport(
            title: sanitizeText(aiResult['title']?.toString() ?? defaultTitle),
            timestamp: DateTime.now(),
            threatLevel: sanitizeText(
              aiResult['threatLevel']?.toString() ?? defaultThreat,
            ),
            executiveSummary: sanitizeText(
              aiResult['executiveSummary']?.toString() ??
                  'Active disaster response operations underway across operational sectors.',
            ),
            criticalIncidentsCount: criticalCount,
            openIncidentsCount: openCount,
            totalHeadcountAtRisk: totalHeadcount,
            keyPriorities: prioritiesRaw != null
                ? prioritiesRaw
                      .map((e) => sanitizeText(e.toString()))
                      .where((s) => s.isNotEmpty)
                      .toList()
                : [
                    'Prioritize emergency medical evacuation for critical zones.',
                    'Dispatch food and potable water relief to cut-off sectors.',
                  ],
            resourceRecommendations: recommendationsRaw != null
                ? recommendationsRaw
                      .map((e) => sanitizeText(e.toString()))
                      .where((s) => s.isNotEmpty)
                      .toList()
                : [
                    'Deploy heavy water rescue squads to Sector 4 lowlands.',
                    'Mobilize mobile trauma clinic to designated rally points.',
                  ],
            generatedBy: 'Gemini 3.8 Flash (Tactical AI)',
          );
        }
      } catch (e, stackTrace) {
        stderr.writeln('SITREP AI ERROR: $e');
        stderr.writeln('SITREP AI STACK TRACE: $stackTrace');
        session.log(
          '[SitrepService] Gemini AI sitrep generation failed: $e. Using local tactical fallback.',
          level: LogLevel.warning,
        );
      }
    } else {
      stderr.writeln(
        'SITREP AI ERROR: GEMINI_API_KEY environment variable is null or empty. Using local tactical fallback.',
      );
    }

    return _buildDeterministicSitrep(
      incidents: incidents,
      zones: zones,
      criticalCount: criticalCount,
      openCount: openCount,
      totalHeadcount: totalHeadcount,
    );
  }

  /// Direct REST integration with Google Gemini for structured Situation Report generation.
  static Future<Map<String, dynamic>?> _generateSitrepWithGemini({
    required String apiKey,
    required List<Incident> incidents,
    required List<DisasterZone> zones,
    required int totalHeadcount,
    required int criticalCount,
  }) async {
    Object? lastError;
    for (final modelName in _geminiModels) {
      try {
        final result = await _callGeminiModelForSitrep(
          apiKey: apiKey,
          modelName: modelName,
          incidents: incidents,
          zones: zones,
          totalHeadcount: totalHeadcount,
          criticalCount: criticalCount,
        );
        if (result != null) return result;
      } catch (e) {
        lastError = e;
        stderr.writeln(
          'SITREP AI ERROR: Gemini model $modelName failed: $e. Trying next model...',
        );
      }
    }
    if (lastError != null) {
      throw lastError;
    }
    throw Exception('All Gemini models returned empty responses.');
  }

  static Future<Map<String, dynamic>?> _callGeminiModelForSitrep({
    required String apiKey,
    required String modelName,
    required List<Incident> incidents,
    required List<DisasterZone> zones,
    required int totalHeadcount,
    required int criticalCount,
  }) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey',
    );

    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 12);

    try {
      final request = await httpClient.postUrl(uri);
      request.headers.set('content-type', 'application/json');

      final zoneNames = zones.map((z) => sanitizeText(z.name)).join(', ');
      final promptBuffer = StringBuffer();
      for (final i in incidents.take(15)) {
        final cleanSummary = sanitizeText(i.summary);
        final cleanNeed = sanitizeText(i.needType.name);
        final cleanTags =
            i.aiTags?.map(sanitizeText).where((t) => t.isNotEmpty).join(', ') ??
            'None';
        promptBuffer.writeln(
          '- [ID #${i.id}] Sev ${i.severity}, Need: $cleanNeed, Headcount: ${i.headcount ?? 1}, Loc: (${i.centroid.latitude.toStringAsFixed(4)}, ${i.centroid.longitude.toStringAsFixed(4)}), Summary: "$cleanSummary", AI Tags: $cleanTags',
        );
      }
      final incidentSummaries = promptBuffer.toString().trim();

      final prompt =
          'You are an expert Emergency Disaster Incident Commander and Intelligence Analyst. '
          'Generate an operational Situation Report (SITREP) based on the following disaster telemetry:\n\n'
          'OPERATIONAL METRICS:\n'
          '- Active Disaster Zones: $zoneNames\n'
          '- Total Critical Incidents: $criticalCount\n'
          '- Total Headcount at Risk: $totalHeadcount\n'
          '- Key Incident Manifest:\n$incidentSummaries\n\n'
          'Respond with ONLY a valid, raw JSON object (no markdown, no code fences) following this schema:\n'
          '{\n'
          '  "title": "RELIEF RADAR OPERATIONAL SITUATION REPORT",\n'
          '  "threatLevel": "CRITICAL" | "HIGH" | "ELEVATED",\n'
          '  "executiveSummary": "Concise 2-3 sentence strategic overview of current disaster impact, population threat, and key hazards.",\n'
          '  "keyPriorities": [\n'
          '    "Actionable priority 1...",\n'
          '    "Actionable priority 2...",\n'
          '    "Actionable priority 3..."\n'
          '  ],\n'
          '  "resourceRecommendations": [\n'
          '    "Resource deployment recommendation 1...",\n'
          '    "Resource deployment recommendation 2..."\n'
          '  ]\n'
          '}';

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
          'temperature': 0.2,
        },
      };

      request.write(jsonEncode(requestBody));
      final response = await request.close().timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode != 200) {
        final errBody = await response.transform(utf8.decoder).join();
        stderr.writeln(
          'SITREP AI ERROR [$modelName]: HTTP ${response.statusCode} - $errBody',
        );
        throw HttpException(
          'HTTP ${response.statusCode}: $errBody',
          uri: uri,
        );
      }

      final responseString = await response.transform(utf8.decoder).join();
      final json = jsonDecode(responseString) as Map<String, dynamic>;
      final candidates = json['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        stderr.writeln(
          'SITREP AI ERROR [$modelName]: No candidates in response: $responseString',
        );
        throw FormatException(
          'No candidates in Gemini response: $responseString',
        );
      }

      final content = candidates.first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        stderr.writeln(
          'SITREP AI ERROR [$modelName]: No content parts in response: $responseString',
        );
        throw FormatException('No content parts in response: $responseString');
      }

      String rawJson = (parts.first['text'] as String?)?.trim() ?? '';
      if (rawJson.startsWith('```json')) rawJson = rawJson.substring(7);
      if (rawJson.startsWith('```')) rawJson = rawJson.substring(3);
      if (rawJson.endsWith('```')) {
        rawJson = rawJson.substring(0, rawJson.length - 3);
      }
      rawJson = rawJson.trim();

      final match = RegExp(r'\{[\s\S]*\}').firstMatch(rawJson);
      if (match != null) rawJson = match.group(0)!;

      try {
        return jsonDecode(rawJson) as Map<String, dynamic>;
      } catch (e) {
        stderr.writeln(
          'SITREP AI ERROR [$modelName]: JSON decoding failed: $e. Raw text: $rawJson',
        );
        throw FormatException('Failed to parse SitRep JSON ($e): $rawJson');
      }
    } finally {
      httpClient.close();
    }
  }

  /// Deterministic emergency synthesis fallback when AI API is unavailable.
  static SituationReport _buildDeterministicSitrep({
    required List<Incident> incidents,
    required List<DisasterZone> zones,
    required int criticalCount,
    required int openCount,
    required int totalHeadcount,
  }) {
    final threatLevel = criticalCount > 0 ? 'CRITICAL' : 'HIGH';
    final needCounts = <NeedType, int>{};
    for (final inc in incidents) {
      needCounts[inc.needType] = (needCounts[inc.needType] ?? 0) + 1;
    }

    final dominantNeeds = needCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topNeedName = dominantNeeds.isNotEmpty
        ? dominantNeeds.first.key.name.toUpperCase()
        : 'MULTI-SECTOR';

    final zoneNames = zones.isNotEmpty
        ? zones.map((z) => z.name).join(', ')
        : 'Active Disaster Sectors';

    return SituationReport(
      title: 'RELIEF RADAR OPERATIONAL SITUATION REPORT',
      timestamp: DateTime.now(),
      threatLevel: threatLevel,
      executiveSummary:
          'Operational situation across $zoneNames indicates $threatLevel threat level with $totalHeadcount individuals requiring immediate intervention. Primary logistical demand concentrated on $topNeedName operations.',
      criticalIncidentsCount: criticalCount,
      openIncidentsCount: openCount,
      totalHeadcountAtRisk: totalHeadcount,
      keyPriorities: [
        'Triaged $criticalCount critical life-safety tickets for rapid response dispatch.',
        'Establish secured perimeter and relief distribution routes.',
        'Continuous geospatial monitoring of high-risk survivor clusters.',
      ],
      resourceRecommendations: [
        'Allocate heavy search and rescue equipment to top affected sectors.',
        'Deploy medical first responder squads with triage kits.',
      ],
      generatedBy: 'Relief Radar Autonomous Engine (Local Fallback)',
    );
  }
}
