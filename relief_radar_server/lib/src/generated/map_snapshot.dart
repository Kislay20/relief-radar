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

abstract class MapSnapshot
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MapSnapshot._({
    required this.incidents,
    required this.headSeq,
    required this.serverNow,
  });

  factory MapSnapshot({
    required List<_idmorftz.IncidentSnapshot> incidents,
    required int headSeq,
    required DateTime serverNow,
  }) = _MapSnapshotImpl;

  factory MapSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return MapSnapshot(
      incidents: _i78gox42.Protocol()
          .deserialize<List<_idmorftz.IncidentSnapshot>>(
            jsonSerialization['incidents'],
          ),
      headSeq: jsonSerialization['headSeq'] as int,
      serverNow: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverNow'],
      ),
    );
  }

  List<_idmorftz.IncidentSnapshot> incidents;

  int headSeq;

  DateTime serverNow;

  /// Returns a shallow copy of this [MapSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MapSnapshot copyWith({
    List<_idmorftz.IncidentSnapshot>? incidents,
    int? headSeq,
    DateTime? serverNow,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MapSnapshot',
      'incidents': incidents.toJson(valueToJson: (v) => v.toJson()),
      'headSeq': headSeq,
      'serverNow': serverNow.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MapSnapshot',
      'incidents': incidents.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'headSeq': headSeq,
      'serverNow': serverNow.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MapSnapshotImpl extends MapSnapshot {
  _MapSnapshotImpl({
    required List<_idmorftz.IncidentSnapshot> incidents,
    required int headSeq,
    required DateTime serverNow,
  }) : super._(
         incidents: incidents,
         headSeq: headSeq,
         serverNow: serverNow,
       );

  /// Returns a shallow copy of this [MapSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MapSnapshot copyWith({
    List<_idmorftz.IncidentSnapshot>? incidents,
    int? headSeq,
    DateTime? serverNow,
  }) {
    return MapSnapshot(
      incidents:
          incidents ?? this.incidents.map((e0) => e0.copyWith()).toList(),
      headSeq: headSeq ?? this.headSeq,
      serverNow: serverNow ?? this.serverNow,
    );
  }
}
