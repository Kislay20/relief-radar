import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:relief_radar_client/relief_radar_client.dart';

/// Simulates a real-time incoming incident to test WebSocket streaming telemetry.
/// Run from the server folder:
///   dart run bin/test_live_incident.dart
void main(List<String> args) async {
  final targetUrl = args.isNotEmpty ? args[0] : 'http://10.175.65.55:8080/';

  stdout.writeln('====================================================');
  stdout.writeln('🚨 RELIEF RADAR - LIVE TELEMETRY SIMULATOR');
  stdout.writeln('====================================================');
  stdout.writeln('Connecting to backend: $targetUrl');

  final client = Client(targetUrl);

  try {
    stdout.writeln('Fetching active disaster zones...');
    List<DisasterZone> zones = [];
    try {
      zones = await client.disasterZone.getAllActiveZones();
    } catch (_) {
      stdout.writeln('Trying fallback localhost:8080...');
    }

    if (zones.isEmpty) {
      stdout.writeln(
        'No active zones found or primary IP failed, checking localhost...',
      );
      final fallbackClient = Client('http://localhost:8080/');
      try {
        zones = await fallbackClient.disasterZone.getAllActiveZones();
        if (zones.isNotEmpty) {
          client.close();
          // proceed with fallback client
          return await _dispatchIncident(fallbackClient, zones.first);
        }
      } catch (e) {
        stderr.writeln('Unable to connect to server: $e');
        stderr.writeln('Please ensure Serverpod is running: serverpod start');
        return;
      }
    }

    await _dispatchIncident(client, zones.isNotEmpty ? zones.first : null);
  } catch (e) {
    stderr.writeln('❌ Error simulating incident: $e');
  } finally {
    client.close();
  }
}

Future<void> _dispatchIncident(Client client, DisasterZone? zone) async {
  final zoneId = zone?.id ?? 1;
  final zoneName = zone?.name ?? 'Sector 4 Operations Area';

  // Introduce small random offset so consecutive test runs place pins in slightly different spots
  final timestamp = DateTime.now().millisecondsSinceEpoch % 1000;
  final latOffset = (timestamp % 20 - 10) * 0.0008;
  final lonOffset = ((timestamp ~/ 20) % 20 - 10) * 0.0008;

  final baseLat = zone?.center.latitude ?? 19.0760;
  final baseLon = zone?.center.longitude ?? 72.8777;

  final incidentLat = baseLat + latOffset;
  final incidentLon = baseLon + lonOffset;

  stdout.writeln('Target Zone: $zoneName (ID: $zoneId)');
  stdout.writeln('Incident Coordinates: ($incidentLat, $incidentLon)');
  stdout.writeln('Broadcasting live emergency incident over WebSocket...');

  final testIncident = Incident(
    zoneId: zoneId,
    needType: NeedType.rescue,
    status: IncidentStatus.open,
    severity: 5,
    vulnerabilities: ['elderly', 'infant'],
    summary:
        '🚨 CRITICAL FLASH TELEMETRY [#$timestamp]: Rapid flood surge trapped 5 civilians. Immediate boat evacuation required!',
    centroid: GeographyPoint(
      latitude: incidentLat,
      longitude: incidentLon,
    ),
    accuracyRadiusM: 20.0,
    baseSlaSeconds: 900,
    dispatchRadiusM: 600.0,
  );

  final reported = await client.incident.reportIncident(testIncident);

  stdout.writeln('----------------------------------------------------');
  stdout.writeln('✅ INCIDENT BROADCASTED SUCCESSFULLY!');
  stdout.writeln('Incident ID: #${reported.id}');
  stdout.writeln('Need Type:   ${reported.needType.name.toUpperCase()}');
  stdout.writeln('Severity:    ${reported.severity} / 5 (CRITICAL)');
  stdout.writeln('Summary:     ${reported.summary}');
  stdout.writeln(
    'Location:    Lat ${reported.centroid.latitude}, Lon ${reported.centroid.longitude}',
  );
  stdout.writeln('----------------------------------------------------');
  stdout.writeln('👀 Check the Relief Radar Flutter App now!');
  stdout.writeln(
    'The new incident and pin will appear LIVE via WebSocket without pulling to refresh.',
  );
  stdout.writeln('====================================================');
}
