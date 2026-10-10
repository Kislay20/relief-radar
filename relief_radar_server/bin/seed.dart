import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:relief_radar_client/relief_radar_client.dart';

void main() async {
  stdout.writeln(
    'Connecting to Relief Radar backend on http://10.175.65.55:8080/ ...',
  );
  final client = Client('http://10.175.65.55:8080/');

  try {
    final success = await client.ops.seedMockData();
    if (success) {
      stdout.writeln(
        '✅ Successfully seeded mock Disaster Zones and Incidents!',
      );
      stdout.writeln(
        'Active zones and incidents are now available in your PostgreSQL database.',
      );
    } else {
      stderr.writeln('❌ Backend returned false when seeding data.');
    }
  } catch (e) {
    stderr.writeln('❌ Failed to seed data: $e');
  } finally {
    client.close();
  }
}
