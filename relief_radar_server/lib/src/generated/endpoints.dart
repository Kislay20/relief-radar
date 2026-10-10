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
import 'package:relief_radar_server/src/generated/disaster_zone.dart'
    as _iubkoprr;
import 'package:relief_radar_server/src/generated/incident.dart' as _ifuhjs9w;
import 'package:relief_radar_server/src/generated/incident_status.dart'
    as _iwnns7a6;
import 'package:relief_radar_server/src/generated/need_type.dart' as _it59fqrs;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'package:serverpod_serialization/src/postgis/geography_point.dart'
    as _id44xbuc;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/ai_triage_endpoint.dart' as _iok4dn0a;
import '../endpoints/disaster_zone_endpoint.dart' as _isf9np3t;
import '../endpoints/incident_endpoint.dart' as _idvfe0v9;
import '../endpoints/ops_endpoint.dart' as _ihx01pkv;
import '../endpoints/responder_endpoint.dart' as _ixab9ci6;
import '../endpoints/sitrep_endpoint.dart' as _inxa2fnq;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'aiTriage': _iok4dn0a.AiTriageEndpoint()
        ..initialize(
          server,
          'aiTriage',
          null,
        ),
      'disasterZone': _isf9np3t.DisasterZoneEndpoint()
        ..initialize(
          server,
          'disasterZone',
          null,
        ),
      'incident': _idvfe0v9.IncidentEndpoint()
        ..initialize(
          server,
          'incident',
          null,
        ),
      'ops': _ihx01pkv.OpsEndpoint()
        ..initialize(
          server,
          'ops',
          null,
        ),
      'responder': _ixab9ci6.ResponderEndpoint()
        ..initialize(
          server,
          'responder',
          null,
        ),
      'sitrep': _inxa2fnq.SitrepEndpoint()
        ..initialize(
          server,
          'sitrep',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['aiTriage'] = _is.EndpointConnector(
      name: 'aiTriage',
      endpoint: endpoints['aiTriage']!,
      methodConnectors: {
        'triageSosText': _is.MethodConnector(
          name: 'triageSosText',
          params: {
            'rawDescription': _is.ParameterDescription(
              name: 'rawDescription',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aiTriage'] as _iok4dn0a.AiTriageEndpoint)
                  .triageSosText(
                    session,
                    params['rawDescription'],
                  ),
        ),
        'triageIncident': _is.MethodConnector(
          name: 'triageIncident',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'customSosDescription': _is.ParameterDescription(
              name: 'customSosDescription',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aiTriage'] as _iok4dn0a.AiTriageEndpoint)
                  .triageIncident(
                    session,
                    params['incidentId'],
                    customSosDescription: params['customSosDescription'],
                  ),
        ),
        'ingestAndTriageSos': _is.MethodConnector(
          name: 'ingestAndTriageSos',
          params: {
            'zoneId': _is.ParameterDescription(
              name: 'zoneId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'needType': _is.ParameterDescription(
              name: 'needType',
              type: _is.getType<_it59fqrs.NeedType>(),
              nullable: false,
            ),
            'rawSosDescription': _is.ParameterDescription(
              name: 'rawSosDescription',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'latitude': _is.ParameterDescription(
              name: 'latitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'longitude': _is.ParameterDescription(
              name: 'longitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'headcount': _is.ParameterDescription(
              name: 'headcount',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'vulnerabilities': _is.ParameterDescription(
              name: 'vulnerabilities',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aiTriage'] as _iok4dn0a.AiTriageEndpoint)
                  .ingestAndTriageSos(
                    session,
                    zoneId: params['zoneId'],
                    needType: params['needType'],
                    rawSosDescription: params['rawSosDescription'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                    headcount: params['headcount'],
                    vulnerabilities: params['vulnerabilities'],
                  ),
        ),
      },
    );
    connectors['disasterZone'] = _is.EndpointConnector(
      name: 'disasterZone',
      endpoint: endpoints['disasterZone']!,
      methodConnectors: {
        'createZone': _is.MethodConnector(
          name: 'createZone',
          params: {
            'zone': _is.ParameterDescription(
              name: 'zone',
              type: _is.getType<_iubkoprr.DisasterZone>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['disasterZone'] as _isf9np3t.DisasterZoneEndpoint)
                      .createZone(
                        session,
                        params['zone'],
                      ),
        ),
        'getZoneById': _is.MethodConnector(
          name: 'getZoneById',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['disasterZone'] as _isf9np3t.DisasterZoneEndpoint)
                      .getZoneById(
                        session,
                        params['id'],
                      ),
        ),
        'getAllActiveZones': _is.MethodConnector(
          name: 'getAllActiveZones',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['disasterZone'] as _isf9np3t.DisasterZoneEndpoint)
                      .getAllActiveZones(session),
        ),
      },
    );
    connectors['incident'] = _is.EndpointConnector(
      name: 'incident',
      endpoint: endpoints['incident']!,
      methodConnectors: {
        'reportIncident': _is.MethodConnector(
          name: 'reportIncident',
          params: {
            'incident': _is.ParameterDescription(
              name: 'incident',
              type: _is.getType<_ifuhjs9w.Incident>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .reportIncident(
                    session,
                    params['incident'],
                  ),
        ),
        'getIncidentById': _is.MethodConnector(
          name: 'getIncidentById',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .getIncidentById(
                    session,
                    params['id'],
                  ),
        ),
        'getIncidentsByZone': _is.MethodConnector(
          name: 'getIncidentsByZone',
          params: {
            'zoneId': _is.ParameterDescription(
              name: 'zoneId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .getIncidentsByZone(
                    session,
                    params['zoneId'],
                  ),
        ),
        'updateIncidentStatus': _is.MethodConnector(
          name: 'updateIncidentStatus',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_iwnns7a6.IncidentStatus>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .updateIncidentStatus(
                    session,
                    params['incidentId'],
                    params['status'],
                  ),
        ),
        'getAllRecentIncidents': _is.MethodConnector(
          name: 'getAllRecentIncidents',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .getAllRecentIncidents(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'attachEvidence': _is.MethodConnector(
          name: 'attachEvidence',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'evidenceUrl': _is.ParameterDescription(
              name: 'evidenceUrl',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .attachEvidence(
                    session,
                    params['incidentId'],
                    params['evidenceUrl'],
                  ),
        ),
        'getUploadDescription': _is.MethodConnector(
          name: 'getUploadDescription',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .getUploadDescription(
                    session,
                    params['path'],
                  ),
        ),
        'verifyUpload': _is.MethodConnector(
          name: 'verifyUpload',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .verifyUpload(
                    session,
                    params['path'],
                  ),
        ),
        'watchIncidents': _is.MethodStreamConnector(
          name: 'watchIncidents',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .watchIncidents(session),
        ),
      },
    );
    connectors['ops'] = _is.EndpointConnector(
      name: 'ops',
      endpoint: endpoints['ops']!,
      methodConnectors: {
        'smokeTest': _is.MethodConnector(
          name: 'smokeTest',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ops'] as _ihx01pkv.OpsEndpoint).smokeTest(
                session,
              ),
        ),
        'seedMockData': _is.MethodConnector(
          name: 'seedMockData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ops'] as _ihx01pkv.OpsEndpoint)
                  .seedMockData(session),
        ),
        'watchIncidents': _is.MethodStreamConnector(
          name: 'watchIncidents',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['ops'] as _ihx01pkv.OpsEndpoint).watchIncidents(
                session,
              ),
        ),
      },
    );
    connectors['responder'] = _is.EndpointConnector(
      name: 'responder',
      endpoint: endpoints['responder']!,
      methodConnectors: {
        'updateLocation': _is.MethodConnector(
          name: 'updateLocation',
          params: {
            'responderId': _is.ParameterDescription(
              name: 'responderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'location': _is.ParameterDescription(
              name: 'location',
              type: _is.getType<_id44xbuc.GeographyPoint>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .updateLocation(
                    session,
                    params['responderId'],
                    params['location'],
                  ),
        ),
        'getResponderProfile': _is.MethodConnector(
          name: 'getResponderProfile',
          params: {
            'responderId': _is.ParameterDescription(
              name: 'responderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .getResponderProfile(
                    session,
                    params['responderId'],
                  ),
        ),
        'trackLocation': _is.MethodConnector(
          name: 'trackLocation',
          params: {
            'responderId': _is.ParameterDescription(
              name: 'responderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'latitude': _is.ParameterDescription(
              name: 'latitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'longitude': _is.ParameterDescription(
              name: 'longitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .trackLocation(
                    session,
                    params['responderId'],
                    params['latitude'],
                    params['longitude'],
                    params['status'],
                  ),
        ),
        'getLocationHistory': _is.MethodConnector(
          name: 'getLocationHistory',
          params: {
            'responderId': _is.ParameterDescription(
              name: 'responderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .getLocationHistory(
                    session,
                    params['responderId'],
                    limit: params['limit'],
                  ),
        ),
        'watchResponderLocations': _is.MethodStreamConnector(
          name: 'watchResponderLocations',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .watchResponderLocations(session),
        ),
      },
    );
    connectors['sitrep'] = _is.EndpointConnector(
      name: 'sitrep',
      endpoint: endpoints['sitrep']!,
      methodConnectors: {
        'generateSituationReport': _is.MethodConnector(
          name: 'generateSituationReport',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sitrep'] as _inxa2fnq.SitrepEndpoint)
                  .generateSituationReport(session),
        ),
        'exportSituationReportPdf': _is.MethodConnector(
          name: 'exportSituationReportPdf',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sitrep'] as _inxa2fnq.SitrepEndpoint)
                  .exportSituationReportPdf(session),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i1n3uhu0.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
