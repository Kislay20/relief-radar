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

enum EventType implements _is.SerializableModel {
  reportReceived,
  reportStructured,
  incidentCreated,
  incidentUpdated,
  incidentMerged,
  slaEscalated,
  taskOffered,
  taskAccepted,
  taskProgress,
  incidentResolved,
  systemNote;

  static EventType fromJson(String name) {
    switch (name) {
      case 'reportReceived':
        return EventType.reportReceived;
      case 'reportStructured':
        return EventType.reportStructured;
      case 'incidentCreated':
        return EventType.incidentCreated;
      case 'incidentUpdated':
        return EventType.incidentUpdated;
      case 'incidentMerged':
        return EventType.incidentMerged;
      case 'slaEscalated':
        return EventType.slaEscalated;
      case 'taskOffered':
        return EventType.taskOffered;
      case 'taskAccepted':
        return EventType.taskAccepted;
      case 'taskProgress':
        return EventType.taskProgress;
      case 'incidentResolved':
        return EventType.incidentResolved;
      case 'systemNote':
        return EventType.systemNote;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "EventType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
