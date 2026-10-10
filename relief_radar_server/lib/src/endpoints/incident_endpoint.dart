import 'package:serverpod/serverpod.dart' hide Responder;

import '../generated/protocol.dart';

class IncidentEndpoint extends Endpoint {
  /// Pub/Sub channel for live incident telemetry broadcast.
  static const String channelIncidentUpdates = 'channel_incident_updates';

  /// Streams live incident updates (new incidents and status updates) in real time
  /// over WebSockets to all connected emergency clients.
  Stream<Incident> watchIncidents(Session session) async* {
    final updateStream = session.messages.createStream<Incident>(
      channelIncidentUpdates,
    );
    await for (final incident in updateStream) {
      yield incident;
    }
  }

  /// Reports a new incident and broadcasts the telemetry live to all connected clients.
  Future<Incident> reportIncident(
    Session session,
    Incident incident,
  ) async {
    final inserted = await Incident.db.insertRow(session, incident);
    await session.messages.postMessage(channelIncidentUpdates, inserted);
    return inserted;
  }

  /// Retrieves an incident by its [id].
  Future<Incident?> getIncidentById(
    Session session,
    int id,
  ) async {
    return await Incident.db.findById(session, id);
  }

  /// Retrieves all incidents occurring within a specific disaster zone.
  Future<List<Incident>> getIncidentsByZone(
    Session session,
    int zoneId,
  ) async {
    return await Incident.db.find(
      session,
      where: (t) => t.zoneId.equals(zoneId),
      orderBy: (t) => t.firstReportAt.desc(),
    );
  }

  /// Updates the status of an existing incident and broadcasts the update live.
  Future<Incident?> updateIncidentStatus(
    Session session,
    int incidentId,
    IncidentStatus status,
  ) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) {
      return null;
    }

    final isHandling =
        status == IncidentStatus.enRoute || status == IncidentStatus.onScene;
    int? responderId = incident.assignedResponderId;

    if (isHandling && responderId == null) {
      final authInfo = session.authenticated;
      if (authInfo != null) {
        try {
          final uuid = UuidValue.fromString(authInfo.authId);
          final responder = await Responder.db.findFirstRow(
            session,
            where: (t) => t.authUserId.equals(uuid),
          );
          if (responder != null) {
            responderId = responder.id;
          }
        } catch (_) {}
      }
    }

    final updated = incident.copyWith(
      status: status,
      assignedResponderId: isHandling
          ? (incident.assignedResponderId ?? responderId)
          : incident.assignedResponderId,
      acceptedAt: isHandling
          ? (incident.acceptedAt ?? DateTime.now())
          : incident.acceptedAt,
      resolvedAt: status == IncidentStatus.resolved
          ? (incident.resolvedAt ?? DateTime.now())
          : incident.resolvedAt,
    );
    final saved = await Incident.db.updateRow(session, updated);
    await session.messages.postMessage(channelIncidentUpdates, saved);
    return saved;
  }

  /// Retrieves all recent incidents across all disaster zones.
  Future<List<Incident>> getAllRecentIncidents(
    Session session, {
    int limit = 50,
  }) async {
    return await Incident.db.find(
      session,
      orderBy: (t) => t.firstReportAt.desc(),
      limit: limit,
    );
  }

  /// Attaches an evidence image URL to an incident, persists it, and broadcasts the updated incident.
  Future<Incident?> attachEvidence(
    Session session,
    int incidentId,
    String evidenceUrl,
  ) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) return null;

    final updated = incident.copyWith(
      evidenceUrl: evidenceUrl,
    );
    final saved = await Incident.db.updateRow(session, updated);
    await session.messages.postMessage(channelIncidentUpdates, saved);
    return saved;
  }

  /// Creates a Serverpod cloud storage upload description for evidence files.
  Future<String?> getUploadDescription(
    Session session,
    String path,
  ) async {
    return await session.storage.createUploadDescription(
      storageId: 'public',
      path: path,
    );
  }

  /// Verifies upload completion in cloud storage and returns the public download URL.
  Future<String?> verifyUpload(
    Session session,
    String path,
  ) async {
    final verified = await session.storage.verifyUpload(
      storageId: 'public',
      path: path,
    );
    if (!verified) return null;
    final url = await session.storage.publicDownloadUrl(
      storageId: 'public',
      path: path,
    );
    return url.toString();
  }
}
