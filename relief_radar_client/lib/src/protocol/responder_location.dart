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

abstract class ResponderLocation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResponderLocation._({
    this.id,
    required this.responderId,
    required this.latitude,
    required this.longitude,
    DateTime? timestamp,
    required this.status,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ResponderLocation({
    int? id,
    required int responderId,
    required double latitude,
    required double longitude,
    DateTime? timestamp,
    required String status,
  }) = _ResponderLocationImpl;

  factory ResponderLocation.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResponderLocation(
      id: jsonSerialization['id'] as int?,
      responderId: jsonSerialization['responderId'] as int,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      status: jsonSerialization['status'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int responderId;

  double latitude;

  double longitude;

  DateTime timestamp;

  String status;

  /// Returns a shallow copy of this [ResponderLocation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResponderLocation copyWith({
    int? id,
    int? responderId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResponderLocation',
      if (id != null) 'id': id,
      'responderId': responderId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toJson(),
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResponderLocation',
      if (id != null) 'id': id,
      'responderId': responderId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toJson(),
      'status': status,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderLocationImpl extends ResponderLocation {
  _ResponderLocationImpl({
    int? id,
    required int responderId,
    required double latitude,
    required double longitude,
    DateTime? timestamp,
    required String status,
  }) : super._(
         id: id,
         responderId: responderId,
         latitude: latitude,
         longitude: longitude,
         timestamp: timestamp,
         status: status,
       );

  /// Returns a shallow copy of this [ResponderLocation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResponderLocation copyWith({
    Object? id = _Undefined,
    int? responderId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    String? status,
  }) {
    return ResponderLocation(
      id: id is int? ? id : this.id,
      responderId: responderId ?? this.responderId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
