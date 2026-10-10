import 'dart:convert';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Day 9 SitRep & Live Tracking Features', (
    sessionBuilder,
    endpoints,
  ) {
    test('ResponderEndpoint trackLocation records and retrieves breadcrumbs', () async {
      final loc = await endpoints.responder.trackLocation(
        sessionBuilder,
        999,
        19.0760,
        72.8777,
        'active',
      );

      expect(loc.id, isNotNull);
      expect(loc.responderId, 999);
      expect(loc.latitude, closeTo(19.0760, 0.0001));
      expect(loc.longitude, closeTo(72.8777, 0.0001));
      expect(loc.status, 'active');

      final history = await endpoints.responder.getLocationHistory(
        sessionBuilder,
        999,
        limit: 50,
      );
      expect(history.isNotEmpty, isTrue);
      expect(history.first.responderId, 999);
    });

    test('SitrepEndpoint generates structured report and exports valid PDF', () async {
      // 1. Generate structured SitRep
      final report = await endpoints.sitrep.generateSituationReport(
        sessionBuilder,
      );

      expect(report.title, isNotEmpty);
      expect(report.threatLevel, isNotEmpty);
      expect(report.executiveSummary, isNotEmpty);
      expect(report.keyPriorities, isNotNull);
      expect(report.resourceRecommendations, isNotNull);

      // 2. Export SitRep to binary PDF
      final pdfByteData = await endpoints.sitrep.exportSituationReportPdf(
        sessionBuilder,
      );

      final pdfBytes = pdfByteData.buffer.asUint8List();
      expect(pdfBytes.isNotEmpty, isTrue);
      expect(pdfBytes.length, greaterThan(500));

      // PDF files always begin with header bytes "%PDF-"
      final pdfHeader = utf8.decode(pdfBytes.sublist(0, 5), allowMalformed: true);
      expect(pdfHeader, '%PDF-');
    });
  });
}
