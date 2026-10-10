import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:path_provider/path_provider.dart';
import 'package:relief_radar_client/relief_radar_client.dart';

import '../../client.dart';
import '../services/routing_service.dart';
import '../theme/app_theme.dart';

/// Tactical Geospatial Radar Map Screen.
class TacticalMapScreen extends StatefulWidget {
  final List<DisasterZone> zones;
  final List<Incident> incidents;
  final Function(Incident incident, IncidentStatus status)? onStatusChanged;
  final LatLng? targetLocation;
  final Incident? initialSelectedIncident;
  final ValueNotifier<Incident?>? trackedIncidentNotifier;

  const TacticalMapScreen({
    super.key,
    required this.zones,
    required this.incidents,
    this.onStatusChanged,
    this.targetLocation,
    this.initialSelectedIncident,
    this.trackedIncidentNotifier,
  });

  @override
  State<TacticalMapScreen> createState() => _TacticalMapScreenState();
}

class _TacticalMapScreenState extends State<TacticalMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  Position? _currentPosition;
  bool _isLocating = false;
  String? _locationStatus;
  StreamSubscription<Position>? _positionStreamSub;

  // Live responder WebSocket tracking & GPS broadcasting
  final Map<int, ResponderLocation> _liveResponders = {};
  StreamSubscription<ResponderLocation>? _responderStreamSub;
  bool _isBroadcastingLocation = false;
  StreamSubscription<Position>? _broadcastLocationSub;

  // Geospatial Routing & Navigation State
  List<LatLng> activeRoute = [];
  String? etaText;
  String? distanceText;
  bool _isLoadingRoute = false;

  Incident? _selectedIncident;
  bool _showPinBanner = false;
  DisasterZone? _selectedZone;

  // Offline Evidence Media Paths: Incident ID -> local file path
  final Map<int, String> _incidentEvidenceMap = {};
  final ImagePicker _imagePicker = ImagePicker();
  bool _isCapturingEvidence = false;

  /// Normalizes evidence URL host so emulator/mobile devices can connect to the serverpod instance.
  String? _resolveEvidenceUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;
    final uri = Uri.tryParse(rawUrl);
    if (uri != null && (uri.host == '0.0.0.0' || uri.host == 'localhost')) {
      final clientUri = Uri.tryParse(client.host);
      if (clientUri != null && clientUri.host.isNotEmpty) {
        return uri.replace(host: clientUri.host).toString();
      }
    }
    return rawUrl;
  }

  /// Loads locally saved evidence photo from application documents directory if available.
  Future<void> _loadSavedEvidence(int incidentId) async {
    if (_incidentEvidenceMap.containsKey(incidentId)) return;
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final evidenceDir = Directory('${docsDir.path}/evidence');
      if (await evidenceDir.exists()) {
        final matching = evidenceDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.contains('incident_${incidentId}_'))
            .toList();
        if (matching.isNotEmpty && mounted) {
          matching.sort(
            (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
          );
          setState(() {
            _incidentEvidenceMap[incidentId] = matching.first.path;
          });
        }
      }
    } catch (e) {
      debugPrint('[Offline Camera] Error checking saved evidence: $e');
    }
  }

  /// Captures evidence photo via Camera (with gallery fallback), saving locally and uploading to Serverpod Cloud Storage.
  Future<void> _captureEvidencePhoto(Incident incident) async {
    if (incident.id == null || _isCapturingEvidence) return;
    setState(() => _isCapturingEvidence = true);

    try {
      XFile? image;
      try {
        image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1080,
        );
      } catch (e) {
        debugPrint(
          '[Offline Camera] Camera pick failed ($e), falling back to gallery...',
        );
        image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
      }

      if (image != null) {
        final docsDir = await getApplicationDocumentsDirectory();
        final evidenceDir = Directory('${docsDir.path}/evidence');
        if (!await evidenceDir.exists()) {
          await evidenceDir.create(recursive: true);
        }

        final targetPath =
            '${evidenceDir.path}/incident_${incident.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(image.path).copy(targetPath);

        if (mounted) {
          setState(() {
            _incidentEvidenceMap[incident.id!] = targetPath;
          });
        }

        // Upload to Serverpod Cloud Storage
        bool cloudSyncSucceeded = false;
        try {
          final fileBytes = await File(targetPath).readAsBytes();
          final byteData = ByteData.view(fileBytes.buffer);
          final storagePath =
              'evidence/incident_${incident.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

          final uploadDescription = await client.incident.getUploadDescription(
            storagePath,
          );
          if (uploadDescription != null) {
            final uploader = FileUploader(uploadDescription);
            final uploaded = await uploader.uploadByteData(byteData);
            if (uploaded) {
              final publicUrl = await client.incident.verifyUpload(storagePath);
              if (publicUrl != null) {
                final updated = await client.incident.attachEvidence(
                  incident.id!,
                  publicUrl,
                );
                if (updated != null) {
                  cloudSyncSucceeded = true;
                  if (mounted) {
                    setState(() {
                      _selectedIncident = updated;
                    });
                  }
                }
              }
            }
          }
        } catch (uploadError) {
          debugPrint(
            '[Evidence Cloud Sync] Upload failed: $uploadError. Local copy preserved.',
          );
        }

        if (mounted) {
          AppTheme.showTacticalSnackbar(
            context,
            cloudSyncSucceeded
                ? 'Evidence synced to Cloud Storage for Incident #${incident.id}'
                : 'Evidence saved locally (offline mode). Cloud sync pending.',
            isSuccess: cloudSyncSucceeded,
            icon: cloudSyncSucceeded
                ? Icons.cloud_done_rounded
                : Icons.cloud_off_rounded,
          );
        }
      }
    } catch (e) {
      debugPrint('[Offline Camera] Error capturing photo: $e');
      if (mounted) {
        AppTheme.showTacticalSnackbar(
          context,
          'Failed to capture evidence: $e',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCapturingEvidence = false);
      }
    }
  }

  /// Opens full-resolution preview modal for captured or cloud-synced evidence image.
  void _showEvidencePreviewDialog({String? localPath, String? cloudUrl}) {
    final hasLocal = localPath != null && File(localPath).existsSync();
    final resolvedCloudUrl = _resolveEvidenceUrl(cloudUrl);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF151C24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        resolvedCloudUrl != null
                            ? Icons.cloud_done_rounded
                            : Icons.photo_library_rounded,
                        color: resolvedCloudUrl != null
                            ? const Color(0xFF00E676)
                            : const Color(0xFF00E5FF),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        resolvedCloudUrl != null
                            ? 'CLOUD EVIDENCE'
                            : 'OFFLINE EVIDENCE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: hasLocal
                    ? Image.file(
                        File(localPath),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPreviewError(),
                      )
                    : (resolvedCloudUrl != null
                          ? Image.network(
                              resolvedCloudUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 180,
                                  color: Colors.black26,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00E5FF),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPreviewError(),
                            )
                          : _buildPreviewError()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    resolvedCloudUrl != null
                        ? Icons.cloud_done_rounded
                        : Icons.sd_card_alert_rounded,
                    color: resolvedCloudUrl != null
                        ? const Color(0xFF00E676)
                        : const Color(0xFFFFB74D),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      resolvedCloudUrl != null
                          ? 'Synced to Cloud: $resolvedCloudUrl'
                          : 'Stored locally: $localPath',
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewError() {
    return Container(
      height: 180,
      color: Colors.black26,
      child: const Center(
        child: Text(
          'Failed to load evidence image',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // Default coordinate center (Mumbai / Disaster Sector 4 default)
  static const LatLng _defaultCenter = LatLng(19.0760, 72.8777);

  /// Computes geospatial driving route to [incident] from user location using OSRM.
  Future<void> _fetchRouteForIncident(Incident incident) async {
    setState(() {
      _isLoadingRoute = true;
    });

    try {
      LatLng? userLocation;
      if (_currentPosition != null) {
        userLocation = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      } else {
        try {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 5),
            ),
          );
          if (mounted) {
            setState(() {
              _currentPosition = pos;
            });
          }
          userLocation = LatLng(pos.latitude, pos.longitude);
        } catch (e) {
          debugPrint('[MapScreen] Could not obtain current GPS location: $e');
        }
      }

      userLocation ??= _defaultCenter;

      final incidentLocation = LatLng(
        incident.centroid.latitude,
        incident.centroid.longitude,
      );

      final routeInfo = await RoutingService.instance.getRoute(
        userLocation,
        incidentLocation,
      );

      if (!mounted) return;

      if (routeInfo != null && routeInfo.coordinates.isNotEmpty) {
        setState(() {
          activeRoute = routeInfo.coordinates;
          etaText = routeInfo.etaText;
          distanceText = routeInfo.distanceText;
          _isLoadingRoute = false;
        });
      } else {
        // Fallback straight-line polyline if OSRM service is unreachable
        final distM = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          incidentLocation.latitude,
          incidentLocation.longitude,
        );
        final km = distM / 1000.0;
        final estMins = (km / 30.0 * 60).round();
        setState(() {
          activeRoute = [userLocation!, incidentLocation];
          distanceText = '${km.toStringAsFixed(1)} km';
          etaText = estMins < 1 ? '< 1 min' : '$estMins min';
          _isLoadingRoute = false;
        });
      }
    } catch (e) {
      debugPrint('[MapScreen] Error calculating route: $e');
      if (mounted) {
        setState(() {
          _isLoadingRoute = false;
        });
      }
    }
  }

  /// Clears active geospatial polyline and ETA information.
  void _clearRoute() {
    setState(() {
      activeRoute = [];
      etaText = null;
      distanceText = null;
      _isLoadingRoute = false;
    });
  }

  /// Reverts a claimed incident back to open and clears navigation routes.
  void _unclaimIncident(Incident incident) {
    final updated = incident.copyWith(
      status: IncidentStatus.open,
    );
    widget.onStatusChanged?.call(incident, IncidentStatus.open);
    setState(() {
      _selectedIncident = updated;
    });
    _clearRoute();
  }

  @override
  void initState() {
    super.initState();
    _initGeolocation();
    _initResponderTrackingStream();

    if (widget.initialSelectedIncident != null) {
      _selectedIncident = widget.initialSelectedIncident;
      _showPinBanner = false;
      if (_selectedIncident!.status == IncidentStatus.enRoute) {
        _fetchRouteForIncident(_selectedIncident!);
      }
    } else if (widget.trackedIncidentNotifier?.value != null) {
      _selectedIncident = widget.trackedIncidentNotifier!.value;
      _showPinBanner = false;
      if (_selectedIncident!.status == IncidentStatus.enRoute) {
        _fetchRouteForIncident(_selectedIncident!);
      }
    }

    widget.trackedIncidentNotifier?.addListener(_onTrackedIncidentChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final inc =
          widget.trackedIncidentNotifier?.value ??
          widget.initialSelectedIncident;
      if (inc != null) {
        focusIncident(inc, zoom: 16.5, showBanner: false);
      } else if (widget.targetLocation != null) {
        _animatedMapMove(widget.targetLocation!, 16.5);
      }
    });
  }

  void _onTrackedIncidentChanged() {
    final incident = widget.trackedIncidentNotifier?.value;
    if (incident != null && mounted) {
      focusIncident(incident, zoom: 16.5, showBanner: false);
    }
  }

  /// Sets focus on a specific incident, animates the map camera, and opens details.
  void focusIncident(
    Incident incident, {
    double zoom = 16.5,
    bool showBanner = false,
  }) {
    setState(() {
      _selectedIncident = incident;
      _showPinBanner = showBanner;
      _selectedZone = null;
    });

    if (incident.id != null) {
      _loadSavedEvidence(incident.id!);
    }

    if (incident.status == IncidentStatus.enRoute) {
      _fetchRouteForIncident(incident);
    } else {
      _clearRoute();
    }

    final target = LatLng(
      incident.centroid.latitude,
      incident.centroid.longitude,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _animatedMapMove(target, zoom);
    });
  }

  /// Smoothly animates the map camera to the target coordinates and zoom level.
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    try {
      final camera = _mapController.camera;
      final latTween = Tween<double>(
        begin: camera.center.latitude,
        end: destLocation.latitude,
      );
      final lngTween = Tween<double>(
        begin: camera.center.longitude,
        end: destLocation.longitude,
      );
      final zoomTween = Tween<double>(
        begin: camera.zoom,
        end: destZoom,
      );

      final controller = AnimationController(
        duration: const Duration(milliseconds: 650),
        vsync: this,
      );

      final animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      );

      controller.addListener(() {
        if (!mounted) return;
        _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
        );
      });

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          controller.dispose();
        }
      });

      controller.forward();
    } catch (_) {
      try {
        _mapController.move(destLocation, destZoom);
      } catch (_) {}
    }
  }

  @override
  void didUpdateWidget(covariant TacticalMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trackedIncidentNotifier != oldWidget.trackedIncidentNotifier) {
      oldWidget.trackedIncidentNotifier?.removeListener(
        _onTrackedIncidentChanged,
      );
      widget.trackedIncidentNotifier?.addListener(_onTrackedIncidentChanged);
    }

    if (widget.initialSelectedIncident != null &&
        widget.initialSelectedIncident != oldWidget.initialSelectedIncident) {
      focusIncident(
        widget.initialSelectedIncident!,
        zoom: 16.5,
        showBanner: false,
      );
    } else if (widget.targetLocation != null &&
        widget.targetLocation != oldWidget.targetLocation) {
      _animatedMapMove(widget.targetLocation!, 16.5);
    }

    if (_selectedIncident != null) {
      final updated = widget.incidents.firstWhere(
        (i) => i.id == _selectedIncident!.id,
        orElse: () => _selectedIncident!,
      );
      _selectedIncident = updated;
      if (updated.status != IncidentStatus.enRoute && activeRoute.isNotEmpty) {
        _clearRoute();
      }
    }
  }

  @override
  void dispose() {
    widget.trackedIncidentNotifier?.removeListener(_onTrackedIncidentChanged);
    _positionStreamSub?.cancel();
    _responderStreamSub?.cancel();
    _broadcastLocationSub?.cancel();
    super.dispose();
  }

  /// Initializes WebSocket streaming to listen for real-time responder movements.
  void _initResponderTrackingStream() {
    _responderStreamSub?.cancel();
    try {
      client.openStreamingConnection();
      _responderStreamSub = client.responder.watchResponderLocations().listen(
        (ResponderLocation loc) {
          if (mounted) {
            setState(() {
              _liveResponders[loc.responderId] = loc;
            });
          }
        },
        onError: (err) {
          debugPrint('[MapScreen] Responder tracking stream error: $err');
        },
      );
    } catch (e) {
      debugPrint('[MapScreen] Could not start responder tracking stream: $e');
    }
  }

  /// Toggles continuous live GPS broadcast of this device to command and other units.
  Future<void> _toggleBroadcastLocation() async {
    if (_isBroadcastingLocation) {
      _broadcastLocationSub?.cancel();
      _broadcastLocationSub = null;
      setState(() => _isBroadcastingLocation = false);

      if (mounted) {
        AppTheme.showTacticalSnackbar(
          context,
          'Live GPS Broadcasting PAUSED.',
          isSuccess: false,
          customColor: const Color(0xFF90A4AE),
          icon: Icons.pause_circle_outline_rounded,
          duration: const Duration(seconds: 2),
        );
      }
      return;
    }

    // Explicitly verify and request location permissions before broadcasting
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppTheme.showTacticalSnackbar(
            context,
            'GPS Location service is disabled on device.',
            isSuccess: false,
            icon: Icons.location_off_rounded,
            duration: const Duration(seconds: 3),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          AppTheme.showTacticalSnackbar(
            context,
            'Location permission denied. Cannot broadcast GPS position.',
            isSuccess: false,
            icon: Icons.location_off_rounded,
            duration: const Duration(seconds: 3),
          );
        }
        return;
      }
    } catch (e) {
      debugPrint('[MapScreen] Location permission error: $e');
      if (mounted) {
        AppTheme.showTacticalSnackbar(
          context,
          'Location permission error: $e',
          isSuccess: false,
          icon: Icons.warning_amber_rounded,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    if (!mounted) return;

    setState(() => _isBroadcastingLocation = true);

    // Start continuous GPS stream and push coordinates to Serverpod backend
    _broadcastLocationSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position pos) async {
          try {
            final user = sessionManager.signedInUser;
            final responderId = user?.id ?? 1;
            await client.responder.trackLocation(
              responderId,
              pos.latitude,
              pos.longitude,
              'active',
            );
          } catch (e) {
            debugPrint('[MapScreen] Error pushing live location: $e');
          }
        });

    // If current GPS position is already resolved, send an initial ping immediately
    if (_currentPosition != null) {
      final user = sessionManager.signedInUser;
      final responderId = user?.id ?? 1;
      client.responder
          .trackLocation(
            responderId,
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            'active',
          )
          .catchError((e) {
            debugPrint('[MapScreen] Initial location push error: $e');
            return ResponderLocation(
              responderId: responderId,
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude,
              status: 'active',
            );
          });
    }

    AppTheme.showTacticalSnackbar(
      context,
      'BROADCAST ACTIVE: Pushing live telemetry to Command.',
      isSuccess: true,
      customColor: const Color(0xFF00E5FF),
      icon: Icons.wifi_tethering,
      duration: const Duration(seconds: 3),
    );
  }

  /// Initializes geolocation tracking and requests permissions.
  Future<void> _initGeolocation() async {
    setState(() => _isLocating = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationStatus = 'GPS Service is disabled on device';
          _isLocating = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus = 'Location permission denied';
            _isLocating = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = 'Location permission permanently denied';
          _isLocating = false;
        });
        return;
      }

      // Fetch initial position
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      if (mounted) {
        setState(() {
          _currentPosition = pos;
          _locationStatus = 'GPS Connected';
          _isLocating = false;
        });

        // Center map on user if no target provided
        if (widget.targetLocation == null) {
          _mapController.move(LatLng(pos.latitude, pos.longitude), 13.5);
        }
      }

      // Start live updates stream
      _positionStreamSub =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen((Position livePos) {
            if (mounted) {
              setState(() {
                _currentPosition = livePos;
              });
            }
          });
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationStatus = 'GPS Error: $e';
          _isLocating = false;
        });
      }
    }
  }

  /// Centers the map on the user's current GPS location.
  void _recenterOnUser() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15.0,
      );
    } else {
      _initGeolocation();
    }
  }

  /// Centers map to encompass all active disaster zones and incidents.
  void _fitAllMarkers() {
    if (widget.zones.isEmpty && widget.incidents.isEmpty) {
      _mapController.move(_defaultCenter, 12.0);
      return;
    }

    double minLat = 90.0, maxLat = -90.0, minLon = 180.0, maxLon = -180.0;

    for (final z in widget.zones) {
      if (z.center.latitude < minLat) minLat = z.center.latitude;
      if (z.center.latitude > maxLat) maxLat = z.center.latitude;
      if (z.center.longitude < minLon) minLon = z.center.longitude;
      if (z.center.longitude > maxLon) maxLon = z.center.longitude;
    }

    for (final i in widget.incidents) {
      if (i.centroid.latitude < minLat) minLat = i.centroid.latitude;
      if (i.centroid.latitude > maxLat) maxLat = i.centroid.latitude;
      if (i.centroid.longitude < minLon) minLon = i.centroid.longitude;
      if (i.centroid.longitude > maxLon) maxLon = i.centroid.longitude;
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLon = (minLon + maxLon) / 2;

    _mapController.move(LatLng(centerLat, centerLon), 12.5);
  }

  /// Simulates a field responder GPS location for testing on physical devices or emulators.
  void _simulateMockLocation() {
    final mockPos = Position(
      latitude: 19.0730,
      longitude: 72.8750,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 10.0,
      altitudeAccuracy: 1.0,
      heading: 0.0,
      headingAccuracy: 1.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    setState(() {
      _currentPosition = mockPos;
      _locationStatus = 'Mock Location Activated (Sector 4 Hub)';
    });

    _mapController.move(LatLng(mockPos.latitude, mockPos.longitude), 14.5);

    AppTheme.showTacticalSnackbar(
      context,
      'Simulated responder location set near Sector 4 Hub.',
      isSuccess: true,
      customColor: const Color(0xFF00E5FF),
      icon: Icons.my_location_rounded,
      duration: const Duration(seconds: 2),
    );
  }

  double? _calculateDistanceTo(double targetLat, double targetLon) {
    if (_currentPosition == null) return null;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLat,
      targetLon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetInc =
        widget.trackedIncidentNotifier?.value ?? widget.initialSelectedIncident;

    final initialCenter = targetInc != null
        ? LatLng(targetInc.centroid.latitude, targetInc.centroid.longitude)
        : (widget.targetLocation ??
              (_currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  : (widget.zones.isNotEmpty
                        ? LatLng(
                            widget.zones.first.center.latitude,
                            widget.zones.first.center.longitude,
                          )
                        : _defaultCenter)));

    final initialZoom = (targetInc != null || widget.targetLocation != null)
        ? 16.5
        : 13.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1015),
      body: Stack(
        children: [
          // 1. FlutterMap Core View
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              minZoom: 4.0,
              maxZoom: 18.0,
              onTap: (_, _) {
                if (_selectedIncident != null || _selectedZone != null) {
                  setState(() {
                    _selectedIncident = null;
                    _showPinBanner = false;
                    _selectedZone = null;
                    _clearRoute();
                  });
                }
              },
            ),
            children: [
              // Dark Mode Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.relief_radar.app',
                // Night-mode tactical radar HUD color filter (dark inverted with electric cyan / navy tint)
                tileBuilder: (context, tileWidget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      -0.0425,
                      -0.1430,
                      -0.0144,
                      0,
                      58.0, // R: Deep obsidian slate
                      -0.1276, -0.4291, -0.0433, 0, 162.0, // G: Tactical teal
                      -0.1807,
                      -0.6079,
                      -0.0614,
                      0,
                      238.0, // B: Glowing electric cyan / radar blue
                      0, 0, 0, 1, 0, // A: Full opacity
                    ]),
                    child: tileWidget,
                  );
                },
              ),

              // Disaster Zones Hazard Area Circles
              CircleLayer(
                circles: widget.zones.map((zone) {
                  final color = _getZoneKindColor(zone.kind);
                  return CircleMarker(
                    point: LatLng(zone.center.latitude, zone.center.longitude),
                    radius: 900,
                    useRadiusInMeter: true,
                    color: color.withAlpha(45),
                    borderColor: color,
                    borderStrokeWidth: 2.0,
                  );
                }).toList(),
              ),

              // Geospatial Route Polyline Layer (Below markers, above tiles & circles)
              if (activeRoute.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: activeRoute,
                      strokeWidth: 5.5,
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.8),
                      borderColor: const Color(
                        0xFF003840,
                      ).withValues(alpha: 0.6),
                      borderStrokeWidth: 1.5,
                    ),
                  ],
                ),

              // Markers Layer: Zones + Incidents + User Location
              MarkerLayer(
                markers: [
                  // A. Disaster Zone Center Markers
                  ...widget.zones.map((zone) {
                    final isSelected = _selectedZone?.id == zone.id;
                    final color = _getZoneKindColor(zone.kind);
                    return Marker(
                      point: LatLng(
                        zone.center.latitude,
                        zone.center.longitude,
                      ),
                      width: 48,
                      height: 48,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedZone = zone;
                            _selectedIncident = null;
                            _showPinBanner = false;
                            _clearRoute();
                          });
                        },
                        child: AnimatedPulseMarker(
                          pulseColor: color,
                          pulseRadius: isSelected ? 36.0 : 30.0,
                          isPulsing: true,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: color.withAlpha(220),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: isSelected ? 3.0 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withAlpha(160),
                                  blurRadius: isSelected ? 14 : 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.radar_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // B. Incident Markers (Prominent Pin with Needle Anchor at (lat, lon))
                  ...widget.incidents.map((incident) {
                    final displayIncident =
                        (_selectedIncident?.id == incident.id)
                        ? _selectedIncident!
                        : incident;
                    final isSelected = _selectedIncident?.id == incident.id;
                    final showBanner = isSelected && _showPinBanner;
                    final isHandled =
                        displayIncident.status == IncidentStatus.enRoute ||
                        displayIncident.status == IncidentStatus.onScene ||
                        displayIncident.status == IncidentStatus.assigned;
                    final severityColor = _getSeverityColor(
                      displayIncident.severity,
                    );
                    final pinColor = isHandled
                        ? const Color(0xFF00E5FF)
                        : severityColor;

                    final markerWidth = showBanner
                        ? 154.0
                        : (isSelected ? 48.0 : 46.0);
                    final markerHeight = showBanner
                        ? 94.0
                        : (isSelected ? 62.0 : 58.0);

                    return Marker(
                      point: LatLng(
                        incident.centroid.latitude,
                        incident.centroid.longitude,
                      ),
                      width: markerWidth,
                      height: markerHeight,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (incident.id != null) {
                            _loadSavedEvidence(incident.id!);
                          }
                          setState(() {
                            if (_selectedIncident?.id == incident.id) {
                              if (_showPinBanner) {
                                _selectedIncident = null;
                                _showPinBanner = false;
                                _clearRoute();
                              } else {
                                _showPinBanner = true;
                                if (incident.status == IncidentStatus.enRoute) {
                                  _fetchRouteForIncident(incident);
                                }
                              }
                            } else {
                              _selectedIncident = incident;
                              _showPinBanner = true;
                              _selectedZone = null;
                              if (incident.status == IncidentStatus.enRoute) {
                                _fetchRouteForIncident(incident);
                              } else {
                                _clearRoute();
                              }
                            }
                          });
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 1. Floating Tactical Callout Banner (when selected and banner opened)
                              if (showBanner) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0C1015,
                                    ).withAlpha(245),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: pinColor,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: pinColor.withAlpha(180),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: pinColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${isHandled ? "HANDLED • " : ""}SEV ${displayIncident.severity} • ${displayIncident.needType.name.toUpperCase()} #${displayIncident.id ?? ''}',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                              ],

                              // 2. Tactical Digital Radar Diamond Blip
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  AnimatedPulseMarker(
                                    pulseColor: pinColor,
                                    pulseRadius: isSelected ? 34.0 : 28.0,
                                    isPulsing: true,
                                    child: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: Container(
                                        width: isSelected ? 36 : 28,
                                        height: isSelected ? 36 : 28,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF0C1015,
                                          ).withValues(alpha: 0.90),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: pinColor,
                                            width: isSelected ? 2.2 : 1.6,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: pinColor.withValues(
                                                alpha: isSelected ? 0.75 : 0.45,
                                              ),
                                              blurRadius: isSelected ? 14 : 8,
                                              spreadRadius: isSelected ? 2 : 1,
                                            ),
                                          ],
                                        ),
                                        child: Transform.rotate(
                                          angle: -math.pi / 4,
                                          child: Center(
                                            child: Icon(
                                              isHandled
                                                  ? Icons.navigation_rounded
                                                  : (displayIncident.status ==
                                                            IncidentStatus
                                                                .resolved
                                                        ? Icons
                                                              .check_circle_outline_rounded
                                                        : Icons.crisis_alert),
                                              color: pinColor,
                                              size: isSelected ? 20 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Tactical Severity / Status HUD Pill
                                  Positioned(
                                    top: -6,
                                    right: -8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0C1015),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: pinColor,
                                          width: 1.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: pinColor.withValues(
                                              alpha: 0.35,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        isHandled
                                            ? 'ENR'
                                            : (displayIncident.status ==
                                                      IncidentStatus.resolved
                                                  ? 'OK'
                                                  : '${displayIncident.severity}'),
                                        style: TextStyle(
                                          fontFamily: 'ShareTechMono',
                                          color: pinColor,
                                          fontSize: isHandled ? 7.5 : 8.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // 3. Digital Crosshair Anchor Tick
                              Container(
                                width: 1.5,
                                height: isSelected ? 6 : 4,
                                color: pinColor.withValues(alpha: 0.75),
                              ),

                              // 4. Ground Target Reticle Pip (anchored to precise coordinate)
                              Container(
                                width: isSelected ? 5 : 4,
                                height: isSelected ? 5 : 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: pinColor,
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // C. Responder User GPS Marker
                  if (_currentPosition != null)
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 52,
                      height: 52,
                      child: AnimatedPulseMarker(
                        pulseColor: const Color(0xFF00E5FF),
                        pulseRadius: 36.0,
                        isPulsing: true,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withAlpha(160),
                                blurRadius: 16,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.navigation_rounded,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                  // D. Remote Responders Live Tracking Markers (Cyan/Blue Tactical Shields)
                  ..._liveResponders.values.map((resp) {
                    return Marker(
                      point: LatLng(resp.latitude, resp.longitude),
                      width: 64,
                      height: 72,
                      alignment: Alignment.topCenter,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Callout tag with unit ID
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A).withAlpha(245),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFF00E5FF),
                                  width: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x6600E5FF),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'UNIT #${resp.responderId}',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Color(0xFF00E5FF),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),

                            // Tactical Shield Icon Badge
                            AnimatedPulseMarker(
                              pulseColor: const Color(0xFF00E5FF),
                              pulseRadius: 28.0,
                              isPulsing: true,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0284C7),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xAA0284C7),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shield_rounded,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ),

                            // Needle Pointer
                            CustomPaint(
                              size: const Size(12, 7),
                              painter: _TacticalPinPointerPainter(
                                color: const Color(0xFF0284C7),
                                borderColor: Colors.white,
                                borderWidth: 1.4,
                              ),
                            ),

                            // Ground Target Dot
                            Container(
                              width: 5,
                              height: 3,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF00E5FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // 2. Proximity & Telemetry HUD Card (Top)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildProximityHud(),
          ),

          // 3. Floating Map Controls (Right Side)
          Positioned(
            bottom: _selectedIncident != null || _selectedZone != null
                ? (_selectedIncident?.status == IncidentStatus.enRoute
                      ? 360
                      : 300)
                : 84,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMapControl(
                  icon: Icons.add,
                  tooltip: 'Zoom In',
                  onTap: () {
                    final zoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, zoom + 1);
                  },
                ),
                const SizedBox(height: 8),
                _buildMapControl(
                  icon: Icons.remove,
                  tooltip: 'Zoom Out',
                  onTap: () {
                    final zoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, zoom - 1);
                  },
                ),
                const SizedBox(height: 12),
                _buildMapControl(
                  icon: Icons.filter_center_focus,
                  tooltip: 'Fit All Markers',
                  onTap: _fitAllMarkers,
                ),
                const SizedBox(height: 8),
                _buildMapControl(
                  icon: _isLocating
                      ? Icons.hourglass_top_rounded
                      : Icons.my_location_rounded,
                  tooltip: 'Center on My GPS',
                  iconColor: const Color(0xFF00E5FF),
                  onTap: _recenterOnUser,
                ),
                const SizedBox(height: 8),
                _buildMapControl(
                  icon: _isBroadcastingLocation
                      ? Icons.wifi_tethering
                      : Icons.wifi_tethering_off,
                  tooltip: _isBroadcastingLocation
                      ? 'Stop GPS Broadcast'
                      : 'Broadcast My Location',
                  iconColor: _isBroadcastingLocation
                      ? const Color(0xFF00E5FF)
                      : const Color(0xFF94A3B8),
                  backgroundColor: _isBroadcastingLocation
                      ? const Color(0xFF003840)
                      : null,
                  borderColor: _isBroadcastingLocation
                      ? const Color(0xFF00E5FF)
                      : null,
                  onTap: _toggleBroadcastLocation,
                ),
              ],
            ),
          ),

          // 4. Inspection Bottom Sheet (Elevated above FAB to prevent button obstruction)
          if (_selectedIncident != null)
            Positioned(
              bottom: 84,
              left: 14,
              right: 14,
              child: _buildIncidentDetailSheet(_selectedIncident!),
            ),

          if (_selectedZone != null)
            Positioned(
              bottom: 84,
              left: 14,
              right: 14,
              child: _buildZoneDetailSheet(_selectedZone!),
            ),
        ],
      ),
    );
  }

  /// Top Proximity and GPS Telemetry HUD.
  Widget _buildProximityHud() {
    double? nearestDistance;
    Incident? nearestIncident;

    if (_currentPosition != null && widget.incidents.isNotEmpty) {
      for (final inc in widget.incidents) {
        final d = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          inc.centroid.latitude,
          inc.centroid.longitude,
        );
        if (nearestDistance == null || d < nearestDistance) {
          nearestDistance = d;
          nearestIncident = inc;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151C24).withAlpha(240),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF283545), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(160),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // GPS Status Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _currentPosition != null
                  ? const Color(0xFF003840)
                  : const Color(0xFF3B1214),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _currentPosition != null
                  ? Icons.gps_fixed_rounded
                  : Icons.gps_off_rounded,
              color: _currentPosition != null
                  ? const Color(0xFF00E5FF)
                  : const Color(0xFFEF5350),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // HUD Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      _currentPosition != null
                          ? 'GPS ACTIVE: ${_currentPosition!.latitude.toStringAsFixed(3)}°, ${_currentPosition!.longitude.toStringAsFixed(3)}°'
                          : (_locationStatus ?? 'GPS NOT CONNECTED'),
                      style: TextStyle(
                        color: _currentPosition != null
                            ? const Color(0xFF00E5FF)
                            : const Color(0xFFEF5350),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    if (_isBroadcastingLocation)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003840),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFF00E5FF),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_tethering,
                              color: Color(0xFF00E5FF),
                              size: 10,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'BROADCASTING',
                              style: TextStyle(
                                color: Color(0xFF00E5FF),
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_currentPosition == null)
                      GestureDetector(
                        onTap: _simulateMockLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3844),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SIMULATE GPS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  nearestDistance != null && nearestIncident != null
                      ? 'NEAREST THREAT: ${nearestIncident.summary.substring(0, nearestIncident.summary.length > 35 ? 35 : nearestIncident.summary.length)}... (${(nearestDistance / 1000).toStringAsFixed(2)} km)'
                      : '${widget.incidents.length} active incidents plotted across ${widget.zones.length} sectors',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tactical Map Control Button.
  Widget _buildMapControl({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return TactileScaleButton(
      onTap: onTap,
      child: Material(
        color:
            backgroundColor ?? const Color(0xFF1E2732).withValues(alpha: 0.85),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color:
                borderColor ?? const Color(0xFF00E5FF).withValues(alpha: 0.35),
            width: 1.0,
          ),
        ),
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ),
      ),
    );
  }

  /// Bottom sheet showing details of selected incident.
  Widget _buildIncidentDetailSheet(Incident incident) {
    final severityColor = _getSeverityColor(incident.severity);
    final isResolved = incident.status == IncidentStatus.resolved;
    final isHandled =
        incident.status == IncidentStatus.enRoute ||
        incident.status == IncidentStatus.onScene ||
        incident.status == IncidentStatus.assigned;
    final effectiveThemeColor = isResolved
        ? const Color(0xFF2E7D32)
        : (isHandled ? const Color(0xFF00E5FF) : severityColor);

    final distanceMeters = _calculateDistanceTo(
      incident.centroid.latitude,
      incident.centroid.longitude,
    );

    final evidencePath = incident.id != null
        ? _incidentEvidenceMap[incident.id!]
        : null;

    return TweenAnimationBuilder<double>(
      key: ValueKey('incident_sheet_${incident.id}'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, animVal, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1.0 - animVal)),
          child: Opacity(
            opacity: animVal,
            child: child,
          ),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        glowColor: effectiveThemeColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(16),
        ),
        backgroundColor: const Color(0xFF1E2732).withValues(alpha: 0.75),
        borderColor: effectiveThemeColor.withValues(alpha: 0.65),
        borderWidth: 1.5,
        blurSigma: 12.0,
        boxShadow: [
          BoxShadow(
            color: effectiveThemeColor.withValues(alpha: 0.22),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Badges & Close
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveThemeColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: effectiveThemeColor),
                  ),
                  child: Text(
                    'SEV ${incident.severity}',
                    style: TextStyle(
                      color: effectiveThemeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2833),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    incident.needType.name.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: isHandled
                        ? const Color(0xFF00E5FF).withAlpha(35)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: isHandled
                        ? Border.all(color: const Color(0xFF00E5FF), width: 1.0)
                        : null,
                  ),
                  child: Text(
                    incident.status.name.toUpperCase(),
                    style: TextStyle(
                      color: isHandled
                          ? const Color(0xFF00E5FF)
                          : _getStatusColor(incident.status),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (distanceMeters != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003840),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${(distanceMeters / 1000).toStringAsFixed(2)} km away',
                      style: const TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() {
                    _selectedIncident = null;
                    _showPinBanner = false;
                    _clearRoute();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Incident Summary with Offline Evidence Thumbnail
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incident.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Coordinates & SLA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'POS: ${incident.centroid.latitude.toStringAsFixed(4)}°, ${incident.centroid.longitude.toStringAsFixed(4)}°',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            'SLA: ${incident.baseSlaSeconds}s',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Evidence Thumbnail (Local File or Cloud URL)
                if ((evidencePath != null && File(evidencePath).existsSync()) ||
                    (incident.evidenceUrl != null &&
                        incident.evidenceUrl!.isNotEmpty)) ...[
                  const SizedBox(width: 10),
                  Builder(
                    builder: (context) {
                      final hasLocal =
                          evidencePath != null &&
                          File(evidencePath).existsSync();
                      final hasCloud =
                          incident.evidenceUrl != null &&
                          incident.evidenceUrl!.isNotEmpty;
                      final effectiveBorderColor = hasCloud
                          ? const Color(0xFF00E676)
                          : const Color(0xFF00E5FF);

                      return GestureDetector(
                        onTap: () => _showEvidencePreviewDialog(
                          localPath: hasLocal ? evidencePath : null,
                          cloudUrl: hasCloud ? incident.evidenceUrl : null,
                        ),
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: effectiveBorderColor,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: effectiveBorderColor.withAlpha(90),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.5),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (hasLocal)
                                  Image.file(
                                    File(evidencePath),
                                    fit: BoxFit.cover,
                                  )
                                else if (hasCloud)
                                  Image.network(
                                    _resolveEvidenceUrl(incident.evidenceUrl)!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) => Container(
                                      color: Colors.black45,
                                      child: const Icon(
                                        Icons.broken_image_rounded,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      hasCloud
                                          ? Icons.cloud_done_rounded
                                          : Icons.zoom_in_rounded,
                                      color: hasCloud
                                          ? const Color(0xFF00E676)
                                          : Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Quick Action Status Buttons: Capture Evidence + Claim/EnRoute + Resolve
            Row(
              children: [
                // 1. Capture Evidence Camera Button
                TactileScaleButton(
                  onTap: _isCapturingEvidence
                      ? null
                      : () => _captureEvidencePhoto(incident),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF003840), Color(0xFF002229)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: const Color(0xFF00E5FF),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF00E5FF,
                          ).withValues(alpha: 0.25),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isCapturingEvidence)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF00E5FF),
                            ),
                          )
                        else
                          const Icon(
                            Icons.camera_alt_rounded,
                            size: 15,
                            color: Color(0xFF00E5FF),
                          ),
                        const SizedBox(width: 6),
                        Text(
                          (evidencePath != null ||
                                  (incident.evidenceUrl != null &&
                                      incident.evidenceUrl!.isNotEmpty))
                              ? 'RETAKE'
                              : 'CAPTURE EVIDENCE',
                          style: const TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 2. Task Assignment Button: MARK ON SCENE / CLAIMED / ENROUTE
                if (incident.status != IncidentStatus.resolved)
                  Expanded(
                    child: incident.status == IncidentStatus.enRoute
                        ? TactileScaleButton(
                            onTap: () {
                              final updated = incident.copyWith(
                                status: IncidentStatus.onScene,
                              );
                              widget.onStatusChanged?.call(
                                incident,
                                IncidentStatus.onScene,
                              );
                              setState(() {
                                _selectedIncident = updated;
                              });
                              _clearRoute();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00E5FF),
                                    Color(0xFF00B0FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00E5FF,
                                    ).withValues(alpha: 0.45),
                                    blurRadius: 12,
                                    spreadRadius: 1.5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 15,
                                    color: Color(0xFF0C1015),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'CLAIMED / ENROUTE',
                                    style: TextStyle(
                                      color: Color(0xFF0C1015),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : TactileScaleButton(
                            onTap: () {
                              final updated = incident.copyWith(
                                status: IncidentStatus.enRoute,
                                acceptedAt: DateTime.now(),
                              );
                              widget.onStatusChanged?.call(
                                incident,
                                IncidentStatus.enRoute,
                              );
                              setState(() {
                                _selectedIncident = updated;
                              });
                              _fetchRouteForIncident(updated);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFA726),
                                    Color(0xFFFF8F00),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: const Color(0xFFFFD54F),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFA726,
                                    ).withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.navigation_rounded,
                                    size: 15,
                                    color: Color(0xFF0C1015),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    incident.status == IncidentStatus.onScene
                                        ? 'ON SCENE (ACTIVE)'
                                        : 'MARK ON SCENE',
                                    style: const TextStyle(
                                      color: Color(0xFF0C1015),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),

                const SizedBox(width: 8),

                // 3. Resolve Incident Button
                TactileScaleButton(
                  onTap: () {
                    final updated = incident.copyWith(
                      status: IncidentStatus.resolved,
                      resolvedAt: DateTime.now(),
                    );
                    widget.onStatusChanged?.call(
                      incident,
                      IncidentStatus.resolved,
                    );
                    setState(() {
                      _selectedIncident = updated;
                    });
                    _clearRoute();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: const Color(0xFF81C784),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF2E7D32,
                          ).withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'RESOLVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 4. Geospatial ETA & Route Distance HUD (Visible when CLAIMED / ENROUTE)
            if (incident.status == IncidentStatus.enRoute) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF091722),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.55),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Color(0xFF00E5FF),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ESTIMATED ETA',
                                  style: TextStyle(
                                    color: Color(0xFFCBD5E1),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _isLoadingRoute
                                    ? const SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF00E5FF),
                                        ),
                                      )
                                    : Text(
                                        etaText ?? 'Calculating...',
                                        style: const TextStyle(
                                          color: Color(0xFF00E5FF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            height: 24,
                            width: 1,
                            color: const Color(0xFF1E293B),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ROUTE DISTANCE',
                                  style: TextStyle(
                                    color: Color(0xFFCBD5E1),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _isLoadingRoute
                                    ? const SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF00E5FF),
                                        ),
                                      )
                                    : Text(
                                        distanceText ?? 'Calculating...',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Recalculate Route',
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFF00E5FF),
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _fetchRouteForIncident(incident),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      tooltip: 'Unclaim Incident',
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFFEF5350),
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _unclaimIncident(incident),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Bottom sheet showing details of selected disaster zone.
  Widget _buildZoneDetailSheet(DisasterZone zone) {
    final color = _getZoneKindColor(zone.kind);
    final distanceMeters = _calculateDistanceTo(
      zone.center.latitude,
      zone.center.longitude,
    );

    return TweenAnimationBuilder<double>(
      key: ValueKey('zone_sheet_${zone.id}'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, animVal, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1.0 - animVal)),
          child: Opacity(
            opacity: animVal,
            child: child,
          ),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        glowColor: color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(16),
        ),
        backgroundColor: const Color(0xFF1E2732).withValues(alpha: 0.75),
        borderColor: color.withValues(alpha: 0.65),
        borderWidth: 1.5,
        blurSigma: 12.0,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    zone.kind.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'ACTIVE DISASTER SECTOR',
                  style: TextStyle(
                    color: Color(0xFF81C784),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (distanceMeters != null)
                  Text(
                    '${(distanceMeters / 1000).toStringAsFixed(2)} km away',
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() => _selectedZone = null),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              zone.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'CENTER: ${zone.center.latitude.toStringAsFixed(4)}°, ${zone.center.longitude.toStringAsFixed(4)}° | 900m Perimeter',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 5:
        return const Color(0xFFD50000);
      case 4:
        return const Color(0xFFEF5350);
      case 3:
        return const Color(0xFFFFA726);
      case 2:
        return const Color(0xFFFFEE58);
      default:
        return const Color(0xFF42A5F5);
    }
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
      case IncidentStatus.escalated:
        return const Color(0xFFEF5350);
      case IncidentStatus.assigned:
      case IncidentStatus.enRoute:
      case IncidentStatus.onScene:
        return const Color(0xFFFFA726);
      case IncidentStatus.resolved:
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  Color _getZoneKindColor(String kind) {
    switch (kind.toLowerCase()) {
      case 'flood':
        return const Color(0xFF00BCD4);
      case 'cyclone':
        return const Color(0xFFAB47BC);
      case 'landslide':
        return const Color(0xFFFF7043);
      case 'earthquake':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFFFA726);
    }
  }
}

/// Custom painter for rendering a high-visibility downward-pointing needle on tactical map pins.
class _TacticalPinPointerPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  const _TacticalPinPointerPainter({
    required this.color,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TacticalPinPointerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
