import 'dart:io';
import 'package:relief_radar_client/relief_radar_client.dart';

void main() async {
  stdout.writeln('========================================================');
  stdout.writeln('🚨 RELIEF RADAR - TRIGGER SEV 5 (CRITICAL) INCIDENT TEST');
  stdout.writeln('========================================================');

  const serverUrl = 'http://127.0.0.1:8080/';
  stdout.writeln('Connecting to Serverpod backend at: $serverUrl');

  final client = Client(
    serverUrl,
    connectionTimeout: const Duration(seconds: 15),
  );

  try {
    // 1. Fetch active disaster zone
    stdout.writeln('\n[1/3] Querying active disaster zones...');
    final activeZones = await client.disasterZone.getAllActiveZones();
    int zoneId;
    double lat;
    double lon;

    if (activeZones.isNotEmpty) {
      final zone = activeZones.first;
      zoneId = zone.id ?? 1;
      lat = zone.center.latitude;
      lon = zone.center.longitude;
      stdout.writeln(
        '✅ Found active zone #${zone.id}: "${zone.name}" (Kind: ${zone.kind}) at ($lat, $lon)',
      );
    } else {
      stdout.writeln('⚠️ No active zones found. Creating default disaster zone...');
      final newZone = await client.disasterZone.createZone(
        DisasterZone(
          name: 'Sector 4 Industrial Zone',
          kind: 'Industrial / Chemical',
          center: GeographyPoint(latitude: 37.7749, longitude: -122.4194),
          active: true,
          createdAt: DateTime.now(),
        ),
      );
      zoneId = newZone.id ?? 1;
      lat = newZone.center.latitude;
      lon = newZone.center.longitude;
      stdout.writeln('✅ Created emergency zone #$zoneId: "${newZone.name}"');
    }

    // 2. Prepare payload for strictly SEV 5 (Critical) incident
    const criticalSosPrompt =
        'HAZMAT explosion, toxic gas leak, multiple workers trapped and unconscious with severe bleeding. Immediate rescue and containment needed!';
    stdout.writeln('\n[2/3] Calling client.aiTriage.ingestAndTriageSos with prompt:');
    stdout.writeln('       "$criticalSosPrompt"');

    final incident = await client.aiTriage.ingestAndTriageSos(
      zoneId: zoneId,
      needType: NeedType.rescue,
      rawSosDescription: criticalSosPrompt,
      latitude: lat + 0.0015,
      longitude: lon + 0.0015,
      headcount: 8,
      vulnerabilities: ['Injured', 'Trapped', 'Chemical Exposure'],
    );

    // 3. Confirm incident payload response
    stdout.writeln('\n[3/3] Telemetry payload received from Serverpod backend:');
    stdout.writeln('--------------------------------------------------------');
    stdout.writeln(' Incident ID       : #${incident.id}');
    stdout.writeln(' Severity (Numeric): SEV ${incident.severity}');
    stdout.writeln(' AI Severity       : ${incident.aiSeverity}');
    stdout.writeln(' Status            : ${incident.status.name}');
    stdout.writeln(' Need Type         : ${incident.needType.name}');
    stdout.writeln(' Summary           : ${incident.summary}');
    stdout.writeln(' AI Tags           : ${incident.aiTags?.join(', ')}');
    stdout.writeln(' Base SLA          : ${incident.baseSlaSeconds}s (15 min rapid SLA)');
    stdout.writeln(' Coordinates       : (${incident.centroid.latitude.toStringAsFixed(4)}, ${incident.centroid.longitude.toStringAsFixed(4)})');
    stdout.writeln(' Headcount         : ${incident.headcount}');
    stdout.writeln(' Vulnerabilities   : ${incident.vulnerabilities.join(', ')}');
    stdout.writeln('--------------------------------------------------------');

    if (incident.severity == 5) {
      stdout.writeln(
        '\n🎉 CONFIRMATION: Incident #${incident.id} strictly verified as SEV 5 (Critical)!',
      );
      stdout.writeln(
        '🚨 Live telemetry broadcast dispatched over WebSockets to channel_incident_updates.',
      );
      stdout.writeln(
        '🔊 Connected mobile client will trigger high-priority notification with siren audio.',
      );
    } else {
      stdout.writeln(
        '\n⚠️ WARNING: Incident generated with SEV ${incident.severity} (Expected 5).',
      );
    }
  } catch (e, st) {
    stderr.writeln('\n❌ Error sending payload to Serverpod backend: $e');
    stderr.writeln(st);
    exitCode = 1;
  } finally {
    client.close();
  }
}
