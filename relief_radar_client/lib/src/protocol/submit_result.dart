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

abstract class SubmitResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SubmitResult._({
    required this.reportId,
    required this.alreadyReceived,
    required this.streamId,
    required this.headSeq,
  });

  factory SubmitResult({
    required int reportId,
    required bool alreadyReceived,
    required String streamId,
    required int headSeq,
  }) = _SubmitResultImpl;

  factory SubmitResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubmitResult(
      reportId: jsonSerialization['reportId'] as int,
      alreadyReceived: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['alreadyReceived'],
      ),
      streamId: jsonSerialization['streamId'] as String,
      headSeq: jsonSerialization['headSeq'] as int,
    );
  }

  int reportId;

  bool alreadyReceived;

  String streamId;

  int headSeq;

  /// Returns a shallow copy of this [SubmitResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SubmitResult copyWith({
    int? reportId,
    bool? alreadyReceived,
    String? streamId,
    int? headSeq,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubmitResult',
      'reportId': reportId,
      'alreadyReceived': alreadyReceived,
      'streamId': streamId,
      'headSeq': headSeq,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubmitResult',
      'reportId': reportId,
      'alreadyReceived': alreadyReceived,
      'streamId': streamId,
      'headSeq': headSeq,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SubmitResultImpl extends SubmitResult {
  _SubmitResultImpl({
    required int reportId,
    required bool alreadyReceived,
    required String streamId,
    required int headSeq,
  }) : super._(
         reportId: reportId,
         alreadyReceived: alreadyReceived,
         streamId: streamId,
         headSeq: headSeq,
       );

  /// Returns a shallow copy of this [SubmitResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SubmitResult copyWith({
    int? reportId,
    bool? alreadyReceived,
    String? streamId,
    int? headSeq,
  }) {
    return SubmitResult(
      reportId: reportId ?? this.reportId,
      alreadyReceived: alreadyReceived ?? this.alreadyReceived,
      streamId: streamId ?? this.streamId,
      headSeq: headSeq ?? this.headSeq,
    );
  }
}
