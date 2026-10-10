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

abstract class DisasterZone
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DisasterZone._({
    this.id,
    required this.name,
    required this.kind,
    required this.center,
    this.bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) : active = active ?? true,
       timeScale = timeScale ?? 1.0,
       createdAt = createdAt ?? DateTime.now();

  factory DisasterZone({
    int? id,
    required String name,
    required String kind,
    required _isc.GeographyPoint center,
    _isc.GeographyPolygon? bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) = _DisasterZoneImpl;

  factory DisasterZone.fromJson(Map<String, dynamic> jsonSerialization) {
    return DisasterZone(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      kind: jsonSerialization['kind'] as String,
      center: _isc.GeographyPointJsonExtension.fromJson(
        jsonSerialization['center'],
      ),
      bounds: jsonSerialization['bounds'] == null
          ? null
          : _isc.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['bounds'],
            ),
      active: jsonSerialization['active'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      timeScale: (jsonSerialization['timeScale'] as num?)?.toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String kind;

  _isc.GeographyPoint center;

  _isc.GeographyPolygon? bounds;

  bool active;

  double timeScale;

  DateTime createdAt;

  /// Returns a shallow copy of this [DisasterZone]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DisasterZone copyWith({
    int? id,
    String? name,
    String? kind,
    _isc.GeographyPoint? center,
    _isc.GeographyPolygon? bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DisasterZone',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'center': center.toJson(),
      if (bounds != null) 'bounds': bounds?.toJson(),
      'active': active,
      'timeScale': timeScale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DisasterZone',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'center': center.toJson(),
      if (bounds != null) 'bounds': bounds?.toJson(),
      'active': active,
      'timeScale': timeScale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DisasterZoneImpl extends DisasterZone {
  _DisasterZoneImpl({
    int? id,
    required String name,
    required String kind,
    required _isc.GeographyPoint center,
    _isc.GeographyPolygon? bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         kind: kind,
         center: center,
         bounds: bounds,
         active: active,
         timeScale: timeScale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DisasterZone]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DisasterZone copyWith({
    Object? id = _Undefined,
    String? name,
    String? kind,
    _isc.GeographyPoint? center,
    Object? bounds = _Undefined,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) {
    return DisasterZone(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      center: center ?? this.center,
      bounds: bounds is _isc.GeographyPolygon? ? bounds : this.bounds,
      active: active ?? this.active,
      timeScale: timeScale ?? this.timeScale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
