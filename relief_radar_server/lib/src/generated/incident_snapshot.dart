/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:relief_radar_server/src/generated/protocol.dart' as _i78gox42;
import 'package:serverpod/serverpod.dart' as _is;
import 'incident_status.dart' as _ikduxsi0;
import 'need_type.dart' as _iq4zvdzd;

abstract class IncidentSnapshot
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IncidentSnapshot._({
    required this.id,
    required this.zoneId,
    required this.needType,
    required this.status,
    required this.severity,
    this.headcount,
    required this.vulnerabilities,
    required this.summary,
    required this.lat,
    required this.lng,
    required this.accuracyRadiusM,
    required this.reportCount,
    required this.escalationLevel,
    required this.dispatchRadiusM,
    required this.levelStartedAt,
    this.nextEscalationAt,
    this.assignedResponderName,
    required this.firstReportAt,
    required this.lastReportAt,
    required this.version,
  });

  factory IncidentSnapshot({
    required int id,
    required int zoneId,
    required _iq4zvdzd.NeedType needType,
    required _ikduxsi0.IncidentStatus status,
    required int severity,
    int? headcount,
    required List<String> vulnerabilities,
    required String summary,
    required double lat,
    required double lng,
    required double accuracyRadiusM,
    required int reportCount,
    required int escalationLevel,
    required double dispatchRadiusM,
    required DateTime levelStartedAt,
    DateTime? nextEscalationAt,
    String? assignedResponderName,
    required DateTime firstReportAt,
    required DateTime lastReportAt,
    required int version,
  }) = _IncidentSnapshotImpl;

  factory IncidentSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentSnapshot(
      id: jsonSerialization['id'] as int,
      zoneId: jsonSerialization['zoneId'] as int,
      needType: _iq4zvdzd.NeedType.fromJson(
        (jsonSerialization['needType'] as String),
      ),
      status: _ikduxsi0.IncidentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      severity: jsonSerialization['severity'] as int,
      headcount: jsonSerialization['headcount'] as int?,
      vulnerabilities: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['vulnerabilities'],
      ),
      summary: jsonSerialization['summary'] as String,
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lng: (jsonSerialization['lng'] as num).toDouble(),
      accuracyRadiusM: (jsonSerialization['accuracyRadiusM'] as num).toDouble(),
      reportCount: jsonSerialization['reportCount'] as int,
      escalationLevel: jsonSerialization['escalationLevel'] as int,
      dispatchRadiusM: (jsonSerialization['dispatchRadiusM'] as num).toDouble(),
      levelStartedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['levelStartedAt'],
      ),
      nextEscalationAt: jsonSerialization['nextEscalationAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextEscalationAt'],
            ),
      assignedResponderName:
          jsonSerialization['assignedResponderName'] as String?,
      firstReportAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstReportAt'],
      ),
      lastReportAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastReportAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  int id;

  int zoneId;

  _iq4zvdzd.NeedType needType;

  _ikduxsi0.IncidentStatus status;

  int severity;

  int? headcount;

  List<String> vulnerabilities;

  String summary;

  double lat;

  double lng;

  double accuracyRadiusM;

  int reportCount;

  int escalationLevel;

  double dispatchRadiusM;

  DateTime levelStartedAt;

  DateTime? nextEscalationAt;

  String? assignedResponderName;

  DateTime firstReportAt;

  DateTime lastReportAt;

  int version;

  /// Returns a shallow copy of this [IncidentSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IncidentSnapshot copyWith({
    int? id,
    int? zoneId,
    _iq4zvdzd.NeedType? needType,
    _ikduxsi0.IncidentStatus? status,
    int? severity,
    int? headcount,
    List<String>? vulnerabilities,
    String? summary,
    double? lat,
    double? lng,
    double? accuracyRadiusM,
    int? reportCount,
    int? escalationLevel,
    double? dispatchRadiusM,
    DateTime? levelStartedAt,
    DateTime? nextEscalationAt,
    String? assignedResponderName,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentSnapshot',
      'id': id,
      'zoneId': zoneId,
      'needType': needType.toJson(),
      'status': status.toJson(),
      'severity': severity,
      if (headcount != null) 'headcount': headcount,
      'vulnerabilities': vulnerabilities.toJson(),
      'summary': summary,
      'lat': lat,
      'lng': lng,
      'accuracyRadiusM': accuracyRadiusM,
      'reportCount': reportCount,
      'escalationLevel': escalationLevel,
      'dispatchRadiusM': dispatchRadiusM,
      'levelStartedAt': levelStartedAt.toJson(),
      if (nextEscalationAt != null)
        'nextEscalationAt': nextEscalationAt?.toJson(),
      if (assignedResponderName != null)
        'assignedResponderName': assignedResponderName,
      'firstReportAt': firstReportAt.toJson(),
      'lastReportAt': lastReportAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentSnapshot',
      'id': id,
      'zoneId': zoneId,
      'needType': needType.toJson(),
      'status': status.toJson(),
      'severity': severity,
      if (headcount != null) 'headcount': headcount,
      'vulnerabilities': vulnerabilities.toJson(),
      'summary': summary,
      'lat': lat,
      'lng': lng,
      'accuracyRadiusM': accuracyRadiusM,
      'reportCount': reportCount,
      'escalationLevel': escalationLevel,
      'dispatchRadiusM': dispatchRadiusM,
      'levelStartedAt': levelStartedAt.toJson(),
      if (nextEscalationAt != null)
        'nextEscalationAt': nextEscalationAt?.toJson(),
      if (assignedResponderName != null)
        'assignedResponderName': assignedResponderName,
      'firstReportAt': firstReportAt.toJson(),
      'lastReportAt': lastReportAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentSnapshotImpl extends IncidentSnapshot {
  _IncidentSnapshotImpl({
    required int id,
    required int zoneId,
    required _iq4zvdzd.NeedType needType,
    required _ikduxsi0.IncidentStatus status,
    required int severity,
    int? headcount,
    required List<String> vulnerabilities,
    required String summary,
    required double lat,
    required double lng,
    required double accuracyRadiusM,
    required int reportCount,
    required int escalationLevel,
    required double dispatchRadiusM,
    required DateTime levelStartedAt,
    DateTime? nextEscalationAt,
    String? assignedResponderName,
    required DateTime firstReportAt,
    required DateTime lastReportAt,
    required int version,
  }) : super._(
         id: id,
         zoneId: zoneId,
         needType: needType,
         status: status,
         severity: severity,
         headcount: headcount,
         vulnerabilities: vulnerabilities,
         summary: summary,
         lat: lat,
         lng: lng,
         accuracyRadiusM: accuracyRadiusM,
         reportCount: reportCount,
         escalationLevel: escalationLevel,
         dispatchRadiusM: dispatchRadiusM,
         levelStartedAt: levelStartedAt,
         nextEscalationAt: nextEscalationAt,
         assignedResponderName: assignedResponderName,
         firstReportAt: firstReportAt,
         lastReportAt: lastReportAt,
         version: version,
       );

  /// Returns a shallow copy of this [IncidentSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IncidentSnapshot copyWith({
    int? id,
    int? zoneId,
    _iq4zvdzd.NeedType? needType,
    _ikduxsi0.IncidentStatus? status,
    int? severity,
    Object? headcount = _Undefined,
    List<String>? vulnerabilities,
    String? summary,
    double? lat,
    double? lng,
    double? accuracyRadiusM,
    int? reportCount,
    int? escalationLevel,
    double? dispatchRadiusM,
    DateTime? levelStartedAt,
    Object? nextEscalationAt = _Undefined,
    Object? assignedResponderName = _Undefined,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    int? version,
  }) {
    return IncidentSnapshot(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      needType: needType ?? this.needType,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      headcount: headcount is int? ? headcount : this.headcount,
      vulnerabilities:
          vulnerabilities ?? this.vulnerabilities.map((e0) => e0).toList(),
      summary: summary ?? this.summary,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      accuracyRadiusM: accuracyRadiusM ?? this.accuracyRadiusM,
      reportCount: reportCount ?? this.reportCount,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      dispatchRadiusM: dispatchRadiusM ?? this.dispatchRadiusM,
      levelStartedAt: levelStartedAt ?? this.levelStartedAt,
      nextEscalationAt: nextEscalationAt is DateTime?
          ? nextEscalationAt
          : this.nextEscalationAt,
      assignedResponderName: assignedResponderName is String?
          ? assignedResponderName
          : this.assignedResponderName,
      firstReportAt: firstReportAt ?? this.firstReportAt,
      lastReportAt: lastReportAt ?? this.lastReportAt,
      version: version ?? this.version,
    );
  }
}
