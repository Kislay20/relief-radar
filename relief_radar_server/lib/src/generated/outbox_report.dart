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
import 'package:serverpod/serverpod.dart' as _is;

abstract class OutboxReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  OutboxReport._({
    this.id,
    required this.clientReportId,
    required this.zoneId,
    required this.rawText,
    this.lat,
    this.lng,
    this.accuracyM,
    this.imagePath,
    required this.clientCreatedAt,
    required this.state,
    int? attempts,
    this.lastError,
  }) : attempts = attempts ?? 0;

  factory OutboxReport({
    int? id,
    required _is.UuidValue clientReportId,
    required int zoneId,
    required String rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    String? imagePath,
    required DateTime clientCreatedAt,
    required String state,
    int? attempts,
    String? lastError,
  }) = _OutboxReportImpl;

  factory OutboxReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return OutboxReport(
      id: jsonSerialization['id'] as int?,
      clientReportId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientReportId'],
      ),
      zoneId: jsonSerialization['zoneId'] as int,
      rawText: jsonSerialization['rawText'] as String,
      lat: (jsonSerialization['lat'] as num?)?.toDouble(),
      lng: (jsonSerialization['lng'] as num?)?.toDouble(),
      accuracyM: (jsonSerialization['accuracyM'] as num?)?.toDouble(),
      imagePath: jsonSerialization['imagePath'] as String?,
      clientCreatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['clientCreatedAt'],
      ),
      state: jsonSerialization['state'] as String,
      attempts: jsonSerialization['attempts'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _is.UuidValue clientReportId;

  int zoneId;

  String rawText;

  double? lat;

  double? lng;

  double? accuracyM;

  String? imagePath;

  DateTime clientCreatedAt;

  String state;

  int attempts;

  String? lastError;

  /// Returns a shallow copy of this [OutboxReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OutboxReport copyWith({
    int? id,
    _is.UuidValue? clientReportId,
    int? zoneId,
    String? rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    String? imagePath,
    DateTime? clientCreatedAt,
    String? state,
    int? attempts,
    String? lastError,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OutboxReport',
      if (id != null) 'id': id,
      'clientReportId': clientReportId.toJson(),
      'zoneId': zoneId,
      'rawText': rawText,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracyM': accuracyM,
      if (imagePath != null) 'imagePath': imagePath,
      'clientCreatedAt': clientCreatedAt.toJson(),
      'state': state,
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OutboxReport',
      if (id != null) 'id': id,
      'clientReportId': clientReportId.toJson(),
      'zoneId': zoneId,
      'rawText': rawText,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracyM': accuracyM,
      if (imagePath != null) 'imagePath': imagePath,
      'clientCreatedAt': clientCreatedAt.toJson(),
      'state': state,
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OutboxReportImpl extends OutboxReport {
  _OutboxReportImpl({
    int? id,
    required _is.UuidValue clientReportId,
    required int zoneId,
    required String rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    String? imagePath,
    required DateTime clientCreatedAt,
    required String state,
    int? attempts,
    String? lastError,
  }) : super._(
         id: id,
         clientReportId: clientReportId,
         zoneId: zoneId,
         rawText: rawText,
         lat: lat,
         lng: lng,
         accuracyM: accuracyM,
         imagePath: imagePath,
         clientCreatedAt: clientCreatedAt,
         state: state,
         attempts: attempts,
         lastError: lastError,
       );

  /// Returns a shallow copy of this [OutboxReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OutboxReport copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clientReportId,
    int? zoneId,
    String? rawText,
    Object? lat = _Undefined,
    Object? lng = _Undefined,
    Object? accuracyM = _Undefined,
    Object? imagePath = _Undefined,
    DateTime? clientCreatedAt,
    String? state,
    int? attempts,
    Object? lastError = _Undefined,
  }) {
    return OutboxReport(
      id: id is int? ? id : this.id,
      clientReportId: clientReportId ?? this.clientReportId,
      zoneId: zoneId ?? this.zoneId,
      rawText: rawText ?? this.rawText,
      lat: lat is double? ? lat : this.lat,
      lng: lng is double? ? lng : this.lng,
      accuracyM: accuracyM is double? ? accuracyM : this.accuracyM,
      imagePath: imagePath is String? ? imagePath : this.imagePath,
      clientCreatedAt: clientCreatedAt ?? this.clientCreatedAt,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      lastError: lastError is String? ? lastError : this.lastError,
    );
  }
}
