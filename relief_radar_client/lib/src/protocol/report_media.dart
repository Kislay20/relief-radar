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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ReportMedia
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReportMedia._({
    this.id,
    required this.reportId,
    required this.mime,
    required this.bytes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReportMedia({
    int? id,
    required int reportId,
    required String mime,
    required _idt.ByteData bytes,
    DateTime? createdAt,
  }) = _ReportMediaImpl;

  factory ReportMedia.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportMedia(
      id: jsonSerialization['id'] as int?,
      reportId: jsonSerialization['reportId'] as int,
      mime: jsonSerialization['mime'] as String,
      bytes: _isc.ByteDataJsonExtension.fromJson(jsonSerialization['bytes']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reportId;

  String mime;

  _idt.ByteData bytes;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReportMedia]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReportMedia copyWith({
    int? id,
    int? reportId,
    String? mime,
    _idt.ByteData? bytes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportMedia',
      if (id != null) 'id': id,
      'reportId': reportId,
      'mime': mime,
      'bytes': bytes.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportMedia',
      if (id != null) 'id': id,
      'reportId': reportId,
      'mime': mime,
      'bytes': bytes.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportMediaImpl extends ReportMedia {
  _ReportMediaImpl({
    int? id,
    required int reportId,
    required String mime,
    required _idt.ByteData bytes,
    DateTime? createdAt,
  }) : super._(
         id: id,
         reportId: reportId,
         mime: mime,
         bytes: bytes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReportMedia]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReportMedia copyWith({
    Object? id = _Undefined,
    int? reportId,
    String? mime,
    _idt.ByteData? bytes,
    DateTime? createdAt,
  }) {
    return ReportMedia(
      id: id is int? ? id : this.id,
      reportId: reportId ?? this.reportId,
      mime: mime ?? this.mime,
      bytes: bytes ?? this.bytes.clone(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
