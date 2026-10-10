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

abstract class Incident
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    this.centroidEmbedding,
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
    required _is.GeographyPoint centroid,
    _is.Vector? centroidEmbedding,
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
      vulnerabilities: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['vulnerabilities'],
      ),
      summary: jsonSerialization['summary'] as String,
      aiSeverity: jsonSerialization['aiSeverity'] as String?,
      aiTags: jsonSerialization['aiTags'] == null
          ? null
          : _i78gox42.Protocol().deserialize<List<String>>(
              jsonSerialization['aiTags'],
            ),
      aiSummary: jsonSerialization['aiSummary'] as String?,
      centroid: _is.GeographyPointJsonExtension.fromJson(
        jsonSerialization['centroid'],
      ),
      centroidEmbedding: jsonSerialization['centroidEmbedding'] == null
          ? null
          : _is.VectorJsonExtension.fromJson(
              jsonSerialization['centroidEmbedding'],
            ),
      accuracyRadiusM: (jsonSerialization['accuracyRadiusM'] as num).toDouble(),
      reportCount: jsonSerialization['reportCount'] as int?,
      firstReportAt: jsonSerialization['firstReportAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstReportAt'],
            ),
      lastReportAt: jsonSerialization['lastReportAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReportAt'],
            ),
      baseSlaSeconds: jsonSerialization['baseSlaSeconds'] as int,
      escalationLevel: jsonSerialization['escalationLevel'] as int?,
      dispatchRadiusM: (jsonSerialization['dispatchRadiusM'] as num).toDouble(),
      levelStartedAt: jsonSerialization['levelStartedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['levelStartedAt'],
            ),
      nextEscalationAt: jsonSerialization['nextEscalationAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextEscalationAt'],
            ),
      assignedResponderId: jsonSerialization['assignedResponderId'] as int?,
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      mergedIntoId: jsonSerialization['mergedIntoId'] as int?,
      evidenceUrl: jsonSerialization['evidenceUrl'] as String?,
      version: jsonSerialization['version'] as int?,
    );
  }

  static final t = IncidentTable();

  static const db = IncidentRepository._();

  @override
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

  _is.GeographyPoint centroid;

  _is.Vector? centroidEmbedding;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
    _is.GeographyPoint? centroid,
    _is.Vector? centroidEmbedding,
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
      if (centroidEmbedding != null)
        'centroidEmbedding': centroidEmbedding?.toJson(),
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

  static IncidentInclude include() {
    return IncidentInclude._();
  }

  static IncidentIncludeList includeList({
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    IncidentInclude? include,
  }) {
    return IncidentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
    required _is.GeographyPoint centroid,
    _is.Vector? centroidEmbedding,
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
         centroidEmbedding: centroidEmbedding,
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
  @_is.useResult
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
    _is.GeographyPoint? centroid,
    Object? centroidEmbedding = _Undefined,
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
      centroidEmbedding: centroidEmbedding is _is.Vector?
          ? centroidEmbedding
          : this.centroidEmbedding?.clone(),
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

class IncidentUpdateTable extends _is.UpdateTable<IncidentTable> {
  IncidentUpdateTable(super.table);

  _is.ColumnValue<int, int> zoneId(int value) => _is.ColumnValue(
    table.zoneId,
    value,
  );

  _is.ColumnValue<_iq4zvdzd.NeedType, _iq4zvdzd.NeedType> needType(
    _iq4zvdzd.NeedType value,
  ) => _is.ColumnValue(
    table.needType,
    value,
  );

  _is.ColumnValue<_ikduxsi0.IncidentStatus, _ikduxsi0.IncidentStatus> status(
    _ikduxsi0.IncidentStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> severity(int value) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<int, int> headcount(int? value) => _is.ColumnValue(
    table.headcount,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> vulnerabilities(
    List<String> value,
  ) => _is.ColumnValue(
    table.vulnerabilities,
    value,
  );

  _is.ColumnValue<String, String> summary(String value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<String, String> aiSeverity(String? value) => _is.ColumnValue(
    table.aiSeverity,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> aiTags(List<String>? value) =>
      _is.ColumnValue(
        table.aiTags,
        value,
      );

  _is.ColumnValue<String, String> aiSummary(String? value) => _is.ColumnValue(
    table.aiSummary,
    value,
  );

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> centroid(
    _is.GeographyPoint value,
  ) => _is.ColumnValue(
    table.centroid,
    value,
  );

  _is.ColumnValue<_is.Vector, _is.Vector> centroidEmbedding(
    _is.Vector? value,
  ) => _is.ColumnValue(
    table.centroidEmbedding,
    value,
  );

  _is.ColumnValue<double, double> accuracyRadiusM(double value) =>
      _is.ColumnValue(
        table.accuracyRadiusM,
        value,
      );

  _is.ColumnValue<int, int> reportCount(int value) => _is.ColumnValue(
    table.reportCount,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> firstReportAt(DateTime value) =>
      _is.ColumnValue(
        table.firstReportAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastReportAt(DateTime value) =>
      _is.ColumnValue(
        table.lastReportAt,
        value,
      );

  _is.ColumnValue<int, int> baseSlaSeconds(int value) => _is.ColumnValue(
    table.baseSlaSeconds,
    value,
  );

  _is.ColumnValue<int, int> escalationLevel(int value) => _is.ColumnValue(
    table.escalationLevel,
    value,
  );

  _is.ColumnValue<double, double> dispatchRadiusM(double value) =>
      _is.ColumnValue(
        table.dispatchRadiusM,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> levelStartedAt(DateTime value) =>
      _is.ColumnValue(
        table.levelStartedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> nextEscalationAt(DateTime? value) =>
      _is.ColumnValue(
        table.nextEscalationAt,
        value,
      );

  _is.ColumnValue<int, int> assignedResponderId(int? value) => _is.ColumnValue(
    table.assignedResponderId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> acceptedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acceptedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );

  _is.ColumnValue<int, int> mergedIntoId(int? value) => _is.ColumnValue(
    table.mergedIntoId,
    value,
  );

  _is.ColumnValue<String, String> evidenceUrl(String? value) => _is.ColumnValue(
    table.evidenceUrl,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );
}

class IncidentTable extends _is.Table<int?> {
  IncidentTable({super.tableRelation}) : super(tableName: 'incident') {
    updateTable = IncidentUpdateTable(this);
    zoneId = _is.ColumnInt(
      'zoneId',
      this,
    );
    needType = _is.ColumnEnum(
      'needType',
      this,
      _is.EnumSerialization.byName,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    severity = _is.ColumnInt(
      'severity',
      this,
    );
    headcount = _is.ColumnInt(
      'headcount',
      this,
    );
    vulnerabilities = _is.ColumnSerializable<List<String>>(
      'vulnerabilities',
      this,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    aiSeverity = _is.ColumnString(
      'aiSeverity',
      this,
    );
    aiTags = _is.ColumnSerializable<List<String>>(
      'aiTags',
      this,
    );
    aiSummary = _is.ColumnString(
      'aiSummary',
      this,
    );
    centroid = _is.ColumnGeographyPoint(
      'centroid',
      this,
    );
    centroidEmbedding = _is.ColumnVector(
      'centroidEmbedding',
      this,
      dimension: 768,
    );
    accuracyRadiusM = _is.ColumnDouble(
      'accuracyRadiusM',
      this,
    );
    reportCount = _is.ColumnInt(
      'reportCount',
      this,
      hasDefault: true,
    );
    firstReportAt = _is.ColumnDateTime(
      'firstReportAt',
      this,
      hasDefault: true,
    );
    lastReportAt = _is.ColumnDateTime(
      'lastReportAt',
      this,
      hasDefault: true,
    );
    baseSlaSeconds = _is.ColumnInt(
      'baseSlaSeconds',
      this,
    );
    escalationLevel = _is.ColumnInt(
      'escalationLevel',
      this,
      hasDefault: true,
    );
    dispatchRadiusM = _is.ColumnDouble(
      'dispatchRadiusM',
      this,
    );
    levelStartedAt = _is.ColumnDateTime(
      'levelStartedAt',
      this,
      hasDefault: true,
    );
    nextEscalationAt = _is.ColumnDateTime(
      'nextEscalationAt',
      this,
    );
    assignedResponderId = _is.ColumnInt(
      'assignedResponderId',
      this,
    );
    acceptedAt = _is.ColumnDateTime(
      'acceptedAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
    mergedIntoId = _is.ColumnInt(
      'mergedIntoId',
      this,
    );
    evidenceUrl = _is.ColumnString(
      'evidenceUrl',
      this,
    );
    version = _is.ColumnInt(
      'version',
      this,
      hasDefault: true,
    );
  }

  late final IncidentUpdateTable updateTable;

  late final _is.ColumnInt zoneId;

  late final _is.ColumnEnum<_iq4zvdzd.NeedType> needType;

  late final _is.ColumnEnum<_ikduxsi0.IncidentStatus> status;

  late final _is.ColumnInt severity;

  late final _is.ColumnInt headcount;

  late final _is.ColumnSerializable<List<String>> vulnerabilities;

  late final _is.ColumnString summary;

  late final _is.ColumnString aiSeverity;

  late final _is.ColumnSerializable<List<String>> aiTags;

  late final _is.ColumnString aiSummary;

  late final _is.ColumnGeographyPoint centroid;

  late final _is.ColumnVector centroidEmbedding;

  late final _is.ColumnDouble accuracyRadiusM;

  late final _is.ColumnInt reportCount;

  late final _is.ColumnDateTime firstReportAt;

  late final _is.ColumnDateTime lastReportAt;

  late final _is.ColumnInt baseSlaSeconds;

  late final _is.ColumnInt escalationLevel;

  late final _is.ColumnDouble dispatchRadiusM;

  late final _is.ColumnDateTime levelStartedAt;

  late final _is.ColumnDateTime nextEscalationAt;

  late final _is.ColumnInt assignedResponderId;

  late final _is.ColumnDateTime acceptedAt;

  late final _is.ColumnDateTime resolvedAt;

  late final _is.ColumnInt mergedIntoId;

  late final _is.ColumnString evidenceUrl;

  late final _is.ColumnInt version;

  @override
  List<_is.Column> get columns => [
    id,
    zoneId,
    needType,
    status,
    severity,
    headcount,
    vulnerabilities,
    summary,
    aiSeverity,
    aiTags,
    aiSummary,
    centroid,
    centroidEmbedding,
    accuracyRadiusM,
    reportCount,
    firstReportAt,
    lastReportAt,
    baseSlaSeconds,
    escalationLevel,
    dispatchRadiusM,
    levelStartedAt,
    nextEscalationAt,
    assignedResponderId,
    acceptedAt,
    resolvedAt,
    mergedIntoId,
    evidenceUrl,
    version,
  ];
}

class IncidentInclude extends _is.IncludeObject {
  IncidentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Incident.t;
}

class IncidentIncludeList extends _is.IncludeList {
  IncidentIncludeList._({
    _is.WhereExpressionBuilder<IncidentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Incident.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Incident.t;
}

class IncidentRepository {
  const IncidentRepository._();

  /// Returns a list of [Incident]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Incident>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Incident>(
      where: where?.call(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Incident] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Incident?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Incident>(
      where: where?.call(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Incident] by its [id] or null if no such row exists.
  Future<Incident?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Incident>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Incident]s in the list and returns the inserted rows.
  ///
  /// The returned [Incident]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> insert(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Incident>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Incident] and returns the inserted row.
  ///
  /// The returned [Incident] will have its `id` field set.
  Future<Incident> insertRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Incident>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Incident]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Incident]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> upsert(
    _is.DatabaseSession session,
    List<Incident> rows, {
    required _is.ColumnSelections<IncidentTable> conflictColumns,
    _is.ColumnSelections<IncidentTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Incident>(
      rows,
      conflictColumns: conflictColumns(Incident.t),
      updateColumns: updateColumns?.call(Incident.t),
      updateWhere: updateWhere?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Incident] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Incident] will have its `id` field set.
  Future<Incident?> upsertRow(
    _is.DatabaseSession session,
    Incident row, {
    required _is.ColumnSelections<IncidentTable> conflictColumns,
    _is.ColumnSelections<IncidentTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Incident>(
      row,
      conflictColumns: conflictColumns(Incident.t),
      updateColumns: updateColumns?.call(Incident.t),
      updateWhere: updateWhere?.call(Incident.t),
      transaction: transaction,
    );
  }

  /// Updates all [Incident]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> update(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.ColumnSelections<IncidentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Incident>(
      rows,
      columns: columns?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Incident]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Incident> updateRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.ColumnSelections<IncidentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Incident>(
      row,
      columns: columns?.call(Incident.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Incident] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Incident?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IncidentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Incident>(
      id,
      columnValues: columnValues(Incident.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Incident]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IncidentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<IncidentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Incident>(
      columnValues: columnValues(Incident.t.updateTable),
      where: where(Incident.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Incident]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> delete(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Incident>(
      rows,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Incident].
  Future<Incident> deleteRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Incident>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentTable> where,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Incident>(
      where: where(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Incident>(
      where: where?.call(Incident.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Incident] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Incident>(
      where: where(Incident.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
