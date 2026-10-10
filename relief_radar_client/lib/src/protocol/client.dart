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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:relief_radar_client/src/protocol/ai_triage_result.dart'
    as _i9fq7be2;
import 'package:relief_radar_client/src/protocol/disaster_zone.dart'
    as _iqoonkxe;
import 'package:relief_radar_client/src/protocol/greetings/greeting.dart'
    as _iuxdj8jj;
import 'package:relief_radar_client/src/protocol/incident.dart' as _i52h402v;
import 'package:relief_radar_client/src/protocol/incident_status.dart'
    as _i0efso5g;
import 'package:relief_radar_client/src/protocol/need_type.dart' as _ib5u1uhx;
import 'package:relief_radar_client/src/protocol/responder.dart' as _ih4brjxf;
import 'package:relief_radar_client/src/protocol/responder_location.dart'
    as _i0soladl;
import 'package:relief_radar_client/src/protocol/situation_report.dart'
    as _iix0zx2o;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/src/postgis/geography_point.dart'
    as _id44xbuc;
import 'protocol.dart' as _il2as5qe;
import 'package:relief_radar_client/migrations/migration_registry.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Endpoint for AI-driven distress analysis, severity prioritization, and triage.
/// {@category Endpoint}
class EndpointAiTriage extends _isc.EndpointRef {
  EndpointAiTriage(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'aiTriage';

  /// Evaluates a raw SOS distress message and returns structured AI classification.
  _ida.Future<_i9fq7be2.AiTriageResult> triageSosText(String rawDescription) =>
      caller.callServerEndpoint<_i9fq7be2.AiTriageResult>(
        'aiTriage',
        'triageSosText',
        {'rawDescription': rawDescription},
      );

  /// Triages an existing incident by its [incidentId].
  /// Analyzes the incident's summary (or [customSosDescription]), updates the
  /// incident's AI severity, tags, and summary, persists the changes, and broadcasts
  /// the update via WebSocket to all connected clients.
  _ida.Future<_i52h402v.Incident?> triageIncident(
    int incidentId, {
    String? customSosDescription,
  }) => caller.callServerEndpoint<_i52h402v.Incident?>(
    'aiTriage',
    'triageIncident',
    {
      'incidentId': incidentId,
      'customSosDescription': customSosDescription,
    },
  );

  /// Ingests a new raw SOS distress report, performs instant AI triage,
  /// creates an Incident record, and broadcasts it live.
  _ida.Future<_i52h402v.Incident> ingestAndTriageSos({
    required int zoneId,
    required _ib5u1uhx.NeedType needType,
    required String rawSosDescription,
    required double latitude,
    required double longitude,
    int? headcount,
    List<String>? vulnerabilities,
  }) => caller.callServerEndpoint<_i52h402v.Incident>(
    'aiTriage',
    'ingestAndTriageSos',
    {
      'zoneId': zoneId,
      'needType': needType,
      'rawSosDescription': rawSosDescription,
      'latitude': latitude,
      'longitude': longitude,
      'headcount': headcount,
      'vulnerabilities': vulnerabilities,
    },
  );
}

/// {@category Endpoint}
class EndpointDisasterZone extends _isc.EndpointRef {
  EndpointDisasterZone(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'disasterZone';

  /// Creates a new disaster zone.
  _ida.Future<_iqoonkxe.DisasterZone> createZone(_iqoonkxe.DisasterZone zone) =>
      caller.callServerEndpoint<_iqoonkxe.DisasterZone>(
        'disasterZone',
        'createZone',
        {'zone': zone},
      );

  /// Retrieves a disaster zone by its [id].
  _ida.Future<_iqoonkxe.DisasterZone?> getZoneById(int id) =>
      caller.callServerEndpoint<_iqoonkxe.DisasterZone?>(
        'disasterZone',
        'getZoneById',
        {'id': id},
      );

  /// Retrieves all currently active disaster zones.
  _ida.Future<List<_iqoonkxe.DisasterZone>> getAllActiveZones() =>
      caller.callServerEndpoint<List<_iqoonkxe.DisasterZone>>(
        'disasterZone',
        'getAllActiveZones',
        {},
      );
}

/// {@category Endpoint}
class EndpointIncident extends _isc.EndpointRef {
  EndpointIncident(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'incident';

  /// Streams live incident updates (new incidents and status updates) in real time
  /// over WebSockets to all connected emergency clients.
  _ida.Stream<_i52h402v.Incident> watchIncidents() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i52h402v.Incident>,
        _i52h402v.Incident
      >(
        'incident',
        'watchIncidents',
        {},
        {},
      );

  /// Reports a new incident and broadcasts the telemetry live to all connected clients.
  _ida.Future<_i52h402v.Incident> reportIncident(_i52h402v.Incident incident) =>
      caller.callServerEndpoint<_i52h402v.Incident>(
        'incident',
        'reportIncident',
        {'incident': incident},
      );

  /// Retrieves an incident by its [id].
  _ida.Future<_i52h402v.Incident?> getIncidentById(int id) =>
      caller.callServerEndpoint<_i52h402v.Incident?>(
        'incident',
        'getIncidentById',
        {'id': id},
      );

  /// Retrieves all incidents occurring within a specific disaster zone.
  _ida.Future<List<_i52h402v.Incident>> getIncidentsByZone(int zoneId) =>
      caller.callServerEndpoint<List<_i52h402v.Incident>>(
        'incident',
        'getIncidentsByZone',
        {'zoneId': zoneId},
      );

  /// Updates the status of an existing incident and broadcasts the update live.
  _ida.Future<_i52h402v.Incident?> updateIncidentStatus(
    int incidentId,
    _i0efso5g.IncidentStatus status,
  ) => caller.callServerEndpoint<_i52h402v.Incident?>(
    'incident',
    'updateIncidentStatus',
    {
      'incidentId': incidentId,
      'status': status,
    },
  );

  /// Retrieves all recent incidents across all disaster zones.
  _ida.Future<List<_i52h402v.Incident>> getAllRecentIncidents({
    required int limit,
  }) => caller.callServerEndpoint<List<_i52h402v.Incident>>(
    'incident',
    'getAllRecentIncidents',
    {'limit': limit},
  );

  /// Attaches an evidence image URL to an incident, persists it, and broadcasts the updated incident.
  _ida.Future<_i52h402v.Incident?> attachEvidence(
    int incidentId,
    String evidenceUrl,
  ) => caller.callServerEndpoint<_i52h402v.Incident?>(
    'incident',
    'attachEvidence',
    {
      'incidentId': incidentId,
      'evidenceUrl': evidenceUrl,
    },
  );

  /// Creates a Serverpod cloud storage upload description for evidence files.
  _ida.Future<String?> getUploadDescription(String path) =>
      caller.callServerEndpoint<String?>(
        'incident',
        'getUploadDescription',
        {'path': path},
      );

  /// Verifies upload completion in cloud storage and returns the public download URL.
  _ida.Future<String?> verifyUpload(String path) =>
      caller.callServerEndpoint<String?>(
        'incident',
        'verifyUpload',
        {'path': path},
      );
}

/// {@category Endpoint}
class EndpointOps extends _isc.EndpointRef {
  EndpointOps(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ops';

  /// Streams real-time incident telemetry over WebSockets to connected tactical clients.
  _ida.Stream<_i52h402v.Incident> watchIncidents() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i52h402v.Incident>,
        _i52h402v.Incident
      >(
        'ops',
        'watchIncidents',
        {},
        {},
      );

  _ida.Future<bool> smokeTest() => caller.callServerEndpoint<bool>(
    'ops',
    'smokeTest',
    {},
  );

  /// Seeds realistic mock DisasterZone and Incident entities for testing.
  _ida.Future<bool> seedMockData() => caller.callServerEndpoint<bool>(
    'ops',
    'seedMockData',
    {},
  );
}

/// {@category Endpoint}
class EndpointResponder extends _isc.EndpointRef {
  EndpointResponder(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'responder';

  /// Updates the current geographical location of a responder and records the timestamp.
  _ida.Future<_ih4brjxf.Responder?> updateLocation(
    int responderId,
    _id44xbuc.GeographyPoint location,
  ) => caller.callServerEndpoint<_ih4brjxf.Responder?>(
    'responder',
    'updateLocation',
    {
      'responderId': responderId,
      'location': location,
    },
  );

  /// Retrieves the profile of a responder by their [responderId].
  _ida.Future<_ih4brjxf.Responder?> getResponderProfile(int responderId) =>
      caller.callServerEndpoint<_ih4brjxf.Responder?>(
        'responder',
        'getResponderProfile',
        {'responderId': responderId},
      );

  /// Streams live responder location telemetry over WebSockets in real time.
  _ida.Stream<_i0soladl.ResponderLocation> watchResponderLocations() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i0soladl.ResponderLocation>,
        _i0soladl.ResponderLocation
      >(
        'responder',
        'watchResponderLocations',
        {},
        {},
      );

  /// Records a responder location telemetry ping and broadcasts it via WebSocket message bus.
  _ida.Future<_i0soladl.ResponderLocation> trackLocation(
    int responderId,
    double latitude,
    double longitude,
    String status,
  ) => caller.callServerEndpoint<_i0soladl.ResponderLocation>(
    'responder',
    'trackLocation',
    {
      'responderId': responderId,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    },
  );

  /// Retrieves recent location history for a responder.
  _ida.Future<List<_i0soladl.ResponderLocation>> getLocationHistory(
    int responderId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i0soladl.ResponderLocation>>(
    'responder',
    'getLocationHistory',
    {
      'responderId': responderId,
      'limit': limit,
    },
  );
}

/// Endpoint for generating AI-powered Situation Reports (SitRep) and exporting tactical PDFs.
/// {@category Endpoint}
class EndpointSitrep extends _isc.EndpointRef {
  EndpointSitrep(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sitrep';

  /// Fetches all active OPEN and CRITICAL incidents and uses Gemini AI to generate a structured SitRep.
  _ida.Future<_iix0zx2o.SituationReport> generateSituationReport() =>
      caller.callServerEndpoint<_iix0zx2o.SituationReport>(
        'sitrep',
        'generateSituationReport',
        {},
      );

  /// Generates a structured Situation Report and exports it as a downloadable binary PDF document.
  _ida.Future<_idt.ByteData> exportSituationReportPdf() =>
      caller.callServerEndpoint<_idt.ByteData>(
        'sitrep',
        'exportSituationReportPdf',
        {},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_iuxdj8jj.Greeting> hello(String name) =>
      caller.callServerEndpoint<_iuxdj8jj.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    auth = _i312scxx.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _i312scxx.Caller auth;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    aiTriage = EndpointAiTriage(this);
    disasterZone = EndpointDisasterZone(this);
    incident = EndpointIncident(this);
    ops = EndpointOps(this);
    responder = EndpointResponder(this);
    sitrep = EndpointSitrep(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAiTriage aiTriage;

  late final EndpointDisasterZone disasterZone;

  late final EndpointIncident incident;

  late final EndpointOps ops;

  late final EndpointResponder responder;

  late final EndpointSitrep sitrep;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'aiTriage': aiTriage,
    'disasterZone': disasterZone,
    'incident': incident,
    'ops': ops,
    'responder': responder,
    'sitrep': sitrep,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'auth': modules.auth,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _ida.Future<_isd.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _isd.ClientDatabaseSession.open(
      path,
      _il2as5qe.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }
}
