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

abstract class IncidentAlreadyTaken
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  IncidentAlreadyTaken._({
    required this.incidentId,
    this.takenByName,
  });

  factory IncidentAlreadyTaken({
    required int incidentId,
    String? takenByName,
  }) = _IncidentAlreadyTakenImpl;

  factory IncidentAlreadyTaken.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IncidentAlreadyTaken(
      incidentId: jsonSerialization['incidentId'] as int,
      takenByName: jsonSerialization['takenByName'] as String?,
    );
  }

  int incidentId;

  String? takenByName;

  /// Returns a shallow copy of this [IncidentAlreadyTaken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IncidentAlreadyTaken copyWith({
    int? incidentId,
    String? takenByName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentAlreadyTaken',
      'incidentId': incidentId,
      if (takenByName != null) 'takenByName': takenByName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentAlreadyTaken',
      'incidentId': incidentId,
      if (takenByName != null) 'takenByName': takenByName,
    };
  }

  @override
  String toString() {
    return 'IncidentAlreadyTaken(incidentId: $incidentId, takenByName: $takenByName)';
  }
}

class _Undefined {}

class _IncidentAlreadyTakenImpl extends IncidentAlreadyTaken {
  _IncidentAlreadyTakenImpl({
    required int incidentId,
    String? takenByName,
  }) : super._(
         incidentId: incidentId,
         takenByName: takenByName,
       );

  /// Returns a shallow copy of this [IncidentAlreadyTaken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IncidentAlreadyTaken copyWith({
    int? incidentId,
    Object? takenByName = _Undefined,
  }) {
    return IncidentAlreadyTaken(
      incidentId: incidentId ?? this.incidentId,
      takenByName: takenByName is String? ? takenByName : this.takenByName,
    );
  }
}
