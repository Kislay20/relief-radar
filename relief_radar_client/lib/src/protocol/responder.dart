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
import 'need_type.dart' as _iq4zvdzd;
import 'responder_status.dart' as _ivpp8a10;

abstract class Responder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Responder._({
    this.id,
    required this.authUserId,
    required this.displayName,
    required this.capabilities,
    int? capacity,
    required this.status,
    this.location,
    this.lastSeenAt,
  }) : capacity = capacity ?? 1;

  factory Responder({
    int? id,
    required _isc.UuidValue authUserId,
    required String displayName,
    required List<_iq4zvdzd.NeedType> capabilities,
    int? capacity,
    required _ivpp8a10.ResponderStatus status,
    _isc.GeographyPoint? location,
    DateTime? lastSeenAt,
  }) = _ResponderImpl;

  factory Responder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Responder(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      capabilities: _if75qna0.Protocol().deserialize<List<_iq4zvdzd.NeedType>>(
        jsonSerialization['capabilities'],
      ),
      capacity: jsonSerialization['capacity'] as int?,
      status: _ivpp8a10.ResponderStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      location: jsonSerialization['location'] == null
          ? null
          : _isc.GeographyPointJsonExtension.fromJson(
              jsonSerialization['location'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String displayName;

  List<_iq4zvdzd.NeedType> capabilities;

  int capacity;

  _ivpp8a10.ResponderStatus status;

  _isc.GeographyPoint? location;

  DateTime? lastSeenAt;

  /// Returns a shallow copy of this [Responder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Responder copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? displayName,
    List<_iq4zvdzd.NeedType>? capabilities,
    int? capacity,
    _ivpp8a10.ResponderStatus? status,
    _isc.GeographyPoint? location,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Responder',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'capabilities': capabilities.toJson(valueToJson: (v) => v.toJson()),
      'capacity': capacity,
      'status': status.toJson(),
      if (location != null) 'location': location?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Responder',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'capabilities': capabilities.toJson(valueToJson: (v) => v.toJson()),
      'capacity': capacity,
      'status': status.toJson(),
      if (location != null) 'location': location?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderImpl extends Responder {
  _ResponderImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String displayName,
    required List<_iq4zvdzd.NeedType> capabilities,
    int? capacity,
    required _ivpp8a10.ResponderStatus status,
    _isc.GeographyPoint? location,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         capabilities: capabilities,
         capacity: capacity,
         status: status,
         location: location,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [Responder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Responder copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? displayName,
    List<_iq4zvdzd.NeedType>? capabilities,
    int? capacity,
    _ivpp8a10.ResponderStatus? status,
    Object? location = _Undefined,
    Object? lastSeenAt = _Undefined,
  }) {
    return Responder(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      capabilities: capabilities ?? this.capabilities.map((e0) => e0).toList(),
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      location: location is _isc.GeographyPoint? ? location : this.location,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
    );
  }
}
