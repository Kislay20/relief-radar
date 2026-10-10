import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/pdf_export_service.dart';
import '../services/sitrep_service.dart';

/// Endpoint for generating AI-powered Situation Reports (SitRep) and exporting tactical PDFs.
class SitrepEndpoint extends Endpoint {
  /// Fetches all active OPEN and CRITICAL incidents and uses Gemini AI to generate a structured SitRep.
  Future<SituationReport> generateSituationReport(Session session) async {
    return await SitrepService.generateSitrep(session);
  }

  /// Generates a structured Situation Report and exports it as a downloadable binary PDF document.
  Future<ByteData> exportSituationReportPdf(Session session) async {
    final sitrep = await SitrepService.generateSitrep(session);
    final incidents = await SitrepService.fetchOpenAndCriticalIncidents(
      session,
    );
    final pdfBytes = await PdfExportService.generateSitrepPdf(
      sitrep: sitrep,
      incidents: incidents,
    );
    return ByteData.sublistView(pdfBytes);
  }
}
