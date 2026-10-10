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
import 'incident_snapshot.dart' as _idmorftz;

abstract class IncidentCache
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IncidentCache._({
    this.id,
    required this.incidentId,
    required this.zoneId,
    required this.snapshot,
  });

  factory IncidentCache({
    int? id,
    required int incidentId,
    required int zoneId,
    required _idmorftz.IncidentSnapshot snapshot,
  }) = _IncidentCacheImpl;

  factory IncidentCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentCache(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      zoneId: jsonSerialization['zoneId'] as int,
      snapshot: _i78gox42.Protocol().deserialize<_idmorftz.IncidentSnapshot>(
        jsonSerialization['snapshot'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int incidentId;

  int zoneId;

  _idmorftz.IncidentSnapshot snapshot;

  /// Returns a shallow copy of this [IncidentCache]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IncidentCache copyWith({
    int? id,
    int? incidentId,
    int? zoneId,
    _idmorftz.IncidentSnapshot? snapshot,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentCache',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'zoneId': zoneId,
      'snapshot': snapshot.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentCache',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'zoneId': zoneId,
      'snapshot': snapshot.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentCacheImpl extends IncidentCache {
  _IncidentCacheImpl({
    int? id,
    required int incidentId,
    required int zoneId,
    required _idmorftz.IncidentSnapshot snapshot,
  }) : super._(
         id: id,
         incidentId: incidentId,
         zoneId: zoneId,
         snapshot: snapshot,
       );

  /// Returns a shallow copy of this [IncidentCache]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IncidentCache copyWith({
    Object? id = _Undefined,
    int? incidentId,
    int? zoneId,
    _idmorftz.IncidentSnapshot? snapshot,
  }) {
    return IncidentCache(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      zoneId: zoneId ?? this.zoneId,
      snapshot: snapshot ?? this.snapshot.copyWith(),
    );
  }
}
