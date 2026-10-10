import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:latlong2/latlong.dart';
import 'package:relief_radar_flutter/src/services/routing_service.dart';

void main() {
  group('RoutingService', () {
    test(
      'successfully parses OSRM GeoJSON response and converts units',
      () async {
        final mockResponse = {
          'code': 'Ok',
          'routes': [
            {
              'distance': 2500.0, // 2500m -> 2.5km
              'duration': 300.0, // 300s -> 5min
              'geometry': {
                'type': 'LineString',
                'coordinates': [
                  [72.8750, 19.0730],
                  [72.8760, 19.0740],
                  [72.8777, 19.0760],
                ],
              },
            },
          ],
        };

        final mockClient = MockClient((request) async {
          expect(request.url.host, 'router.project-osrm.org');
          expect(
            request.url.path,
            '/route/v1/driving/72.875,19.073;72.8777,19.076',
          );
          return http.Response(jsonEncode(mockResponse), 200);
        });

        final routingService = RoutingService(client: mockClient);
        final route = await routingService.getRoute(
          const LatLng(19.0730, 72.8750),
          const LatLng(19.0760, 72.8777),
        );

        expect(route, isNotNull);
        expect(route!.coordinates.length, 3);
        expect(route.coordinates[0].latitude, 19.0730);
        expect(route.coordinates[0].longitude, 72.8750);
        expect(route.coordinates[2].latitude, 19.0760);
        expect(route.coordinates[2].longitude, 72.8777);

        expect(route.distanceKm, 2.5);
        expect(route.distanceText, '2.5 km');

        expect(route.durationMinutes, 5.0);
        expect(route.etaText, '5 min');
      },
    );

    test('returns null gracefully on non-200 or error status', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final routingService = RoutingService(client: mockClient);
      final route = await routingService.getRoute(
        const LatLng(19.0730, 72.8750),
        const LatLng(19.0760, 72.8777),
      );

      expect(route, isNull);
    });

    test(
      'RouteInfo formats short and long distances and durations properly',
      () {
        const shortRoute = RouteInfo(
          coordinates: [LatLng(10, 10)],
          distanceKm: 0.45,
          durationMinutes: 0.8,
        );
        expect(shortRoute.distanceText, '450 m');
        expect(shortRoute.etaText, '< 1 min');

        const longRoute = RouteInfo(
          coordinates: [LatLng(10, 10)],
          distanceKm: 65.4,
          durationMinutes: 75.0,
        );
        expect(longRoute.distanceText, '65.4 km');
        expect(longRoute.etaText, '1h 15m');
      },
    );
  });
}
