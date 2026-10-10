import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class DisasterZoneEndpoint extends Endpoint {
  /// Creates a new disaster zone.
  Future<DisasterZone> createZone(
    Session session,
    DisasterZone zone,
  ) async {
    return await DisasterZone.db.insertRow(session, zone);
  }

  /// Retrieves a disaster zone by its [id].
  Future<DisasterZone?> getZoneById(
    Session session,
    int id,
  ) async {
    return await DisasterZone.db.findById(session, id);
  }

  /// Retrieves all currently active disaster zones.
  Future<List<DisasterZone>> getAllActiveZones(Session session) async {
    return await DisasterZone.db.find(
      session,
      where: (t) => t.active.equals(true),
      orderBy: (t) => t.createdAt.desc(),
    );
  }
}
