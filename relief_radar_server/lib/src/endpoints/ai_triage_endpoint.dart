import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/ai_triage_service.dart';
import 'incident_endpoint.dart';

/// Endpoint for AI-driven distress analysis, severity prioritization, and triage.
class AiTriageEndpoint extends Endpoint {
  /// Evaluates a raw SOS distress message and returns structured AI classification.
  Future<AiTriageResult> triageSosText(
    Session session,
    String rawDescription,
  ) async {
    return await AiTriageService.analyzeSos(rawDescription);
  }

  /// Triages an existing incident by its [incidentId].
  /// Analyzes the incident's summary (or [customSosDescription]), updates the
  /// incident's AI severity, tags, and summary, persists the changes, and broadcasts
  /// the update via WebSocket to all connected clients.
  Future<Incident?> triageIncident(
    Session session,
    int incidentId, {
    String? customSosDescription,
  }) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) {
      return null;
    }

    final textToAnalyze =
        (customSosDescription != null && customSosDescription.trim().isNotEmpty)
        ? customSosDescription.trim()
        : incident.summary;

    final triageResult = await AiTriageService.analyzeSos(textToAnalyze);

    // Map AI severity to integer 1-5 scale
    int mappedSeverity = incident.severity;
    switch (triageResult.severity.toUpperCase()) {
      case 'CRITICAL':
        mappedSeverity = 5;
        break;
      case 'HIGH':
        mappedSeverity = 4;
        break;
      case 'MODERATE':
        mappedSeverity = 3;
        break;
      case 'LOW':
        mappedSeverity = 2;
        break;
    }

    // Dynamic SLA adjustment based on triage severity
    int adjustedSla = incident.baseSlaSeconds;
    if (triageResult.severity == 'CRITICAL') {
      adjustedSla = 900; // 15 mins for critical life threat
    } else if (triageResult.severity == 'HIGH') {
      adjustedSla = 1800; // 30 mins
    }

    final updated = incident.copyWith(
      severity: mappedSeverity,
      aiSeverity: triageResult.severity,
      aiTags: triageResult.tags,
      aiSummary: triageResult.summary,
      baseSlaSeconds: adjustedSla,
    );

    final saved = await Incident.db.updateRow(session, updated);

    // Broadcast updated incident live over WebSockets
    await session.messages.postMessage(
      IncidentEndpoint.channelIncidentUpdates,
      saved,
    );

    session.log(
      '[AiTriage] Incident #$incidentId triaged -> ${triageResult.severity} (Tags: ${triageResult.tags.join(', ')})',
    );

    return saved;
  }

  /// Ingests a new raw SOS distress report, performs instant AI triage,
  /// creates an Incident record, and broadcasts it live.
  Future<Incident> ingestAndTriageSos(
    Session session, {
    required int zoneId,
    required NeedType needType,
    required String rawSosDescription,
    required double latitude,
    required double longitude,
    int? headcount,
    List<String>? vulnerabilities,
  }) async {
    final triageResult = await AiTriageService.analyzeSos(rawSosDescription);

    int mappedSeverity = 3;
    switch (triageResult.severity.toUpperCase()) {
      case 'CRITICAL':
        mappedSeverity = 5;
        break;
      case 'HIGH':
        mappedSeverity = 4;
        break;
      case 'MODERATE':
        mappedSeverity = 3;
        break;
      case 'LOW':
        mappedSeverity = 2;
        break;
    }

    final newIncident = Incident(
      zoneId: zoneId,
      needType: needType,
      status: IncidentStatus.open,
      severity: mappedSeverity,
      aiSeverity: triageResult.severity,
      aiTags: triageResult.tags,
      aiSummary: triageResult.summary,
      summary: triageResult.summary,
      centroid: GeographyPoint(latitude: latitude, longitude: longitude),
      centroidEmbedding: Vector(List<double>.filled(768, 0.0)),
      accuracyRadiusM: 25.0,
      baseSlaSeconds: triageResult.severity == 'CRITICAL' ? 900 : 1800,
      dispatchRadiusM: 500.0,
      headcount: headcount,
      vulnerabilities: vulnerabilities ?? const [],
    );

    final inserted = await Incident.db.insertRow(session, newIncident);

    // Live telemetry broadcast over WebSockets
    await session.messages.postMessage(
      IncidentEndpoint.channelIncidentUpdates,
      inserted,
    );

    session.log(
      '[AiTriage] Ingested new Incident #${inserted.id} via SOS triage -> ${triageResult.severity}',
    );

    return inserted;
  }
}
