import 'package:relief_radar_server/src/endpoints/responder_endpoint.dart';
import 'package:relief_radar_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' hide Responder;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Core Endpoints', (sessionBuilder, endpoints) {
    test('DisasterZoneEndpoint operations', () async {
      // 1. Create Zone
      final newZone = DisasterZone(
        name: 'Sector 4 Flood',
        kind: 'flood',
        center: GeographyPoint(latitude: 25.3176, longitude: 82.9739),
        active: true,
      );
      final createdZone = await endpoints.disasterZone.createZone(
        sessionBuilder,
        newZone,
      );
      expect(createdZone.id, isNotNull);
      expect(createdZone.name, 'Sector 4 Flood');

      // 2. Get Zone By Id
      final fetchedZone = await endpoints.disasterZone.getZoneById(
        sessionBuilder,
        createdZone.id!,
      );
      expect(fetchedZone, isNotNull);
      expect(fetchedZone!.name, 'Sector 4 Flood');

      // 3. Get All Active Zones
      final activeZones = await endpoints.disasterZone.getAllActiveZones(
        sessionBuilder,
      );
      expect(activeZones.any((z) => z.id == createdZone.id), isTrue);
    });

    test('IncidentEndpoint operations', () async {
      // Setup zone first
      final zone = await endpoints.disasterZone.createZone(
        sessionBuilder,
        DisasterZone(
          name: 'Sector 5 Quake',
          kind: 'quake',
          center: GeographyPoint(latitude: 28.6139, longitude: 77.2090),
        ),
      );

      // 1. Report Incident
      final newIncident = Incident(
        zoneId: zone.id!,
        needType: NeedType.medical,
        status: IncidentStatus.open,
        severity: 4,
        vulnerabilities: ['injured'],
        summary: 'Medical assistance requested at relief camp',
        centroid: GeographyPoint(latitude: 28.6140, longitude: 77.2095),
        accuracyRadiusM: 25.0,
        baseSlaSeconds: 1800,
        dispatchRadiusM: 500.0,
      );
      final reported = await endpoints.incident.reportIncident(
        sessionBuilder,
        newIncident,
      );
      expect(reported.id, isNotNull);
      expect(reported.status, IncidentStatus.open);

      // 2. Get Incident By Id
      final fetched = await endpoints.incident.getIncidentById(
        sessionBuilder,
        reported.id!,
      );
      expect(fetched, isNotNull);
      expect(fetched!.summary, reported.summary);

      // 3. Get Incidents By Zone
      final zoneIncidents = await endpoints.incident.getIncidentsByZone(
        sessionBuilder,
        zone.id!,
      );
      expect(zoneIncidents.any((i) => i.id == reported.id), isTrue);

      // 4. Update Incident Status
      final updated = await endpoints.incident.updateIncidentStatus(
        sessionBuilder,
        reported.id!,
        IncidentStatus.assigned,
      );
      expect(updated, isNotNull);
      expect(updated!.status, IncidentStatus.assigned);
    });

    test('ResponderEndpoint operations', () async {
      // Seed a responder in DB using sessionBuilder.build()
      final session = sessionBuilder.build();
      final responder = await Responder.db.insertRow(
        session,
        Responder(
          authUserId: UuidValue.fromString(
            'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
          ),
          displayName: 'Officer Davis',
          capabilities: [NeedType.rescue, NeedType.medical],
          capacity: 3,
          status: ResponderStatus.available,
          location: GeographyPoint(latitude: 12.9716, longitude: 77.5946),
        ),
      );
      expect(responder.id, isNotNull);

      // 1. Get Responder Profile
      final profile = await endpoints.responder.getResponderProfile(
        sessionBuilder,
        responder.id!,
      );
      expect(profile, isNotNull);
      expect(profile!.displayName, 'Officer Davis');

      // 2. Update Location
      final newLocation = GeographyPoint(latitude: 12.9750, longitude: 77.6000);
      final responderEndpoint = ResponderEndpoint();
      final updated = await responderEndpoint.updateLocation(
        session,
        responder.id!,
        newLocation,
      );
      expect(updated, isNotNull);
      expect(updated!.location?.latitude, closeTo(12.9750, 0.0001));
      expect(updated.location?.longitude, closeTo(77.6000, 0.0001));
      expect(updated.lastSeenAt, isNotNull);
    });
  });
}
