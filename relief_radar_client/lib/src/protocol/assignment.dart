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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'assignment_status.dart' as _ikrvejjw;

abstract class Assignment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Assignment._({
    this.id,
    required this.incidentId,
    required this.responderId,
    required this.status,
    required this.offeredAtLevel,
    DateTime? offeredAt,
    this.respondedAt,
    this.etaMinutes,
  }) : offeredAt = offeredAt ?? DateTime.now();

  factory Assignment({
    int? id,
    required int incidentId,
    required int responderId,
    required _ikrvejjw.AssignmentStatus status,
    required int offeredAtLevel,
    DateTime? offeredAt,
    DateTime? respondedAt,
    int? etaMinutes,
  }) = _AssignmentImpl;

  factory Assignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Assignment(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      responderId: jsonSerialization['responderId'] as int,
      status: _ikrvejjw.AssignmentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      offeredAtLevel: jsonSerialization['offeredAtLevel'] as int,
      offeredAt: jsonSerialization['offeredAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['offeredAt']),
      respondedAt: jsonSerialization['respondedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['respondedAt'],
            ),
      etaMinutes: jsonSerialization['etaMinutes'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int incidentId;

  int responderId;

  _ikrvejjw.AssignmentStatus status;

  int offeredAtLevel;

  DateTime offeredAt;

  DateTime? respondedAt;

  int? etaMinutes;

  /// Returns a shallow copy of this [Assignment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Assignment copyWith({
    int? id,
    int? incidentId,
    int? responderId,
    _ikrvejjw.AssignmentStatus? status,
    int? offeredAtLevel,
    DateTime? offeredAt,
    DateTime? respondedAt,
    int? etaMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Assignment',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'responderId': responderId,
      'status': status.toJson(),
      'offeredAtLevel': offeredAtLevel,
      'offeredAt': offeredAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Assignment',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'responderId': responderId,
      'status': status.toJson(),
      'offeredAtLevel': offeredAtLevel,
      'offeredAt': offeredAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssignmentImpl extends Assignment {
  _AssignmentImpl({
    int? id,
    required int incidentId,
    required int responderId,
    required _ikrvejjw.AssignmentStatus status,
    required int offeredAtLevel,
    DateTime? offeredAt,
    DateTime? respondedAt,
    int? etaMinutes,
  }) : super._(
         id: id,
         incidentId: incidentId,
         responderId: responderId,
         status: status,
         offeredAtLevel: offeredAtLevel,
         offeredAt: offeredAt,
         respondedAt: respondedAt,
         etaMinutes: etaMinutes,
       );

  /// Returns a shallow copy of this [Assignment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Assignment copyWith({
    Object? id = _Undefined,
    int? incidentId,
    int? responderId,
    _ikrvejjw.AssignmentStatus? status,
    int? offeredAtLevel,
    DateTime? offeredAt,
    Object? respondedAt = _Undefined,
    Object? etaMinutes = _Undefined,
  }) {
    return Assignment(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      responderId: responderId ?? this.responderId,
      status: status ?? this.status,
      offeredAtLevel: offeredAtLevel ?? this.offeredAtLevel,
      offeredAt: offeredAt ?? this.offeredAt,
      respondedAt: respondedAt is DateTime? ? respondedAt : this.respondedAt,
      etaMinutes: etaMinutes is int? ? etaMinutes : this.etaMinutes,
    );
  }
}
