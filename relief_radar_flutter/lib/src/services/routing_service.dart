import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Holds parsed geospatial route coordinates, distance, and ETA metadata.
class RouteInfo {
  final List<LatLng> coordinates;
  final double distanceKm;
  final double durationMinutes;

  const RouteInfo({
    required this.coordinates,
    required this.distanceKm,
    required this.durationMinutes,
  });

  /// Formatted distance string (e.g., "1.4 km" or "450 m").
  String get distanceText {
    if (distanceKm < 1.0) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Formatted duration string (e.g., "7 min", "< 1 min", "1h 15m").
  String get etaText {
    if (durationMinutes < 1.0) {
      return '< 1 min';
    } else if (durationMinutes >= 60.0) {
      final hours = (durationMinutes / 60.0).floor();
      final mins = (durationMinutes % 60.0).round();
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    } else {
      return '${durationMinutes.round()} min';
    }
  }
}

/// Service that queries the public Open Source Routing Machine (OSRM) API
/// to calculate driving routes, coordinates, distance, and ETA.
class RoutingService {
  final http.Client _client;

  RoutingService({http.Client? client}) : _client = client ?? http.Client();

  static final RoutingService instance = RoutingService();

  /// Queries the public OSRM API for driving routes between [start] and [destination].
  ///
  /// URL format:
  /// `http://router.project-osrm.org/route/v1/driving/{lon1},{lat1};{lon2},{lat2}?geometries=geojson&overview=full`
  Future<RouteInfo?> getRoute(LatLng start, LatLng destination) async {
    final lon1 = start.longitude;
    final lat1 = start.latitude;
    final lon2 = destination.longitude;
    final lat2 = destination.latitude;

    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/$lon1,$lat1;$lon2,$lat2?geometries=geojson&overview=full',
    );

    try {
      final response = await _client
          .get(url)
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        debugPrint(
          '[RoutingService] HTTP ${response.statusCode}: ${response.body}',
        );
        return null;
      }

      final dynamic data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        debugPrint('[RoutingService] Invalid JSON format received');
        return null;
      }

      final code = data['code'];
      if (code != 'Ok') {
        debugPrint('[RoutingService] OSRM responded with non-Ok status: $code');
        return null;
      }

      final routes = data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) {
        debugPrint('[RoutingService] No routes found');
        return null;
      }

      final firstRoute = routes.first as Map<String, dynamic>;
      final geometry = firstRoute['geometry'] as Map<String, dynamic>?;
      final rawCoords = geometry?['coordinates'] as List<dynamic>?;

      final coordinates = <LatLng>[];
      if (rawCoords != null) {
        for (final item in rawCoords) {
          if (item is List && item.length >= 2) {
            final lon = (item[0] as num).toDouble();
            final lat = (item[1] as num).toDouble();
            // In GeoJSON: [lon, lat] -> LatLng(lat, lon)
            coordinates.add(LatLng(lat, lon));
          }
        }
      }

      final distanceMeters =
          (firstRoute['distance'] as num?)?.toDouble() ?? 0.0;
      final durationSeconds =
          (firstRoute['duration'] as num?)?.toDouble() ?? 0.0;

      // Distance converted from meters to KM
      final distanceKm = distanceMeters / 1000.0;
      // Duration converted from seconds to minutes
      final durationMinutes = durationSeconds / 60.0;

      return RouteInfo(
        coordinates: coordinates,
        distanceKm: distanceKm,
        durationMinutes: durationMinutes,
      );
    } catch (e) {
      debugPrint('[RoutingService] Error querying route from OSRM: $e');
      return null;
    }
  }

  /// Convenient static helper to fetch a route between [start] and [destination].
  static Future<RouteInfo?> calculateRoute(LatLng start, LatLng destination) =>
      instance.getRoute(start, destination);
}
