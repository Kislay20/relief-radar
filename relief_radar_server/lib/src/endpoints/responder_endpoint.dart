import 'package:serverpod/serverpod.dart' hide Responder;

import '../generated/protocol.dart';

class ResponderEndpoint extends Endpoint {
  /// Updates the current geographical location of a responder and records the timestamp.
  Future<Responder?> updateLocation(
    Session session,
    int responderId,
    GeographyPoint location,
  ) async {
    final responder = await Responder.db.findById(session, responderId);
    if (responder == null) {
      return null;
    }

    final updated = responder.copyWith(
      location: location,
      lastSeenAt: DateTime.now(),
    );
    return await Responder.db.updateRow(session, updated);
  }

  /// Retrieves the profile of a responder by their [responderId].
  Future<Responder?> getResponderProfile(
    Session session,
    int responderId,
  ) async {
    return await Responder.db.findById(session, responderId);
  }

  static const String channelResponderTracking = 'responder_tracking';

  /// Streams live responder location telemetry over WebSockets in real time.
  Stream<ResponderLocation> watchResponderLocations(Session session) async* {
    final stream = session.messages.createStream<ResponderLocation>(
      channelResponderTracking,
    );
    await for (final location in stream) {
      yield location;
    }
  }

  /// Records a responder location telemetry ping and broadcasts it via WebSocket message bus.
  Future<ResponderLocation> trackLocation(
    Session session,
    int responderId,
    double latitude,
    double longitude,
    String status,
  ) async {
    final entry = ResponderLocation(
      responderId: responderId,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      status: status,
    );
    final saved = await ResponderLocation.db.insertRow(session, entry);
    // Broadcast live telemetry update over Serverpod message channel
    await session.messages.postMessage(channelResponderTracking, saved);
    return saved;
  }

  /// Retrieves recent location history for a responder.
  Future<List<ResponderLocation>> getLocationHistory(
    Session session,
    int responderId, {
    int limit = 50,
  }) async {
    return await ResponderLocation.db.find(
      session,
      where: (t) => t.responderId.equals(responderId),
      orderBy: (t) => t.timestamp.desc(),
      limit: limit,
    );
  }
}
