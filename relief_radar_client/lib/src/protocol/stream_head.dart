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

abstract class StreamHead
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StreamHead._({
    this.id,
    required this.streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) : headSeq = headSeq ?? 0,
       updatedAt = updatedAt ?? DateTime.now();

  factory StreamHead({
    int? id,
    required String streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) = _StreamHeadImpl;

  factory StreamHead.fromJson(Map<String, dynamic> jsonSerialization) {
    return StreamHead(
      id: jsonSerialization['id'] as int?,
      streamId: jsonSerialization['streamId'] as String,
      headSeq: jsonSerialization['headSeq'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String streamId;

  int headSeq;

  DateTime updatedAt;

  /// Returns a shallow copy of this [StreamHead]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StreamHead copyWith({
    int? id,
    String? streamId,
    int? headSeq,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StreamHead',
      if (id != null) 'id': id,
      'streamId': streamId,
      'headSeq': headSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StreamHead',
      if (id != null) 'id': id,
      'streamId': streamId,
      'headSeq': headSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StreamHeadImpl extends StreamHead {
  _StreamHeadImpl({
    int? id,
    required String streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         streamId: streamId,
         headSeq: headSeq,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [StreamHead]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StreamHead copyWith({
    Object? id = _Undefined,
    String? streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) {
    return StreamHead(
      id: id is int? ? id : this.id,
      streamId: streamId ?? this.streamId,
      headSeq: headSeq ?? this.headSeq,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
