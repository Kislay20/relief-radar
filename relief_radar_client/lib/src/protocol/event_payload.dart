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
import 'incident_snapshot.dart' as _idmorftz;

abstract class EventPayload
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EventPayload._({
    this.incident,
    this.fromLevel,
    this.toLevel,
    this.radiusM,
    this.reportId,
    this.responderId,
    this.note,
  });

  factory EventPayload({
    _idmorftz.IncidentSnapshot? incident,
    int? fromLevel,
    int? toLevel,
    double? radiusM,
    int? reportId,
    int? responderId,
    String? note,
  }) = _EventPayloadImpl;

  factory EventPayload.fromJson(Map<String, dynamic> jsonSerialization) {
    return EventPayload(
      incident: jsonSerialization['incident'] == null
          ? null
          : _if75qna0.Protocol().deserialize<_idmorftz.IncidentSnapshot>(
              jsonSerialization['incident'],
            ),
      fromLevel: jsonSerialization['fromLevel'] as int?,
      toLevel: jsonSerialization['toLevel'] as int?,
      radiusM: (jsonSerialization['radiusM'] as num?)?.toDouble(),
      reportId: jsonSerialization['reportId'] as int?,
      responderId: jsonSerialization['responderId'] as int?,
      note: jsonSerialization['note'] as String?,
    );
  }

  _idmorftz.IncidentSnapshot? incident;

  int? fromLevel;

  int? toLevel;

  double? radiusM;

  int? reportId;

  int? responderId;

  String? note;

  /// Returns a shallow copy of this [EventPayload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EventPayload copyWith({
    _idmorftz.IncidentSnapshot? incident,
    int? fromLevel,
    int? toLevel,
    double? radiusM,
    int? reportId,
    int? responderId,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EventPayload',
      if (incident != null) 'incident': incident?.toJson(),
      if (fromLevel != null) 'fromLevel': fromLevel,
      if (toLevel != null) 'toLevel': toLevel,
      if (radiusM != null) 'radiusM': radiusM,
      if (reportId != null) 'reportId': reportId,
      if (responderId != null) 'responderId': responderId,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EventPayload',
      if (incident != null) 'incident': incident?.toJsonForProtocol(),
      if (fromLevel != null) 'fromLevel': fromLevel,
      if (toLevel != null) 'toLevel': toLevel,
      if (radiusM != null) 'radiusM': radiusM,
      if (reportId != null) 'reportId': reportId,
      if (responderId != null) 'responderId': responderId,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventPayloadImpl extends EventPayload {
  _EventPayloadImpl({
    _idmorftz.IncidentSnapshot? incident,
    int? fromLevel,
    int? toLevel,
    double? radiusM,
    int? reportId,
    int? responderId,
    String? note,
  }) : super._(
         incident: incident,
         fromLevel: fromLevel,
         toLevel: toLevel,
         radiusM: radiusM,
         reportId: reportId,
         responderId: responderId,
         note: note,
       );

  /// Returns a shallow copy of this [EventPayload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EventPayload copyWith({
    Object? incident = _Undefined,
    Object? fromLevel = _Undefined,
    Object? toLevel = _Undefined,
    Object? radiusM = _Undefined,
    Object? reportId = _Undefined,
    Object? responderId = _Undefined,
    Object? note = _Undefined,
  }) {
    return EventPayload(
      incident: incident is _idmorftz.IncidentSnapshot?
          ? incident
          : this.incident?.copyWith(),
      fromLevel: fromLevel is int? ? fromLevel : this.fromLevel,
      toLevel: toLevel is int? ? toLevel : this.toLevel,
      radiusM: radiusM is double? ? radiusM : this.radiusM,
      reportId: reportId is int? ? reportId : this.reportId,
      responderId: responderId is int? ? responderId : this.responderId,
      note: note is String? ? note : this.note,
    );
  }
}
