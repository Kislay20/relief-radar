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

abstract class SituationReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SituationReport._({
    required this.title,
    required this.timestamp,
    required this.threatLevel,
    required this.executiveSummary,
    required this.criticalIncidentsCount,
    required this.openIncidentsCount,
    required this.totalHeadcountAtRisk,
    required this.keyPriorities,
    required this.resourceRecommendations,
    required this.generatedBy,
  });

  factory SituationReport({
    required String title,
    required DateTime timestamp,
    required String threatLevel,
    required String executiveSummary,
    required int criticalIncidentsCount,
    required int openIncidentsCount,
    required int totalHeadcountAtRisk,
    required List<String> keyPriorities,
    required List<String> resourceRecommendations,
    required String generatedBy,
  }) = _SituationReportImpl;

  factory SituationReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SituationReport(
      title: jsonSerialization['title'] as String,
      timestamp: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      threatLevel: jsonSerialization['threatLevel'] as String,
      executiveSummary: jsonSerialization['executiveSummary'] as String,
      criticalIncidentsCount:
          jsonSerialization['criticalIncidentsCount'] as int,
      openIncidentsCount: jsonSerialization['openIncidentsCount'] as int,
      totalHeadcountAtRisk: jsonSerialization['totalHeadcountAtRisk'] as int,
      keyPriorities: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['keyPriorities'],
      ),
      resourceRecommendations: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['resourceRecommendations'],
      ),
      generatedBy: jsonSerialization['generatedBy'] as String,
    );
  }

  String title;

  DateTime timestamp;

  String threatLevel;

  String executiveSummary;

  int criticalIncidentsCount;

  int openIncidentsCount;

  int totalHeadcountAtRisk;

  List<String> keyPriorities;

  List<String> resourceRecommendations;

  String generatedBy;

  /// Returns a shallow copy of this [SituationReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SituationReport copyWith({
    String? title,
    DateTime? timestamp,
    String? threatLevel,
    String? executiveSummary,
    int? criticalIncidentsCount,
    int? openIncidentsCount,
    int? totalHeadcountAtRisk,
    List<String>? keyPriorities,
    List<String>? resourceRecommendations,
    String? generatedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SituationReport',
      'title': title,
      'timestamp': timestamp.toJson(),
      'threatLevel': threatLevel,
      'executiveSummary': executiveSummary,
      'criticalIncidentsCount': criticalIncidentsCount,
      'openIncidentsCount': openIncidentsCount,
      'totalHeadcountAtRisk': totalHeadcountAtRisk,
      'keyPriorities': keyPriorities.toJson(),
      'resourceRecommendations': resourceRecommendations.toJson(),
      'generatedBy': generatedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SituationReport',
      'title': title,
      'timestamp': timestamp.toJson(),
      'threatLevel': threatLevel,
      'executiveSummary': executiveSummary,
      'criticalIncidentsCount': criticalIncidentsCount,
      'openIncidentsCount': openIncidentsCount,
      'totalHeadcountAtRisk': totalHeadcountAtRisk,
      'keyPriorities': keyPriorities.toJson(),
      'resourceRecommendations': resourceRecommendations.toJson(),
      'generatedBy': generatedBy,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SituationReportImpl extends SituationReport {
  _SituationReportImpl({
    required String title,
    required DateTime timestamp,
    required String threatLevel,
    required String executiveSummary,
    required int criticalIncidentsCount,
    required int openIncidentsCount,
    required int totalHeadcountAtRisk,
    required List<String> keyPriorities,
    required List<String> resourceRecommendations,
    required String generatedBy,
  }) : super._(
         title: title,
         timestamp: timestamp,
         threatLevel: threatLevel,
         executiveSummary: executiveSummary,
         criticalIncidentsCount: criticalIncidentsCount,
         openIncidentsCount: openIncidentsCount,
         totalHeadcountAtRisk: totalHeadcountAtRisk,
         keyPriorities: keyPriorities,
         resourceRecommendations: resourceRecommendations,
         generatedBy: generatedBy,
       );

  /// Returns a shallow copy of this [SituationReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SituationReport copyWith({
    String? title,
    DateTime? timestamp,
    String? threatLevel,
    String? executiveSummary,
    int? criticalIncidentsCount,
    int? openIncidentsCount,
    int? totalHeadcountAtRisk,
    List<String>? keyPriorities,
    List<String>? resourceRecommendations,
    String? generatedBy,
  }) {
    return SituationReport(
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      threatLevel: threatLevel ?? this.threatLevel,
      executiveSummary: executiveSummary ?? this.executiveSummary,
      criticalIncidentsCount:
          criticalIncidentsCount ?? this.criticalIncidentsCount,
      openIncidentsCount: openIncidentsCount ?? this.openIncidentsCount,
      totalHeadcountAtRisk: totalHeadcountAtRisk ?? this.totalHeadcountAtRisk,
      keyPriorities:
          keyPriorities ?? this.keyPriorities.map((e0) => e0).toList(),
      resourceRecommendations:
          resourceRecommendations ??
          this.resourceRecommendations.map((e0) => e0).toList(),
      generatedBy: generatedBy ?? this.generatedBy,
    );
  }
}
