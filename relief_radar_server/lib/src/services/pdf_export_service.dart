import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../generated/protocol.dart';

/// Service responsible for rendering and exporting tactical Situation Reports into downloadable PDF format.
class PdfExportService {
  /// Regex matching emojis, surrogate pairs, and extended Unicode symbols
  /// that are unsupported by standard PDF fonts (which use WinAnsi / Latin-1 encoding).
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

  /// Strips emojis and unsupported Unicode characters from text before rendering into PDF.
  static String sanitizeText(String text) {
    if (text.isEmpty) return text;
    final cleaned = text.replaceAll(_emojiAndHighUnicodeRegex, '');
    return cleaned.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
  }

  /// Converts a [SituationReport] and the associated [Incident] records into standard PDF binary data.
  static Future<Uint8List> generateSitrepPdf({
    required SituationReport sitrep,
    required List<Incident> incidents,
  }) async {
    final pdf = pw.Document(
      title:
          'Relief Radar Situation Report - ${sitrep.timestamp.toIso8601String()}',
      author: 'Relief Radar Incident Command AI',
    );

    final isCritical = sitrep.threatLevel.toUpperCase() == 'CRITICAL';
    final threatColor = isCritical
        ? PdfColors.red700
        : (sitrep.threatLevel.toUpperCase() == 'HIGH'
              ? PdfColors.amber700
              : PdfColors.teal700);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            margin: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 1.5),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 14,
                      height: 14,
                      decoration: pw.BoxDecoration(
                        color: threatColor,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      'RELIEF RADAR // DISASTER RESPONSE COMMAND',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: pw.BoxDecoration(
                    color: threatColor,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: pw.Text(
                    'THREAT LEVEL: ${sanitizeText(sitrep.threatLevel.toUpperCase())}',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(top: 8),
            margin: const pw.EdgeInsets.only(top: 14),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey300, width: 1),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Generated: ${sitrep.timestamp.toUtc().toIso8601String().substring(0, 19)}Z | Engine: ${sanitizeText(sitrep.generatedBy)}',
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 7.5,
                  ),
                ),
                pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.TextStyle(
                    color: PdfColors.blueGrey700,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // 1. Report Title and Metadata
            pw.Text(
              sanitizeText(sitrep.title.toUpperCase()),
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey900,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Automated Geospatial Intelligence and Emergency Resource Allocation SitRep',
              style: const pw.TextStyle(
                fontSize: 9.5,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 14),

            // 2. Telemetry Key Metrics Grid
            pw.Row(
              children: [
                _buildMetricCard(
                  title: 'HEADCOUNT AT RISK',
                  value: '${sitrep.totalHeadcountAtRisk}',
                  accentColor: PdfColors.red800,
                ),
                pw.SizedBox(width: 8),
                _buildMetricCard(
                  title: 'CRITICAL TICKETS',
                  value: '${sitrep.criticalIncidentsCount}',
                  accentColor: threatColor,
                ),
                pw.SizedBox(width: 8),
                _buildMetricCard(
                  title: 'OPEN INCIDENTS',
                  value: '${sitrep.openIncidentsCount}',
                  accentColor: PdfColors.amber800,
                ),
                pw.SizedBox(width: 8),
                _buildMetricCard(
                  title: 'TOTAL LOGGED',
                  value: '${incidents.length}',
                  accentColor: PdfColors.blueGrey700,
                ),
              ],
            ),
            pw.SizedBox(height: 14),

            // 3. Executive Tactical Briefing
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: PdfColors.grey300, width: 1),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 8,
                        height: 8,
                        decoration: pw.BoxDecoration(
                          color: threatColor,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.SizedBox(width: 6),
                      pw.Text(
                        'EXECUTIVE SITUATION BRIEFING',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey900,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    sanitizeText(sitrep.executiveSummary),
                    style: const pw.TextStyle(
                      fontSize: 9.5,
                      color: PdfColors.grey900,
                      lineSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // 4. Strategic Priorities & Deployment Recommendations
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Priorities
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                      border: pw.Border.all(
                        color: PdfColors.grey300,
                        width: 1,
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'TACTICAL ACTION PRIORITIES',
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey800,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        ...sitrep.keyPriorities.map(
                          (p) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  '> ',
                                  style: pw.TextStyle(
                                    color: threatColor,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    sanitizeText(p),
                                    style: const pw.TextStyle(
                                      fontSize: 8.5,
                                      color: PdfColors.grey800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                // Recommendations
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                      border: pw.Border.all(
                        color: PdfColors.grey300,
                        width: 1,
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'RESOURCE ALLOCATION DIRECTIVES',
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey800,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        ...sitrep.resourceRecommendations.map(
                          (r) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  '+ ',
                                  style: pw.TextStyle(
                                    color: PdfColors.teal700,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    sanitizeText(r),
                                    style: const pw.TextStyle(
                                      fontSize: 8.5,
                                      color: PdfColors.grey800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // 5. Active Incident Manifest Table
            pw.Text(
              'ACTIVE EMERGENCY INCIDENT MANIFEST',
              style: pw.TextStyle(
                fontSize: 10.5,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey900,
              ),
            ),
            pw.SizedBox(height: 6),

            pw.TableHelper.fromTextArray(
              context: context,
              border: const pw.TableBorder(
                horizontalInside: pw.BorderSide(
                  color: PdfColors.grey200,
                  width: 0.8,
                ),
                bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
                top: pw.BorderSide(color: PdfColors.grey400, width: 1),
              ),
              headerStyle: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blueGrey800,
              ),
              cellStyle: const pw.TextStyle(
                fontSize: 7.5,
                color: PdfColors.grey900,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4.5,
              ),
              headers: [
                'ID',
                'SEV',
                'NEED',
                'LOCATION (LAT, LON)',
                'SOULS',
                'STATUS',
                'SUMMARY / INTEL',
              ],
              data: incidents.map((inc) {
                final lat = inc.centroid.latitude.toStringAsFixed(4);
                final lon = inc.centroid.longitude.toStringAsFixed(4);
                final rawSummary = inc.aiSummary?.isNotEmpty == true
                    ? inc.aiSummary!
                    : inc.summary;
                final cleanSummary = sanitizeText(rawSummary);
                final summary = cleanSummary.isEmpty
                    ? (sanitizeText(inc.summary).isEmpty
                          ? 'Incident #${inc.id ?? ''}'
                          : sanitizeText(inc.summary))
                    : cleanSummary;
                return [
                  '#${inc.id ?? '-'}',
                  '${inc.severity}',
                  sanitizeText(inc.needType.name.toUpperCase()),
                  '$lat, $lon',
                  '${inc.headcount ?? 1}',
                  sanitizeText(inc.status.name.toUpperCase()),
                  summary.length > 55
                      ? '${summary.substring(0, 52)}...'
                      : summary,
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildMetricCard({
    required String title,
    required String value,
    required PdfColor accentColor,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          border: pw.Border.all(color: PdfColors.grey300, width: 1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: const pw.TextStyle(
                fontSize: 6.5,
                color: PdfColors.grey600,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
