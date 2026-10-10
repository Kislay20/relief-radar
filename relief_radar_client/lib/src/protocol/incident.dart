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
import 'package:relief_radar_client/src/protocol/protocol.dart' as _if75qna0;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'incident_status.dart' as _ikduxsi0;
import 'need_type.dart' as _iq4zvdzd;

abstract class Incident
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Incident._({
    this.id,
    required this.zoneId,
    required this.needType,
    required this.status,
    required this.severity,
    this.headcount,
    required this.vulnerabilities,
    required this.summary,
    this.aiSeverity,
    this.aiTags,
    this.aiSummary,
    required this.centroid,
    required this.accuracyRadiusM,
    int? reportCount,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    required this.baseSlaSeconds,
    int? escalationLevel,
    required this.dispatchRadiusM,
    DateTime? levelStartedAt,
    this.nextEscalationAt,
    this.assignedResponderId,
    this.acceptedAt,
    this.resolvedAt,
    this.mergedIntoId,
    this.evidenceUrl,
    int? version,
  }) : reportCount = reportCount ?? 1,
       firstReportAt = firstReportAt ?? DateTime.now(),
       lastReportAt = lastReportAt ?? DateTime.now(),
       escalationLevel = escalationLevel ?? 0,
       levelStartedAt = levelStartedAt ?? DateTime.now(),
       version = version ?? 0;

  factory Incident({
    int? id,
    required int zoneId,
    required _iq4zvdzd.NeedType needType,
    required _ikduxsi0.IncidentStatus status,
    required int severity,
    int? headcount,
    required List<String> vulnerabilities,
    required String summary,
    String? aiSeverity,
    List<String>? aiTags,
    String? aiSummary,
    required _isc.GeographyPoint centroid,
    required double accuracyRadiusM,
    int? reportCount,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    required int baseSlaSeconds,
    int? escalationLevel,
    required double dispatchRadiusM,
    DateTime? levelStartedAt,
    DateTime? nextEscalationAt,
    int? assignedResponderId,
    DateTime? acceptedAt,
    DateTime? resolvedAt,
    int? mergedIntoId,
    String? evidenceUrl,
    int? version,
  }) = _IncidentImpl;

  factory Incident.fromJson(Map<String, dynamic> jsonSerialization) {
    return Incident(
      id: jsonSerialization['id'] as int?,
      zoneId: jsonSerialization['zoneId'] as int,
      needType: _iq4zvdzd.NeedType.fromJson(
        (jsonSerialization['needType'] as String),
      ),
      status: _ikduxsi0.IncidentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      severity: jsonSerialization['severity'] as int,
      headcount: jsonSerialization['headcount'] as int?,
      vulnerabilities: _if75qna0.Protocol().deserialize<List<String>>(
        jsonSerialization['vulnerabilities'],
      ),
      summary: jsonSerialization['summary'] as String,
      aiSeverity: jsonSerialization['aiSeverity'] as String?,
      aiTags: jsonSerialization['aiTags'] == null
          ? null
          : _if75qna0.Protocol().deserialize<List<String>>(
              jsonSerialization['aiTags'],
            ),
      aiSummary: jsonSerialization['aiSummary'] as String?,
      centroid: _isc.GeographyPointJsonExtension.fromJson(
        jsonSerialization['centroid'],
      ),
      accuracyRadiusM: (jsonSerialization['accuracyRadiusM'] as num).toDouble(),
      reportCount: jsonSerialization['reportCount'] as int?,
      firstReportAt: jsonSerialization['firstReportAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstReportAt'],
            ),
      lastReportAt: jsonSerialization['lastReportAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReportAt'],
            ),
      baseSlaSeconds: jsonSerialization['baseSlaSeconds'] as int,
      escalationLevel: jsonSerialization['escalationLevel'] as int?,
      dispatchRadiusM: (jsonSerialization['dispatchRadiusM'] as num).toDouble(),
      levelStartedAt: jsonSerialization['levelStartedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['levelStartedAt'],
            ),
      nextEscalationAt: jsonSerialization['nextEscalationAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextEscalationAt'],
            ),
      assignedResponderId: jsonSerialization['assignedResponderId'] as int?,
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acceptedAt'],
            ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
      mergedIntoId: jsonSerialization['mergedIntoId'] as int?,
      evidenceUrl: jsonSerialization['evidenceUrl'] as String?,
      version: jsonSerialization['version'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int zoneId;

  _iq4zvdzd.NeedType needType;

  _ikduxsi0.IncidentStatus status;

  int severity;

  int? headcount;

  List<String> vulnerabilities;

  String summary;

  String? aiSeverity;

  List<String>? aiTags;

  String? aiSummary;

  _isc.GeographyPoint centroid;

  double accuracyRadiusM;

  int reportCount;

  DateTime firstReportAt;

  DateTime lastReportAt;

  int baseSlaSeconds;

  int escalationLevel;

  double dispatchRadiusM;

  DateTime levelStartedAt;

  DateTime? nextEscalationAt;

  int? assignedResponderId;

  DateTime? acceptedAt;

  DateTime? resolvedAt;

  int? mergedIntoId;

  String? evidenceUrl;

  int version;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Incident copyWith({
    int? id,
    int? zoneId,
    _iq4zvdzd.NeedType? needType,
    _ikduxsi0.IncidentStatus? status,
    int? severity,
    int? headcount,
    List<String>? vulnerabilities,
    String? summary,
    String? aiSeverity,
    List<String>? aiTags,
    String? aiSummary,
    _isc.GeographyPoint? centroid,
    double? accuracyRadiusM,
    int? reportCount,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    int? baseSlaSeconds,
    int? escalationLevel,
    double? dispatchRadiusM,
    DateTime? levelStartedAt,
    DateTime? nextEscalationAt,
    int? assignedResponderId,
    DateTime? acceptedAt,
    DateTime? resolvedAt,
    int? mergedIntoId,
    String? evidenceUrl,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'zoneId': zoneId,
      'needType': needType.toJson(),
      'status': status.toJson(),
      'severity': severity,
      if (headcount != null) 'headcount': headcount,
      'vulnerabilities': vulnerabilities.toJson(),
      'summary': summary,
      if (aiSeverity != null) 'aiSeverity': aiSeverity,
      if (aiTags != null) 'aiTags': aiTags?.toJson(),
      if (aiSummary != null) 'aiSummary': aiSummary,
      'centroid': centroid.toJson(),
      'accuracyRadiusM': accuracyRadiusM,
      'reportCount': reportCount,
      'firstReportAt': firstReportAt.toJson(),
      'lastReportAt': lastReportAt.toJson(),
      'baseSlaSeconds': baseSlaSeconds,
      'escalationLevel': escalationLevel,
      'dispatchRadiusM': dispatchRadiusM,
      'levelStartedAt': levelStartedAt.toJson(),
      if (nextEscalationAt != null)
        'nextEscalationAt': nextEscalationAt?.toJson(),
      if (assignedResponderId != null)
        'assignedResponderId': assignedResponderId,
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (mergedIntoId != null) 'mergedIntoId': mergedIntoId,
      if (evidenceUrl != null) 'evidenceUrl': evidenceUrl,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'zoneId': zoneId,
      'needType': needType.toJson(),
      'status': status.toJson(),
      'severity': severity,
      if (headcount != null) 'headcount': headcount,
      'vulnerabilities': vulnerabilities.toJson(),
      'summary': summary,
      if (aiSeverity != null) 'aiSeverity': aiSeverity,
      if (aiTags != null) 'aiTags': aiTags?.toJson(),
      if (aiSummary != null) 'aiSummary': aiSummary,
      'centroid': centroid.toJson(),
      'accuracyRadiusM': accuracyRadiusM,
      'reportCount': reportCount,
      'firstReportAt': firstReportAt.toJson(),
      'lastReportAt': lastReportAt.toJson(),
      'baseSlaSeconds': baseSlaSeconds,
      'escalationLevel': escalationLevel,
      'dispatchRadiusM': dispatchRadiusM,
      'levelStartedAt': levelStartedAt.toJson(),
      if (nextEscalationAt != null)
        'nextEscalationAt': nextEscalationAt?.toJson(),
      if (assignedResponderId != null)
        'assignedResponderId': assignedResponderId,
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (mergedIntoId != null) 'mergedIntoId': mergedIntoId,
      if (evidenceUrl != null) 'evidenceUrl': evidenceUrl,
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentImpl extends Incident {
  _IncidentImpl({
    int? id,
    required int zoneId,
    required _iq4zvdzd.NeedType needType,
    required _ikduxsi0.IncidentStatus status,
    required int severity,
    int? headcount,
    required List<String> vulnerabilities,
    required String summary,
    String? aiSeverity,
    List<String>? aiTags,
    String? aiSummary,
    required _isc.GeographyPoint centroid,
    required double accuracyRadiusM,
    int? reportCount,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    required int baseSlaSeconds,
    int? escalationLevel,
    required double dispatchRadiusM,
    DateTime? levelStartedAt,
    DateTime? nextEscalationAt,
    int? assignedResponderId,
    DateTime? acceptedAt,
    DateTime? resolvedAt,
    int? mergedIntoId,
    String? evidenceUrl,
    int? version,
  }) : super._(
         id: id,
         zoneId: zoneId,
         needType: needType,
         status: status,
         severity: severity,
         headcount: headcount,
         vulnerabilities: vulnerabilities,
         summary: summary,
         aiSeverity: aiSeverity,
         aiTags: aiTags,
         aiSummary: aiSummary,
         centroid: centroid,
         accuracyRadiusM: accuracyRadiusM,
         reportCount: reportCount,
         firstReportAt: firstReportAt,
         lastReportAt: lastReportAt,
         baseSlaSeconds: baseSlaSeconds,
         escalationLevel: escalationLevel,
         dispatchRadiusM: dispatchRadiusM,
         levelStartedAt: levelStartedAt,
         nextEscalationAt: nextEscalationAt,
         assignedResponderId: assignedResponderId,
         acceptedAt: acceptedAt,
         resolvedAt: resolvedAt,
         mergedIntoId: mergedIntoId,
         evidenceUrl: evidenceUrl,
         version: version,
       );

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Incident copyWith({
    Object? id = _Undefined,
    int? zoneId,
    _iq4zvdzd.NeedType? needType,
    _ikduxsi0.IncidentStatus? status,
    int? severity,
    Object? headcount = _Undefined,
    List<String>? vulnerabilities,
    String? summary,
    Object? aiSeverity = _Undefined,
    Object? aiTags = _Undefined,
    Object? aiSummary = _Undefined,
    _isc.GeographyPoint? centroid,
    double? accuracyRadiusM,
    int? reportCount,
    DateTime? firstReportAt,
    DateTime? lastReportAt,
    int? baseSlaSeconds,
    int? escalationLevel,
    double? dispatchRadiusM,
    DateTime? levelStartedAt,
    Object? nextEscalationAt = _Undefined,
    Object? assignedResponderId = _Undefined,
    Object? acceptedAt = _Undefined,
    Object? resolvedAt = _Undefined,
    Object? mergedIntoId = _Undefined,
    Object? evidenceUrl = _Undefined,
    int? version,
  }) {
    return Incident(
      id: id is int? ? id : this.id,
      zoneId: zoneId ?? this.zoneId,
      needType: needType ?? this.needType,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      headcount: headcount is int? ? headcount : this.headcount,
      vulnerabilities:
          vulnerabilities ?? this.vulnerabilities.map((e0) => e0).toList(),
      summary: summary ?? this.summary,
      aiSeverity: aiSeverity is String? ? aiSeverity : this.aiSeverity,
      aiTags: aiTags is List<String>?
          ? aiTags
          : this.aiTags?.map((e0) => e0).toList(),
      aiSummary: aiSummary is String? ? aiSummary : this.aiSummary,
      centroid: centroid ?? this.centroid,
      accuracyRadiusM: accuracyRadiusM ?? this.accuracyRadiusM,
      reportCount: reportCount ?? this.reportCount,
      firstReportAt: firstReportAt ?? this.firstReportAt,
      lastReportAt: lastReportAt ?? this.lastReportAt,
      baseSlaSeconds: baseSlaSeconds ?? this.baseSlaSeconds,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      dispatchRadiusM: dispatchRadiusM ?? this.dispatchRadiusM,
      levelStartedAt: levelStartedAt ?? this.levelStartedAt,
      nextEscalationAt: nextEscalationAt is DateTime?
          ? nextEscalationAt
          : this.nextEscalationAt,
      assignedResponderId: assignedResponderId is int?
          ? assignedResponderId
          : this.assignedResponderId,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      mergedIntoId: mergedIntoId is int? ? mergedIntoId : this.mergedIntoId,
      evidenceUrl: evidenceUrl is String? ? evidenceUrl : this.evidenceUrl,
      version: version ?? this.version,
    );
  }
}
