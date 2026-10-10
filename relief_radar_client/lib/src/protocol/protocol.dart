/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:relief_radar_client/src/protocol/disaster_zone.dart'
    as _iqoonkxe;
import 'package:relief_radar_client/src/protocol/incident.dart' as _i52h402v;
import 'package:relief_radar_client/src/protocol/responder_location.dart'
    as _i0soladl;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'ai_triage_result.dart' as _iys79d39;
import 'assignment.dart' as _iavo6snm;
import 'assignment_status.dart' as _ikrvejjw;
import 'disaster_zone.dart' as _is4cyc51;
import 'event.dart' as _iu57571s;
import 'event_payload.dart' as _iusxws0y;
import 'event_type.dart' as _in8qly3f;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'incident.dart' as _iy4wsyyx;
import 'incident_already_taken.dart' as _iibegzts;
import 'incident_cache.dart' as _isypedb4;
import 'incident_detail.dart' as _i99u8ngz;
import 'incident_snapshot.dart' as _idmorftz;
import 'incident_status.dart' as _ikduxsi0;
import 'map_snapshot.dart' as _ikbg3v1p;
import 'need_type.dart' as _iq4zvdzd;
import 'outbox_report.dart' as _ixb0sh9r;
import 'report.dart' as _i2t8i3ij;
import 'report_media.dart' as _inyinypz;
import 'report_status.dart' as _i8pcsu0p;
import 'report_submission.dart' as _ixr1yrfz;
import 'responder.dart' as _ibsyf1oo;
import 'responder_location.dart' as _iafkizln;
import 'responder_status.dart' as _ivpp8a10;
import 'situation_report.dart' as _iacsos1a;
import 'stream_cursor.dart' as _icbz7gkl;
import 'stream_head.dart' as _icttdsos;
import 'structured_report.dart' as _imc53az5;
import 'submit_result.dart' as _ia4ha4gb;
export 'ai_triage_result.dart';
export 'assignment.dart';
export 'assignment_status.dart';
export 'disaster_zone.dart';
export 'event.dart';
export 'event_payload.dart';
export 'event_type.dart';
export 'greetings/greeting.dart';
export 'incident.dart';
export 'incident_already_taken.dart';
export 'incident_cache.dart';
export 'incident_detail.dart';
export 'incident_snapshot.dart';
export 'incident_status.dart';
export 'map_snapshot.dart';
export 'need_type.dart';
export 'outbox_report.dart';
export 'report.dart';
export 'report_media.dart';
export 'report_status.dart';
export 'report_submission.dart';
export 'responder.dart';
export 'responder_location.dart';
export 'responder_status.dart';
export 'situation_report.dart';
export 'stream_cursor.dart';
export 'stream_head.dart';
export 'structured_report.dart';
export 'submit_result.dart';
export 'client.dart';

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'incident_cache',
      dartName: 'IncidentCache',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'incidentId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'zoneId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'snapshot',
          columnType: _isd.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:IncidentSnapshot',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'incident_cache__incidentId__unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'outbox_report',
      dartName: 'OutboxReport',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'clientReportId',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isd.ColumnDefinition(
          name: 'zoneId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'rawText',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'lat',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isd.ColumnDefinition(
          name: 'lng',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isd.ColumnDefinition(
          name: 'accuracyM',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isd.ColumnDefinition(
          name: 'imagePath',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'clientCreatedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isd.ColumnDefinition(
          name: 'state',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'attempts',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isd.ColumnDefinition(
          name: 'lastError',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'outbox_report__clientReportId__unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'clientReportId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'stream_cursor',
      dartName: 'StreamCursor',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'streamId',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'lastSeq',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isd.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'stream_cursor__streamId__unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'streamId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iaic.Protocol() is _isd.DatabaseSerializationManager
        ? (_iaic.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._i312scxx.Protocol() is _isd.DatabaseSerializationManager
        ? (_i312scxx.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iacc.Protocol() is _isd.DatabaseSerializationManager
        ? (_iacc.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iys79d39.AiTriageResult) {
      return _iys79d39.AiTriageResult.fromJson(data) as T;
    }
    if (t == _iavo6snm.Assignment) {
      return _iavo6snm.Assignment.fromJson(data) as T;
    }
    if (t == _ikrvejjw.AssignmentStatus) {
      return _ikrvejjw.AssignmentStatus.fromJson(data) as T;
    }
    if (t == _is4cyc51.DisasterZone) {
      return _is4cyc51.DisasterZone.fromJson(data) as T;
    }
    if (t == _iu57571s.Event) {
      return _iu57571s.Event.fromJson(data) as T;
    }
    if (t == _iusxws0y.EventPayload) {
      return _iusxws0y.EventPayload.fromJson(data) as T;
    }
    if (t == _in8qly3f.EventType) {
      return _in8qly3f.EventType.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _iy4wsyyx.Incident) {
      return _iy4wsyyx.Incident.fromJson(data) as T;
    }
    if (t == _iibegzts.IncidentAlreadyTaken) {
      return _iibegzts.IncidentAlreadyTaken.fromJson(data) as T;
    }
    if (t == _isypedb4.IncidentCache) {
      return _isypedb4.IncidentCache.fromJson(data) as T;
    }
    if (t == _i99u8ngz.IncidentDetail) {
      return _i99u8ngz.IncidentDetail.fromJson(data) as T;
    }
    if (t == _idmorftz.IncidentSnapshot) {
      return _idmorftz.IncidentSnapshot.fromJson(data) as T;
    }
    if (t == _ikduxsi0.IncidentStatus) {
      return _ikduxsi0.IncidentStatus.fromJson(data) as T;
    }
    if (t == _ikbg3v1p.MapSnapshot) {
      return _ikbg3v1p.MapSnapshot.fromJson(data) as T;
    }
    if (t == _iq4zvdzd.NeedType) {
      return _iq4zvdzd.NeedType.fromJson(data) as T;
    }
    if (t == _ixb0sh9r.OutboxReport) {
      return _ixb0sh9r.OutboxReport.fromJson(data) as T;
    }
    if (t == _i2t8i3ij.Report) {
      return _i2t8i3ij.Report.fromJson(data) as T;
    }
    if (t == _inyinypz.ReportMedia) {
      return _inyinypz.ReportMedia.fromJson(data) as T;
    }
    if (t == _i8pcsu0p.ReportStatus) {
      return _i8pcsu0p.ReportStatus.fromJson(data) as T;
    }
    if (t == _ixr1yrfz.ReportSubmission) {
      return _ixr1yrfz.ReportSubmission.fromJson(data) as T;
    }
    if (t == _ibsyf1oo.Responder) {
      return _ibsyf1oo.Responder.fromJson(data) as T;
    }
    if (t == _iafkizln.ResponderLocation) {
      return _iafkizln.ResponderLocation.fromJson(data) as T;
    }
    if (t == _ivpp8a10.ResponderStatus) {
      return _ivpp8a10.ResponderStatus.fromJson(data) as T;
    }
    if (t == _iacsos1a.SituationReport) {
      return _iacsos1a.SituationReport.fromJson(data) as T;
    }
    if (t == _icbz7gkl.StreamCursor) {
      return _icbz7gkl.StreamCursor.fromJson(data) as T;
    }
    if (t == _icttdsos.StreamHead) {
      return _icttdsos.StreamHead.fromJson(data) as T;
    }
    if (t == _imc53az5.StructuredReport) {
      return _imc53az5.StructuredReport.fromJson(data) as T;
    }
    if (t == _ia4ha4gb.SubmitResult) {
      return _ia4ha4gb.SubmitResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_iys79d39.AiTriageResult?>()) {
      return (data != null ? _iys79d39.AiTriageResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iavo6snm.Assignment?>()) {
      return (data != null ? _iavo6snm.Assignment.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikrvejjw.AssignmentStatus?>()) {
      return (data != null ? _ikrvejjw.AssignmentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_is4cyc51.DisasterZone?>()) {
      return (data != null ? _is4cyc51.DisasterZone.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu57571s.Event?>()) {
      return (data != null ? _iu57571s.Event.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iusxws0y.EventPayload?>()) {
      return (data != null ? _iusxws0y.EventPayload.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in8qly3f.EventType?>()) {
      return (data != null ? _in8qly3f.EventType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iy4wsyyx.Incident?>()) {
      return (data != null ? _iy4wsyyx.Incident.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iibegzts.IncidentAlreadyTaken?>()) {
      return (data != null
              ? _iibegzts.IncidentAlreadyTaken.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_isypedb4.IncidentCache?>()) {
      return (data != null ? _isypedb4.IncidentCache.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i99u8ngz.IncidentDetail?>()) {
      return (data != null ? _i99u8ngz.IncidentDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idmorftz.IncidentSnapshot?>()) {
      return (data != null ? _idmorftz.IncidentSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikduxsi0.IncidentStatus?>()) {
      return (data != null ? _ikduxsi0.IncidentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikbg3v1p.MapSnapshot?>()) {
      return (data != null ? _ikbg3v1p.MapSnapshot.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iq4zvdzd.NeedType?>()) {
      return (data != null ? _iq4zvdzd.NeedType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixb0sh9r.OutboxReport?>()) {
      return (data != null ? _ixb0sh9r.OutboxReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2t8i3ij.Report?>()) {
      return (data != null ? _i2t8i3ij.Report.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_inyinypz.ReportMedia?>()) {
      return (data != null ? _inyinypz.ReportMedia.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8pcsu0p.ReportStatus?>()) {
      return (data != null ? _i8pcsu0p.ReportStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixr1yrfz.ReportSubmission?>()) {
      return (data != null ? _ixr1yrfz.ReportSubmission.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibsyf1oo.Responder?>()) {
      return (data != null ? _ibsyf1oo.Responder.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iafkizln.ResponderLocation?>()) {
      return (data != null ? _iafkizln.ResponderLocation.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivpp8a10.ResponderStatus?>()) {
      return (data != null ? _ivpp8a10.ResponderStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iacsos1a.SituationReport?>()) {
      return (data != null ? _iacsos1a.SituationReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icbz7gkl.StreamCursor?>()) {
      return (data != null ? _icbz7gkl.StreamCursor.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icttdsos.StreamHead?>()) {
      return (data != null ? _icttdsos.StreamHead.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imc53az5.StructuredReport?>()) {
      return (data != null ? _imc53az5.StructuredReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia4ha4gb.SubmitResult?>()) {
      return (data != null ? _ia4ha4gb.SubmitResult.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i2t8i3ij.Report>) {
      return (data as List)
              .map((e) => deserialize<_i2t8i3ij.Report>(e))
              .toList()
          as T;
    }
    if (t == List<_iu57571s.Event>) {
      return (data as List).map((e) => deserialize<_iu57571s.Event>(e)).toList()
          as T;
    }
    if (t == List<_idmorftz.IncidentSnapshot>) {
      return (data as List)
              .map((e) => deserialize<_idmorftz.IncidentSnapshot>(e))
              .toList()
          as T;
    }
    if (t == List<_iq4zvdzd.NeedType>) {
      return (data as List)
              .map((e) => deserialize<_iq4zvdzd.NeedType>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iqoonkxe.DisasterZone>) {
      return (data as List)
              .map((e) => deserialize<_iqoonkxe.DisasterZone>(e))
              .toList()
          as T;
    }
    if (t == List<_i52h402v.Incident>) {
      return (data as List)
              .map((e) => deserialize<_i52h402v.Incident>(e))
              .toList()
          as T;
    }
    if (t == List<_i0soladl.ResponderLocation>) {
      return (data as List)
              .map((e) => deserialize<_i0soladl.ResponderLocation>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i312scxx.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iys79d39.AiTriageResult => 'AiTriageResult',
      _iavo6snm.Assignment => 'Assignment',
      _ikrvejjw.AssignmentStatus => 'AssignmentStatus',
      _is4cyc51.DisasterZone => 'DisasterZone',
      _iu57571s.Event => 'Event',
      _iusxws0y.EventPayload => 'EventPayload',
      _in8qly3f.EventType => 'EventType',
      _izw8z7ou.Greeting => 'Greeting',
      _iy4wsyyx.Incident => 'Incident',
      _iibegzts.IncidentAlreadyTaken => 'IncidentAlreadyTaken',
      _isypedb4.IncidentCache => 'IncidentCache',
      _i99u8ngz.IncidentDetail => 'IncidentDetail',
      _idmorftz.IncidentSnapshot => 'IncidentSnapshot',
      _ikduxsi0.IncidentStatus => 'IncidentStatus',
      _ikbg3v1p.MapSnapshot => 'MapSnapshot',
      _iq4zvdzd.NeedType => 'NeedType',
      _ixb0sh9r.OutboxReport => 'OutboxReport',
      _i2t8i3ij.Report => 'Report',
      _inyinypz.ReportMedia => 'ReportMedia',
      _i8pcsu0p.ReportStatus => 'ReportStatus',
      _ixr1yrfz.ReportSubmission => 'ReportSubmission',
      _ibsyf1oo.Responder => 'Responder',
      _iafkizln.ResponderLocation => 'ResponderLocation',
      _ivpp8a10.ResponderStatus => 'ResponderStatus',
      _iacsos1a.SituationReport => 'SituationReport',
      _icbz7gkl.StreamCursor => 'StreamCursor',
      _icttdsos.StreamHead => 'StreamHead',
      _imc53az5.StructuredReport => 'StructuredReport',
      _ia4ha4gb.SubmitResult => 'SubmitResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'relief_radar.',
        '',
      );
    }

    switch (data) {
      case _iys79d39.AiTriageResult():
        return 'AiTriageResult';
      case _iavo6snm.Assignment():
        return 'Assignment';
      case _ikrvejjw.AssignmentStatus():
        return 'AssignmentStatus';
      case _is4cyc51.DisasterZone():
        return 'DisasterZone';
      case _iu57571s.Event():
        return 'Event';
      case _iusxws0y.EventPayload():
        return 'EventPayload';
      case _in8qly3f.EventType():
        return 'EventType';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _iy4wsyyx.Incident():
        return 'Incident';
      case _iibegzts.IncidentAlreadyTaken():
        return 'IncidentAlreadyTaken';
      case _isypedb4.IncidentCache():
        return 'IncidentCache';
      case _i99u8ngz.IncidentDetail():
        return 'IncidentDetail';
      case _idmorftz.IncidentSnapshot():
        return 'IncidentSnapshot';
      case _ikduxsi0.IncidentStatus():
        return 'IncidentStatus';
      case _ikbg3v1p.MapSnapshot():
        return 'MapSnapshot';
      case _iq4zvdzd.NeedType():
        return 'NeedType';
      case _ixb0sh9r.OutboxReport():
        return 'OutboxReport';
      case _i2t8i3ij.Report():
        return 'Report';
      case _inyinypz.ReportMedia():
        return 'ReportMedia';
      case _i8pcsu0p.ReportStatus():
        return 'ReportStatus';
      case _ixr1yrfz.ReportSubmission():
        return 'ReportSubmission';
      case _ibsyf1oo.Responder():
        return 'Responder';
      case _iafkizln.ResponderLocation():
        return 'ResponderLocation';
      case _ivpp8a10.ResponderStatus():
        return 'ResponderStatus';
      case _iacsos1a.SituationReport():
        return 'SituationReport';
      case _icbz7gkl.StreamCursor():
        return 'StreamCursor';
      case _icttdsos.StreamHead():
        return 'StreamHead';
      case _imc53az5.StructuredReport():
        return 'StructuredReport';
      case _ia4ha4gb.SubmitResult():
        return 'SubmitResult';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _i312scxx.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AiTriageResult') {
      return deserialize<_iys79d39.AiTriageResult>(data['data']);
    }
    if (dataClassName == 'Assignment') {
      return deserialize<_iavo6snm.Assignment>(data['data']);
    }
    if (dataClassName == 'AssignmentStatus') {
      return deserialize<_ikrvejjw.AssignmentStatus>(data['data']);
    }
    if (dataClassName == 'DisasterZone') {
      return deserialize<_is4cyc51.DisasterZone>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_iu57571s.Event>(data['data']);
    }
    if (dataClassName == 'EventPayload') {
      return deserialize<_iusxws0y.EventPayload>(data['data']);
    }
    if (dataClassName == 'EventType') {
      return deserialize<_in8qly3f.EventType>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'Incident') {
      return deserialize<_iy4wsyyx.Incident>(data['data']);
    }
    if (dataClassName == 'IncidentAlreadyTaken') {
      return deserialize<_iibegzts.IncidentAlreadyTaken>(data['data']);
    }
    if (dataClassName == 'IncidentCache') {
      return deserialize<_isypedb4.IncidentCache>(data['data']);
    }
    if (dataClassName == 'IncidentDetail') {
      return deserialize<_i99u8ngz.IncidentDetail>(data['data']);
    }
    if (dataClassName == 'IncidentSnapshot') {
      return deserialize<_idmorftz.IncidentSnapshot>(data['data']);
    }
    if (dataClassName == 'IncidentStatus') {
      return deserialize<_ikduxsi0.IncidentStatus>(data['data']);
    }
    if (dataClassName == 'MapSnapshot') {
      return deserialize<_ikbg3v1p.MapSnapshot>(data['data']);
    }
    if (dataClassName == 'NeedType') {
      return deserialize<_iq4zvdzd.NeedType>(data['data']);
    }
    if (dataClassName == 'OutboxReport') {
      return deserialize<_ixb0sh9r.OutboxReport>(data['data']);
    }
    if (dataClassName == 'Report') {
      return deserialize<_i2t8i3ij.Report>(data['data']);
    }
    if (dataClassName == 'ReportMedia') {
      return deserialize<_inyinypz.ReportMedia>(data['data']);
    }
    if (dataClassName == 'ReportStatus') {
      return deserialize<_i8pcsu0p.ReportStatus>(data['data']);
    }
    if (dataClassName == 'ReportSubmission') {
      return deserialize<_ixr1yrfz.ReportSubmission>(data['data']);
    }
    if (dataClassName == 'Responder') {
      return deserialize<_ibsyf1oo.Responder>(data['data']);
    }
    if (dataClassName == 'ResponderLocation') {
      return deserialize<_iafkizln.ResponderLocation>(data['data']);
    }
    if (dataClassName == 'ResponderStatus') {
      return deserialize<_ivpp8a10.ResponderStatus>(data['data']);
    }
    if (dataClassName == 'SituationReport') {
      return deserialize<_iacsos1a.SituationReport>(data['data']);
    }
    if (dataClassName == 'StreamCursor') {
      return deserialize<_icbz7gkl.StreamCursor>(data['data']);
    }
    if (dataClassName == 'StreamHead') {
      return deserialize<_icttdsos.StreamHead>(data['data']);
    }
    if (dataClassName == 'StructuredReport') {
      return deserialize<_imc53az5.StructuredReport>(data['data']);
    }
    if (dataClassName == 'SubmitResult') {
      return deserialize<_ia4ha4gb.SubmitResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i312scxx.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('relief_radar', this);
    _i312scxx.Protocol().registerHostProtocol('relief_radar', this);
    _iacc.Protocol().registerHostProtocol('relief_radar', this);
  }

  @override
  _isd.Table? getTableForType(Type t) {
    {
      var protocol = _iaic.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _i312scxx.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iacc.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _isypedb4.IncidentCache:
        return _isypedb4.IncidentCache.t;
      case _ixb0sh9r.OutboxReport:
        return _ixb0sh9r.OutboxReport.t;
      case _icbz7gkl.StreamCursor:
        return _icbz7gkl.StreamCursor.t;
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'relief_radar';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i312scxx.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
