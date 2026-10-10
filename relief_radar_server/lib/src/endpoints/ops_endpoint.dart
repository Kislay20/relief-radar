import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'incident_endpoint.dart';

class OpsEndpoint extends Endpoint {
  /// Streams real-time incident telemetry over WebSockets to connected tactical clients.
  Stream<Incident> watchIncidents(Session session) async* {
    final updateStream = session.messages.createStream<Incident>(
      IncidentEndpoint.channelIncidentUpdates,
    );
    await for (final incident in updateStream) {
      yield incident;
    }
  }

  Future<bool> smokeTest(Session session) async {
    final zone = await DisasterZone.db.insertRow(
      session,
      DisasterZone(
        name: 'Smoke Test Zone',
        kind: 'flood',
        center: GeographyPoint(
          latitude: 37.7749,
          longitude: -122.4194,
        ),
      ),
    );

    final incident = await Incident.db.insertRow(
      session,
      Incident(
        zoneId: zone.id!,
        needType: NeedType.rescue,
        status: IncidentStatus.open,
        severity: 3,
        vulnerabilities: ['elderly'],
        summary: 'Smoke test incident',
        centroid: GeographyPoint(
          latitude: 37.7749,
          longitude: -122.4194,
        ),
        centroidEmbedding: Vector(List<double>.filled(768, 0.0)),
        accuracyRadiusM: 50.0,
        baseSlaSeconds: 3600,
        dispatchRadiusM: 1000.0,
      ),
    );

    return zone.id != null && incident.id != null;
  }

  /// Seeds realistic mock DisasterZone and Incident entities for testing.
  Future<bool> seedMockData(Session session) async {
    final zone1 = await DisasterZone.db.insertRow(
      session,
      DisasterZone(
        name: 'Sector 4 - Urban Inundation',
        kind: 'flood',
        active: true,
        center: GeographyPoint(
          latitude: 19.0760,
          longitude: 72.8777,
        ),
      ),
    );

    final zone2 = await DisasterZone.db.insertRow(
      session,
      DisasterZone(
        name: 'Coastal Surge Zone Bravo',
        kind: 'cyclone',
        active: true,
        center: GeographyPoint(
          latitude: 18.9220,
          longitude: 72.8347,
        ),
      ),
    );

    final zone3 = await DisasterZone.db.insertRow(
      session,
      DisasterZone(
        name: 'Eastern Hillside Landslide',
        kind: 'landslide',
        active: true,
        center: GeographyPoint(
          latitude: 19.1200,
          longitude: 72.9100,
        ),
      ),
    );

    final i1 = await Incident.db.insertRow(
      session,
      Incident(
        zoneId: zone1.id!,
        needType: NeedType.rescue,
        status: IncidentStatus.open,
        severity: 5,
        vulnerabilities: ['infant', 'elderly'],
        summary:
            'Critical rooftop evacuation: 6 civilians isolated due to flash flood surge.',
        centroid: GeographyPoint(
          latitude: 19.0765,
          longitude: 72.8780,
        ),
        centroidEmbedding: Vector(List<double>.filled(768, 0.0)),
        accuracyRadiusM: 25.0,
        baseSlaSeconds: 1800,
        dispatchRadiusM: 500.0,
      ),
    );
    await session.messages.postMessage(
      IncidentEndpoint.channelIncidentUpdates,
      i1,
    );

    final i2 = await Incident.db.insertRow(
      session,
      Incident(
        zoneId: zone1.id!,
        needType: NeedType.medical,
        status: IncidentStatus.onScene,
        severity: 4,
        vulnerabilities: ['trauma'],
        summary:
            'Urgent paramedic required: structural debris collapse injured 2 first responders.',
        centroid: GeographyPoint(
          latitude: 19.0740,
          longitude: 72.8760,
        ),
        centroidEmbedding: Vector(List<double>.filled(768, 0.0)),
        accuracyRadiusM: 30.0,
        baseSlaSeconds: 2400,
        dispatchRadiusM: 800.0,
      ),
    );
    await session.messages.postMessage(
      IncidentEndpoint.channelIncidentUpdates,
      i2,
    );

    final i3 = await Incident.db.insertRow(
      session,
      Incident(
        zoneId: zone2.id!,
        needType: NeedType.water,
        status: IncidentStatus.open,
        severity: 3,
        vulnerabilities: ['potable water shortage'],
        summary:
            'Ration delivery needed: 150 community members cut off from potable water.',
        centroid: GeographyPoint(
          latitude: 18.9230,
          longitude: 72.8350,
        ),
        centroidEmbedding: Vector(List<double>.filled(768, 0.0)),
        accuracyRadiusM: 50.0,
        baseSlaSeconds: 3600,
        dispatchRadiusM: 1000.0,
      ),
    );
    await session.messages.postMessage(
      IncidentEndpoint.channelIncidentUpdates,
      i3,
    );

    final i4 = await Incident.db.insertRow(
      session,
      Incident(
        zoneId: zone3.id!,
        needType: NeedType.shelter,
        status: IncidentStatus.resolved,
        severity: 2,
        vulnerabilities: ['displaced'],
        summary: 'Evacuees relocated safely to municipal shelter gymnasium.',
        centroid: GeographyPoint(
          latitude: 19.1210,
          longitude: 72.9110,
        ),
        centroidEmbedding: Vector(List<double>.filled(768, 0.0)),
        accuracyRadiusM: 40.0,
        baseSlaSeconds: 7200,
        dispatchRadiusM: 1200.0,
      ),
    );
    await session.messages.postMessage(
      IncidentEndpoint.channelIncidentUpdates,
      i4,
    );

    return true;
  }
}
