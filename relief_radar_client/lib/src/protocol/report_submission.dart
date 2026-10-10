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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ReportSubmission
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReportSubmission._({
    required this.zoneId,
    required this.clientReportId,
    required this.rawText,
    this.lat,
    this.lng,
    this.accuracyM,
    required this.clientCreatedAt,
    this.imageBytes,
    this.imageMime,
  });

  factory ReportSubmission({
    required int zoneId,
    required _isc.UuidValue clientReportId,
    required String rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    required DateTime clientCreatedAt,
    _idt.ByteData? imageBytes,
    String? imageMime,
  }) = _ReportSubmissionImpl;

  factory ReportSubmission.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportSubmission(
      zoneId: jsonSerialization['zoneId'] as int,
      clientReportId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientReportId'],
      ),
      rawText: jsonSerialization['rawText'] as String,
      lat: (jsonSerialization['lat'] as num?)?.toDouble(),
      lng: (jsonSerialization['lng'] as num?)?.toDouble(),
      accuracyM: (jsonSerialization['accuracyM'] as num?)?.toDouble(),
      clientCreatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['clientCreatedAt'],
      ),
      imageBytes: jsonSerialization['imageBytes'] == null
          ? null
          : _isc.ByteDataJsonExtension.fromJson(
              jsonSerialization['imageBytes'],
            ),
      imageMime: jsonSerialization['imageMime'] as String?,
    );
  }

  int zoneId;

  _isc.UuidValue clientReportId;

  String rawText;

  double? lat;

  double? lng;

  double? accuracyM;

  DateTime clientCreatedAt;

  _idt.ByteData? imageBytes;

  String? imageMime;

  /// Returns a shallow copy of this [ReportSubmission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReportSubmission copyWith({
    int? zoneId,
    _isc.UuidValue? clientReportId,
    String? rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    DateTime? clientCreatedAt,
    _idt.ByteData? imageBytes,
    String? imageMime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportSubmission',
      'zoneId': zoneId,
      'clientReportId': clientReportId.toJson(),
      'rawText': rawText,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracyM': accuracyM,
      'clientCreatedAt': clientCreatedAt.toJson(),
      if (imageBytes != null) 'imageBytes': imageBytes?.toJson(),
      if (imageMime != null) 'imageMime': imageMime,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportSubmission',
      'zoneId': zoneId,
      'clientReportId': clientReportId.toJson(),
      'rawText': rawText,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracyM': accuracyM,
      'clientCreatedAt': clientCreatedAt.toJson(),
      if (imageBytes != null) 'imageBytes': imageBytes?.toJson(),
      if (imageMime != null) 'imageMime': imageMime,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportSubmissionImpl extends ReportSubmission {
  _ReportSubmissionImpl({
    required int zoneId,
    required _isc.UuidValue clientReportId,
    required String rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    required DateTime clientCreatedAt,
    _idt.ByteData? imageBytes,
    String? imageMime,
  }) : super._(
         zoneId: zoneId,
         clientReportId: clientReportId,
         rawText: rawText,
         lat: lat,
         lng: lng,
         accuracyM: accuracyM,
         clientCreatedAt: clientCreatedAt,
         imageBytes: imageBytes,
         imageMime: imageMime,
       );

  /// Returns a shallow copy of this [ReportSubmission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReportSubmission copyWith({
    int? zoneId,
    _isc.UuidValue? clientReportId,
    String? rawText,
    Object? lat = _Undefined,
    Object? lng = _Undefined,
    Object? accuracyM = _Undefined,
    DateTime? clientCreatedAt,
    Object? imageBytes = _Undefined,
    Object? imageMime = _Undefined,
  }) {
    return ReportSubmission(
      zoneId: zoneId ?? this.zoneId,
      clientReportId: clientReportId ?? this.clientReportId,
      rawText: rawText ?? this.rawText,
      lat: lat is double? ? lat : this.lat,
      lng: lng is double? ? lng : this.lng,
      accuracyM: accuracyM is double? ? accuracyM : this.accuracyM,
      clientCreatedAt: clientCreatedAt ?? this.clientCreatedAt,
      imageBytes: imageBytes is _idt.ByteData?
          ? imageBytes
          : this.imageBytes?.clone(),
      imageMime: imageMime is String? ? imageMime : this.imageMime,
    );
  }
}
