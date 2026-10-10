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
import 'package:serverpod/serverpod.dart' as _is;

abstract class StreamCursor
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StreamCursor._({
    this.id,
    required this.streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) : lastSeq = lastSeq ?? 0,
       updatedAt = updatedAt ?? DateTime.now();

  factory StreamCursor({
    int? id,
    required String streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) = _StreamCursorImpl;

  factory StreamCursor.fromJson(Map<String, dynamic> jsonSerialization) {
    return StreamCursor(
      id: jsonSerialization['id'] as int?,
      streamId: jsonSerialization['streamId'] as String,
      lastSeq: jsonSerialization['lastSeq'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String streamId;

  int lastSeq;

  DateTime updatedAt;

  /// Returns a shallow copy of this [StreamCursor]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StreamCursor copyWith({
    int? id,
    String? streamId,
    int? lastSeq,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StreamCursor',
      if (id != null) 'id': id,
      'streamId': streamId,
      'lastSeq': lastSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StreamCursor',
      if (id != null) 'id': id,
      'streamId': streamId,
      'lastSeq': lastSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StreamCursorImpl extends StreamCursor {
  _StreamCursorImpl({
    int? id,
    required String streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         streamId: streamId,
         lastSeq: lastSeq,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [StreamCursor]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StreamCursor copyWith({
    Object? id = _Undefined,
    String? streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) {
    return StreamCursor(
      id: id is int? ? id : this.id,
      streamId: streamId ?? this.streamId,
      lastSeq: lastSeq ?? this.lastSeq,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
