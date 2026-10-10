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
import 'event_payload.dart' as _iusxws0y;
import 'event_type.dart' as _in8qly3f;

abstract class Event
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Event._({
    this.id,
    required this.streamId,
    required this.seq,
    required this.type,
    this.incidentId,
    required this.payload,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Event({
    int? id,
    required String streamId,
    required int seq,
    required _in8qly3f.EventType type,
    int? incidentId,
    required _iusxws0y.EventPayload payload,
    DateTime? createdAt,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] as int?,
      streamId: jsonSerialization['streamId'] as String,
      seq: jsonSerialization['seq'] as int,
      type: _in8qly3f.EventType.fromJson((jsonSerialization['type'] as String)),
      incidentId: jsonSerialization['incidentId'] as int?,
      payload: _if75qna0.Protocol().deserialize<_iusxws0y.EventPayload>(
        jsonSerialization['payload'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String streamId;

  int seq;

  _in8qly3f.EventType type;

  int? incidentId;

  _iusxws0y.EventPayload payload;

  DateTime createdAt;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Event copyWith({
    int? id,
    String? streamId,
    int? seq,
    _in8qly3f.EventType? type,
    int? incidentId,
    _iusxws0y.EventPayload? payload,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'streamId': streamId,
      'seq': seq,
      'type': type.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
      'payload': payload.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'streamId': streamId,
      'seq': seq,
      'type': type.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
      'payload': payload.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventImpl extends Event {
  _EventImpl({
    int? id,
    required String streamId,
    required int seq,
    required _in8qly3f.EventType type,
    int? incidentId,
    required _iusxws0y.EventPayload payload,
    DateTime? createdAt,
  }) : super._(
         id: id,
         streamId: streamId,
         seq: seq,
         type: type,
         incidentId: incidentId,
         payload: payload,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    String? streamId,
    int? seq,
    _in8qly3f.EventType? type,
    Object? incidentId = _Undefined,
    _iusxws0y.EventPayload? payload,
    DateTime? createdAt,
  }) {
    return Event(
      id: id is int? ? id : this.id,
      streamId: streamId ?? this.streamId,
      seq: seq ?? this.seq,
      type: type ?? this.type,
      incidentId: incidentId is int? ? incidentId : this.incidentId,
      payload: payload ?? this.payload.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
