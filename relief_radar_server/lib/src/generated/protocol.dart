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
import 'package:relief_radar_server/src/generated/disaster_zone.dart'
    as _iubkoprr;
import 'package:relief_radar_server/src/generated/incident.dart' as _ifuhjs9w;
import 'package:relief_radar_server/src/generated/responder_location.dart'
    as _id8xkuiq;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'assignment',
      dartName: 'Assignment',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'incidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'responderId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AssignmentStatus',
        ),
        _isp.ColumnDefinition(
          name: 'offeredAtLevel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'offeredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'respondedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'etaMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'assignment_fk_0',
          columns: ['incidentId'],
          referenceTable: 'incident',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'assignment_fk_1',
          columns: ['responderId'],
          referenceTable: 'responder',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'assignment_incident_responder_uq',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'responderId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'assignment_responder_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'responderId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'disaster_zone',
      dartName: 'DisasterZone',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'center',
          columnType: _isp.ColumnType.geography,
          isNullable: false,
          dartType: 'GeographyPoint',
        ),
        _isp.ColumnDefinition(
          name: 'bounds',
          columnType: _isp.ColumnType.geographyPolygon,
          isNullable: true,
          dartType: 'GeographyPolygon?',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'timeScale',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '1.0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'disaster_zone_center_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'center',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'event',
      dartName: 'Event',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'streamId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'seq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventType',
        ),
        _isp.ColumnDefinition(
          name: 'incidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'payload',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'protocol:EventPayload',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'event_stream_seq_uq',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'streamId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'seq',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'event_incident_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'event_payload_gin_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'payload',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _isp.GinOperatorClass.jsonbPathOps,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'incident',
      dartName: 'Incident',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'zoneId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'needType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:NeedType',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:IncidentStatus',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'headcount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'vulnerabilities',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'summary',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'aiSeverity',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'aiTags',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'aiSummary',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'centroid',
          columnType: _isp.ColumnType.geography,
          isNullable: false,
          dartType: 'GeographyPoint',
        ),
        _isp.ColumnDefinition(
          name: 'centroidEmbedding',
          columnType: _isp.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(768)?',
          vectorDimension: 768,
        ),
        _isp.ColumnDefinition(
          name: 'accuracyRadiusM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'reportCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'firstReportAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'lastReportAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'baseSlaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'escalationLevel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'dispatchRadiusM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'levelStartedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'nextEscalationAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'assignedResponderId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'mergedIntoId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'evidenceUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'incident_fk_0',
          columns: ['zoneId'],
          referenceTable: 'disaster_zone',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'incident_fk_1',
          columns: ['assignedResponderId'],
          referenceTable: 'responder',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'incident_centroid_gist_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'centroid',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'incident_embedding_hnsw_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'centroidEmbedding',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.cosine,
          vectorColumnType: _isp.ColumnType.vector,
          parameters: {
            'm': '16',
            'ef_construction': '64',
          },
        ),
        _isp.IndexDefinition(
          indexName: 'incident_zone_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'zoneId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'incident_next_escalation_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'nextEscalationAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'report',
      dartName: 'Report',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'zoneId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'clientReportId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'reporterKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'rawText',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'hasImage',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'clientLocation',
          columnType: _isp.ColumnType.geography,
          isNullable: true,
          dartType: 'GeographyPoint?',
        ),
        _isp.ColumnDefinition(
          name: 'locationAccuracyM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'clientCreatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ReportStatus',
        ),
        _isp.ColumnDefinition(
          name: 'failureReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'structured',
          columnType: _isp.ColumnType.jsonb,
          isNullable: true,
          dartType: 'protocol:StructuredReport?',
        ),
        _isp.ColumnDefinition(
          name: 'embedding',
          columnType: _isp.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(768)?',
          vectorDimension: 768,
        ),
        _isp.ColumnDefinition(
          name: 'incidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'report_fk_0',
          columns: ['zoneId'],
          referenceTable: 'disaster_zone',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'report_fk_1',
          columns: ['incidentId'],
          referenceTable: 'incident',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'report_client_id_uq',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientReportId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'report_zone_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'zoneId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'report_incident_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'report_location_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientLocation',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'report_structured_gin_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'structured',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _isp.GinOperatorClass.jsonbPathOps,
        ),
        _isp.IndexDefinition(
          indexName: 'report_embedding_hnsw_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'embedding',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.cosine,
          vectorColumnType: _isp.ColumnType.vector,
          parameters: {
            'm': '16',
            'ef_construction': '64',
          },
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'report_media',
      dartName: 'ReportMedia',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'reportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'mime',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'bytes',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'report_media_fk_0',
          columns: ['reportId'],
          referenceTable: 'report',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'report_media_report_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'reportId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'responder',
      dartName: 'Responder',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'capabilities',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:NeedType>',
        ),
        _isp.ColumnDefinition(
          name: 'capacity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ResponderStatus',
        ),
        _isp.ColumnDefinition(
          name: 'location',
          columnType: _isp.ColumnType.geography,
          isNullable: true,
          dartType: 'GeographyPoint?',
        ),
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'responder_auth_user_uq',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'responder_location_gist_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'location',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'responder_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'responder_location',
      dartName: 'ResponderLocation',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'responderId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'timestamp',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'responder_location_responder_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'responderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'responder_location_timestamp_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'stream_head',
      dartName: 'StreamHead',
      schema: 'public',
      module: 'relief_radar',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'streamId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'headSeq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'stream_head__streamId__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    ..._iais.Protocol.targetTableDefinitions,
    ..._i1n3uhu0.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _is.getType<_iys79d39.AiTriageResult?>()) {
      return (data != null ? _iys79d39.AiTriageResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iavo6snm.Assignment?>()) {
      return (data != null ? _iavo6snm.Assignment.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikrvejjw.AssignmentStatus?>()) {
      return (data != null ? _ikrvejjw.AssignmentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is4cyc51.DisasterZone?>()) {
      return (data != null ? _is4cyc51.DisasterZone.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu57571s.Event?>()) {
      return (data != null ? _iu57571s.Event.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iusxws0y.EventPayload?>()) {
      return (data != null ? _iusxws0y.EventPayload.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in8qly3f.EventType?>()) {
      return (data != null ? _in8qly3f.EventType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iy4wsyyx.Incident?>()) {
      return (data != null ? _iy4wsyyx.Incident.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iibegzts.IncidentAlreadyTaken?>()) {
      return (data != null
              ? _iibegzts.IncidentAlreadyTaken.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isypedb4.IncidentCache?>()) {
      return (data != null ? _isypedb4.IncidentCache.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i99u8ngz.IncidentDetail?>()) {
      return (data != null ? _i99u8ngz.IncidentDetail.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idmorftz.IncidentSnapshot?>()) {
      return (data != null ? _idmorftz.IncidentSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikduxsi0.IncidentStatus?>()) {
      return (data != null ? _ikduxsi0.IncidentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikbg3v1p.MapSnapshot?>()) {
      return (data != null ? _ikbg3v1p.MapSnapshot.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iq4zvdzd.NeedType?>()) {
      return (data != null ? _iq4zvdzd.NeedType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixb0sh9r.OutboxReport?>()) {
      return (data != null ? _ixb0sh9r.OutboxReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2t8i3ij.Report?>()) {
      return (data != null ? _i2t8i3ij.Report.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inyinypz.ReportMedia?>()) {
      return (data != null ? _inyinypz.ReportMedia.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8pcsu0p.ReportStatus?>()) {
      return (data != null ? _i8pcsu0p.ReportStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixr1yrfz.ReportSubmission?>()) {
      return (data != null ? _ixr1yrfz.ReportSubmission.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibsyf1oo.Responder?>()) {
      return (data != null ? _ibsyf1oo.Responder.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iafkizln.ResponderLocation?>()) {
      return (data != null ? _iafkizln.ResponderLocation.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivpp8a10.ResponderStatus?>()) {
      return (data != null ? _ivpp8a10.ResponderStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iacsos1a.SituationReport?>()) {
      return (data != null ? _iacsos1a.SituationReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icbz7gkl.StreamCursor?>()) {
      return (data != null ? _icbz7gkl.StreamCursor.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icttdsos.StreamHead?>()) {
      return (data != null ? _icttdsos.StreamHead.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imc53az5.StructuredReport?>()) {
      return (data != null ? _imc53az5.StructuredReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ia4ha4gb.SubmitResult?>()) {
      return (data != null ? _ia4ha4gb.SubmitResult.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
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
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iubkoprr.DisasterZone>) {
      return (data as List)
              .map((e) => deserialize<_iubkoprr.DisasterZone>(e))
              .toList()
          as T;
    }
    if (t == List<_ifuhjs9w.Incident>) {
      return (data as List)
              .map((e) => deserialize<_ifuhjs9w.Incident>(e))
              .toList()
          as T;
    }
    if (t == List<_id8xkuiq.ResponderLocation>) {
      return (data as List)
              .map((e) => deserialize<_id8xkuiq.ResponderLocation>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i1n3uhu0.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _i1n3uhu0.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i1n3uhu0.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('relief_radar', this);
    _i1n3uhu0.Protocol().registerHostProtocol('relief_radar', this);
    _iacs.Protocol().registerHostProtocol('relief_radar', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i1n3uhu0.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iavo6snm.Assignment:
        return _iavo6snm.Assignment.t;
      case _is4cyc51.DisasterZone:
        return _is4cyc51.DisasterZone.t;
      case _iu57571s.Event:
        return _iu57571s.Event.t;
      case _iy4wsyyx.Incident:
        return _iy4wsyyx.Incident.t;
      case _i2t8i3ij.Report:
        return _i2t8i3ij.Report.t;
      case _inyinypz.ReportMedia:
        return _inyinypz.ReportMedia.t;
      case _ibsyf1oo.Responder:
        return _ibsyf1oo.Responder.t;
      case _iafkizln.ResponderLocation:
        return _iafkizln.ResponderLocation.t;
      case _icttdsos.StreamHead:
        return _icttdsos.StreamHead.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i1n3uhu0.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
