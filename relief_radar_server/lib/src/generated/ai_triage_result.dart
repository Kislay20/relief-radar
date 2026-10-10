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

abstract class AiTriageResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AiTriageResult._({
    required this.severity,
    required this.summary,
    required this.tags,
    required this.rawDescription,
  });

  factory AiTriageResult({
    required String severity,
    required String summary,
    required List<String> tags,
    required String rawDescription,
  }) = _AiTriageResultImpl;

  factory AiTriageResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiTriageResult(
      severity: jsonSerialization['severity'] as String,
      summary: jsonSerialization['summary'] as String,
      tags: _i78gox42.Protocol().deserialize<List<String>>(
        jsonSerialization['tags'],
      ),
      rawDescription: jsonSerialization['rawDescription'] as String,
    );
  }

  String severity;

  String summary;

  List<String> tags;

  String rawDescription;

  /// Returns a shallow copy of this [AiTriageResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiTriageResult copyWith({
    String? severity,
    String? summary,
    List<String>? tags,
    String? rawDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiTriageResult',
      'severity': severity,
      'summary': summary,
      'tags': tags.toJson(),
      'rawDescription': rawDescription,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiTriageResult',
      'severity': severity,
      'summary': summary,
      'tags': tags.toJson(),
      'rawDescription': rawDescription,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AiTriageResultImpl extends AiTriageResult {
  _AiTriageResultImpl({
    required String severity,
    required String summary,
    required List<String> tags,
    required String rawDescription,
  }) : super._(
         severity: severity,
         summary: summary,
         tags: tags,
         rawDescription: rawDescription,
       );

  /// Returns a shallow copy of this [AiTriageResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiTriageResult copyWith({
    String? severity,
    String? summary,
    List<String>? tags,
    String? rawDescription,
  }) {
    return AiTriageResult(
      severity: severity ?? this.severity,
      summary: summary ?? this.summary,
      tags: tags ?? this.tags.map((e0) => e0).toList(),
      rawDescription: rawDescription ?? this.rawDescription,
    );
  }
}
