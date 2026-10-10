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
import 'need_type.dart' as _iq4zvdzd;

abstract class StructuredReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StructuredReport._({
    required this.needType,
    required this.severity,
    this.headcount,
    required this.vulnerabilities,
    required this.hazards,
    this.waterDepthCm,
    required this.translatedText,
    required this.detectedLang,
    this.locationHint,
    this.imageObservations,
    required this.confidence,
  });

  factory StructuredReport({
    required _iq4zvdzd.NeedType needType,
    required int severity,
    int? headcount,
    required List<String> vulnerabilities,
    required List<String> hazards,
    int? waterDepthCm,
    required String translatedText,
    required String detectedLang,
    String? locationHint,
    String? imageObservations,
    required double confidence,
  }) = _StructuredReportImpl;

  factory StructuredReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return StructuredReport(
      needType: _iq4zvdzd.NeedType.fromJson(
        (jsonSerialization['needType'] as String),
      ),
      severity: jsonSerialization['severity'] as int,
      headcount: jsonSerialization['headcount'] as int?,
      vulnerabilities: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['vulnerabilities'],
      ),
      hazards: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['hazards'],
      ),
      waterDepthCm: jsonSerialization['waterDepthCm'] as int?,
      translatedText: jsonSerialization['translatedText'] as String,
      detectedLang: jsonSerialization['detectedLang'] as String,
      locationHint: jsonSerialization['locationHint'] as String?,
      imageObservations: jsonSerialization['imageObservations'] as String?,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
    );
  }

  _iq4zvdzd.NeedType needType;

  int severity;

  int? headcount;

  List<String> vulnerabilities;

  List<String> hazards;

  int? waterDepthCm;

  String translatedText;

  String detectedLang;

  String? locationHint;

  String? imageObservations;

  double confidence;

  /// Returns a shallow copy of this [StructuredReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StructuredReport copyWith({
    _iq4zvdzd.NeedType? needType,
    int? severity,
    int? headcount,
    List<String>? vulnerabilities,
    List<String>? hazards,
    int? waterDepthCm,
    String? translatedText,
    String? detectedLang,
    String? locationHint,
    String? imageObservations,
    double? confidence,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StructuredReport',
      'needType': needType.toJson(),
      'severity': severity,
      if (headcount != null) 'headcount': headcount,
      'vulnerabilities': vulnerabilities.toJson(),
      'hazards': hazards.toJson(),
      if (waterDepthCm != null) 'waterDepthCm': waterDepthCm,
      'translatedText': translatedText,
      'detectedLang': detectedLang,
      if (locationHint != null) 'locationHint': locationHint,
      if (imageObservations != null) 'imageObservations': imageObservations,
      'confidence': confidence,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StructuredReport',
      'needType': needType.toJson(),
      'severity': severity,
      if (headcount != null) 'headcount': headcount,
      'vulnerabilities': vulnerabilities.toJson(),
      'hazards': hazards.toJson(),
      if (waterDepthCm != null) 'waterDepthCm': waterDepthCm,
      'translatedText': translatedText,
      'detectedLang': detectedLang,
      if (locationHint != null) 'locationHint': locationHint,
      if (imageObservations != null) 'imageObservations': imageObservations,
      'confidence': confidence,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StructuredReportImpl extends StructuredReport {
  _StructuredReportImpl({
    required _iq4zvdzd.NeedType needType,
    required int severity,
    int? headcount,
    required List<String> vulnerabilities,
    required List<String> hazards,
    int? waterDepthCm,
    required String translatedText,
    required String detectedLang,
    String? locationHint,
    String? imageObservations,
    required double confidence,
  }) : super._(
         needType: needType,
         severity: severity,
         headcount: headcount,
         vulnerabilities: vulnerabilities,
         hazards: hazards,
         waterDepthCm: waterDepthCm,
         translatedText: translatedText,
         detectedLang: detectedLang,
         locationHint: locationHint,
         imageObservations: imageObservations,
         confidence: confidence,
       );

  /// Returns a shallow copy of this [StructuredReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StructuredReport copyWith({
    _iq4zvdzd.NeedType? needType,
    int? severity,
    Object? headcount = _Undefined,
    List<String>? vulnerabilities,
    List<String>? hazards,
    Object? waterDepthCm = _Undefined,
    String? translatedText,
    String? detectedLang,
    Object? locationHint = _Undefined,
    Object? imageObservations = _Undefined,
    double? confidence,
  }) {
    return StructuredReport(
      needType: needType ?? this.needType,
      severity: severity ?? this.severity,
      headcount: headcount is int? ? headcount : this.headcount,
      vulnerabilities:
          vulnerabilities ?? this.vulnerabilities.map((e0) => e0).toList(),
      hazards: hazards ?? this.hazards.map((e0) => e0).toList(),
      waterDepthCm: waterDepthCm is int? ? waterDepthCm : this.waterDepthCm,
      translatedText: translatedText ?? this.translatedText,
      detectedLang: detectedLang ?? this.detectedLang,
      locationHint: locationHint is String? ? locationHint : this.locationHint,
      imageObservations: imageObservations is String?
          ? imageObservations
          : this.imageObservations,
      confidence: confidence ?? this.confidence,
    );
  }
}
