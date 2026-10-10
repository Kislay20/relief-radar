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
import 'event.dart' as _iu57571s;
import 'incident_snapshot.dart' as _idmorftz;
import 'report.dart' as _i2t8i3ij;

abstract class IncidentDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IncidentDetail._({
    required this.incident,
    required this.reports,
    required this.timeline,
  });

  factory IncidentDetail({
    required _idmorftz.IncidentSnapshot incident,
    required List<_i2t8i3ij.Report> reports,
    required List<_iu57571s.Event> timeline,
  }) = _IncidentDetailImpl;

  factory IncidentDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentDetail(
      incident: _i78gox42.Protocol().deserialize<_idmorftz.IncidentSnapshot>(
        jsonSerialization['incident'],
      ),
      reports: _i78gox42.Protocol().deserialize<List<_i2t8i3ij.Report>>(
        jsonSerialization['reports'],
      ),
      timeline: _i78gox42.Protocol().deserialize<List<_iu57571s.Event>>(
        jsonSerialization['timeline'],
      ),
    );
  }

  _idmorftz.IncidentSnapshot incident;

  List<_i2t8i3ij.Report> reports;

  List<_iu57571s.Event> timeline;

  /// Returns a shallow copy of this [IncidentDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IncidentDetail copyWith({
    _idmorftz.IncidentSnapshot? incident,
    List<_i2t8i3ij.Report>? reports,
    List<_iu57571s.Event>? timeline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentDetail',
      'incident': incident.toJson(),
      'reports': reports.toJson(valueToJson: (v) => v.toJson()),
      'timeline': timeline.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentDetail',
      'incident': incident.toJsonForProtocol(),
      'reports': reports.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'timeline': timeline.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _IncidentDetailImpl extends IncidentDetail {
  _IncidentDetailImpl({
    required _idmorftz.IncidentSnapshot incident,
    required List<_i2t8i3ij.Report> reports,
    required List<_iu57571s.Event> timeline,
  }) : super._(
         incident: incident,
         reports: reports,
         timeline: timeline,
       );

  /// Returns a shallow copy of this [IncidentDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IncidentDetail copyWith({
    _idmorftz.IncidentSnapshot? incident,
    List<_i2t8i3ij.Report>? reports,
    List<_iu57571s.Event>? timeline,
  }) {
    return IncidentDetail(
      incident: incident ?? this.incident.copyWith(),
      reports: reports ?? this.reports.map((e0) => e0.copyWith()).toList(),
      timeline: timeline ?? this.timeline.map((e0) => e0.copyWith()).toList(),
    );
  }
}
