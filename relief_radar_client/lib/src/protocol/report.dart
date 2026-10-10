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
import 'report_status.dart' as _i8pcsu0p;
import 'structured_report.dart' as _imc53az5;

abstract class Report
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Report._({
    this.id,
    required this.zoneId,
    required this.clientReportId,
    required this.reporterKey,
    required this.rawText,
    bool? hasImage,
    this.clientLocation,
    this.locationAccuracyM,
    required this.clientCreatedAt,
    DateTime? receivedAt,
    required this.status,
    this.failureReason,
    this.structured,
    this.incidentId,
  }) : hasImage = hasImage ?? false,
       receivedAt = receivedAt ?? DateTime.now();

  factory Report({
    int? id,
    required int zoneId,
    required _isc.UuidValue clientReportId,
    required String reporterKey,
    required String rawText,
    bool? hasImage,
    _isc.GeographyPoint? clientLocation,
    double? locationAccuracyM,
    required DateTime clientCreatedAt,
    DateTime? receivedAt,
    required _i8pcsu0p.ReportStatus status,
    String? failureReason,
    _imc53az5.StructuredReport? structured,
    int? incidentId,
  }) = _ReportImpl;

  factory Report.fromJson(Map<String, dynamic> jsonSerialization) {
    return Report(
      id: jsonSerialization['id'] as int?,
      zoneId: jsonSerialization['zoneId'] as int,
      clientReportId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientReportId'],
      ),
      reporterKey: jsonSerialization['reporterKey'] as String,
      rawText: jsonSerialization['rawText'] as String,
      hasImage: jsonSerialization['hasImage'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['hasImage']),
      clientLocation: jsonSerialization['clientLocation'] == null
          ? null
          : _isc.GeographyPointJsonExtension.fromJson(
              jsonSerialization['clientLocation'],
            ),
      locationAccuracyM: (jsonSerialization['locationAccuracyM'] as num?)
          ?.toDouble(),
      clientCreatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['clientCreatedAt'],
      ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
            ),
      status: _i8pcsu0p.ReportStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      failureReason: jsonSerialization['failureReason'] as String?,
      structured: jsonSerialization['structured'] == null
          ? null
          : _if75qna0.Protocol().deserialize<_imc53az5.StructuredReport>(
              jsonSerialization['structured'],
            ),
      incidentId: jsonSerialization['incidentId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int zoneId;

  _isc.UuidValue clientReportId;

  String reporterKey;

  String rawText;

  bool hasImage;

  _isc.GeographyPoint? clientLocation;

  double? locationAccuracyM;

  DateTime clientCreatedAt;

  DateTime receivedAt;

  _i8pcsu0p.ReportStatus status;

  String? failureReason;

  _imc53az5.StructuredReport? structured;

  int? incidentId;

  /// Returns a shallow copy of this [Report]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Report copyWith({
    int? id,
    int? zoneId,
    _isc.UuidValue? clientReportId,
    String? reporterKey,
    String? rawText,
    bool? hasImage,
    _isc.GeographyPoint? clientLocation,
    double? locationAccuracyM,
    DateTime? clientCreatedAt,
    DateTime? receivedAt,
    _i8pcsu0p.ReportStatus? status,
    String? failureReason,
    _imc53az5.StructuredReport? structured,
    int? incidentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Report',
      if (id != null) 'id': id,
      'zoneId': zoneId,
      'clientReportId': clientReportId.toJson(),
      'reporterKey': reporterKey,
      'rawText': rawText,
      'hasImage': hasImage,
      if (clientLocation != null) 'clientLocation': clientLocation?.toJson(),
      if (locationAccuracyM != null) 'locationAccuracyM': locationAccuracyM,
      'clientCreatedAt': clientCreatedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      'status': status.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      if (structured != null) 'structured': structured?.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Report',
      if (id != null) 'id': id,
      'zoneId': zoneId,
      'clientReportId': clientReportId.toJson(),
      'reporterKey': reporterKey,
      'rawText': rawText,
      'hasImage': hasImage,
      if (clientLocation != null) 'clientLocation': clientLocation?.toJson(),
      if (locationAccuracyM != null) 'locationAccuracyM': locationAccuracyM,
      'clientCreatedAt': clientCreatedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      'status': status.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      if (structured != null) 'structured': structured?.toJsonForProtocol(),
      if (incidentId != null) 'incidentId': incidentId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportImpl extends Report {
  _ReportImpl({
    int? id,
    required int zoneId,
    required _isc.UuidValue clientReportId,
    required String reporterKey,
    required String rawText,
    bool? hasImage,
    _isc.GeographyPoint? clientLocation,
    double? locationAccuracyM,
    required DateTime clientCreatedAt,
    DateTime? receivedAt,
    required _i8pcsu0p.ReportStatus status,
    String? failureReason,
    _imc53az5.StructuredReport? structured,
    int? incidentId,
  }) : super._(
         id: id,
         zoneId: zoneId,
         clientReportId: clientReportId,
         reporterKey: reporterKey,
         rawText: rawText,
         hasImage: hasImage,
         clientLocation: clientLocation,
         locationAccuracyM: locationAccuracyM,
         clientCreatedAt: clientCreatedAt,
         receivedAt: receivedAt,
         status: status,
         failureReason: failureReason,
         structured: structured,
         incidentId: incidentId,
       );

  /// Returns a shallow copy of this [Report]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Report copyWith({
    Object? id = _Undefined,
    int? zoneId,
    _isc.UuidValue? clientReportId,
    String? reporterKey,
    String? rawText,
    bool? hasImage,
    Object? clientLocation = _Undefined,
    Object? locationAccuracyM = _Undefined,
    DateTime? clientCreatedAt,
    DateTime? receivedAt,
    _i8pcsu0p.ReportStatus? status,
    Object? failureReason = _Undefined,
    Object? structured = _Undefined,
    Object? incidentId = _Undefined,
  }) {
    return Report(
      id: id is int? ? id : this.id,
      zoneId: zoneId ?? this.zoneId,
      clientReportId: clientReportId ?? this.clientReportId,
      reporterKey: reporterKey ?? this.reporterKey,
      rawText: rawText ?? this.rawText,
      hasImage: hasImage ?? this.hasImage,
      clientLocation: clientLocation is _isc.GeographyPoint?
          ? clientLocation
          : this.clientLocation,
      locationAccuracyM: locationAccuracyM is double?
          ? locationAccuracyM
          : this.locationAccuracyM,
      clientCreatedAt: clientCreatedAt ?? this.clientCreatedAt,
      receivedAt: receivedAt ?? this.receivedAt,
      status: status ?? this.status,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      structured: structured is _imc53az5.StructuredReport?
          ? structured
          : this.structured?.copyWith(),
      incidentId: incidentId is int? ? incidentId : this.incidentId,
    );
  }
}
