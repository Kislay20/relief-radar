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
import 'package:serverpod_database/serverpod_database.dart' as _isd;

abstract class OutboxReport
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  OutboxReport._({
    this.id,
    required this.clientReportId,
    required this.zoneId,
    required this.rawText,
    this.lat,
    this.lng,
    this.accuracyM,
    this.imagePath,
    required this.clientCreatedAt,
    required this.state,
    int? attempts,
    this.lastError,
  }) : attempts = attempts ?? 0;

  factory OutboxReport({
    int? id,
    required _isc.UuidValue clientReportId,
    required int zoneId,
    required String rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    String? imagePath,
    required DateTime clientCreatedAt,
    required String state,
    int? attempts,
    String? lastError,
  }) = _OutboxReportImpl;

  factory OutboxReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return OutboxReport(
      id: jsonSerialization['id'] as int?,
      clientReportId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientReportId'],
      ),
      zoneId: jsonSerialization['zoneId'] as int,
      rawText: jsonSerialization['rawText'] as String,
      lat: (jsonSerialization['lat'] as num?)?.toDouble(),
      lng: (jsonSerialization['lng'] as num?)?.toDouble(),
      accuracyM: (jsonSerialization['accuracyM'] as num?)?.toDouble(),
      imagePath: jsonSerialization['imagePath'] as String?,
      clientCreatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['clientCreatedAt'],
      ),
      state: jsonSerialization['state'] as String,
      attempts: jsonSerialization['attempts'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
    );
  }

  static final t = OutboxReportTable();

  static const db = OutboxReportRepository._();

  @override
  int? id;

  _isc.UuidValue clientReportId;

  int zoneId;

  String rawText;

  double? lat;

  double? lng;

  double? accuracyM;

  String? imagePath;

  DateTime clientCreatedAt;

  String state;

  int attempts;

  String? lastError;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [OutboxReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OutboxReport copyWith({
    int? id,
    _isc.UuidValue? clientReportId,
    int? zoneId,
    String? rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    String? imagePath,
    DateTime? clientCreatedAt,
    String? state,
    int? attempts,
    String? lastError,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OutboxReport',
      if (id != null) 'id': id,
      'clientReportId': clientReportId.toJson(),
      'zoneId': zoneId,
      'rawText': rawText,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracyM': accuracyM,
      if (imagePath != null) 'imagePath': imagePath,
      'clientCreatedAt': clientCreatedAt.toJson(),
      'state': state,
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OutboxReport',
      if (id != null) 'id': id,
      'clientReportId': clientReportId.toJson(),
      'zoneId': zoneId,
      'rawText': rawText,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracyM': accuracyM,
      if (imagePath != null) 'imagePath': imagePath,
      'clientCreatedAt': clientCreatedAt.toJson(),
      'state': state,
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
    };
  }

  static OutboxReportInclude include() {
    return OutboxReportInclude._();
  }

  static OutboxReportIncludeList includeList({
    _isd.WhereExpressionBuilder<OutboxReportTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OutboxReportTable>? orderBy,
    _isd.OrderByListBuilder<OutboxReportTable>? orderByList,
    OutboxReportInclude? include,
  }) {
    return OutboxReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OutboxReport.t),
      orderByList: orderByList?.call(OutboxReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OutboxReportImpl extends OutboxReport {
  _OutboxReportImpl({
    int? id,
    required _isc.UuidValue clientReportId,
    required int zoneId,
    required String rawText,
    double? lat,
    double? lng,
    double? accuracyM,
    String? imagePath,
    required DateTime clientCreatedAt,
    required String state,
    int? attempts,
    String? lastError,
  }) : super._(
         id: id,
         clientReportId: clientReportId,
         zoneId: zoneId,
         rawText: rawText,
         lat: lat,
         lng: lng,
         accuracyM: accuracyM,
         imagePath: imagePath,
         clientCreatedAt: clientCreatedAt,
         state: state,
         attempts: attempts,
         lastError: lastError,
       );

  /// Returns a shallow copy of this [OutboxReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OutboxReport copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clientReportId,
    int? zoneId,
    String? rawText,
    Object? lat = _Undefined,
    Object? lng = _Undefined,
    Object? accuracyM = _Undefined,
    Object? imagePath = _Undefined,
    DateTime? clientCreatedAt,
    String? state,
    int? attempts,
    Object? lastError = _Undefined,
  }) {
    return OutboxReport(
      id: id is int? ? id : this.id,
      clientReportId: clientReportId ?? this.clientReportId,
      zoneId: zoneId ?? this.zoneId,
      rawText: rawText ?? this.rawText,
      lat: lat is double? ? lat : this.lat,
      lng: lng is double? ? lng : this.lng,
      accuracyM: accuracyM is double? ? accuracyM : this.accuracyM,
      imagePath: imagePath is String? ? imagePath : this.imagePath,
      clientCreatedAt: clientCreatedAt ?? this.clientCreatedAt,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      lastError: lastError is String? ? lastError : this.lastError,
    );
  }
}

class OutboxReportUpdateTable extends _isd.UpdateTable<OutboxReportTable> {
  OutboxReportUpdateTable(super.table);

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> clientReportId(
    _isc.UuidValue value,
  ) => _isd.ColumnValue(
    table.clientReportId,
    value,
  );

  _isd.ColumnValue<int, int> zoneId(int value) => _isd.ColumnValue(
    table.zoneId,
    value,
  );

  _isd.ColumnValue<String, String> rawText(String value) => _isd.ColumnValue(
    table.rawText,
    value,
  );

  _isd.ColumnValue<double, double> lat(double? value) => _isd.ColumnValue(
    table.lat,
    value,
  );

  _isd.ColumnValue<double, double> lng(double? value) => _isd.ColumnValue(
    table.lng,
    value,
  );

  _isd.ColumnValue<double, double> accuracyM(double? value) => _isd.ColumnValue(
    table.accuracyM,
    value,
  );

  _isd.ColumnValue<String, String> imagePath(String? value) => _isd.ColumnValue(
    table.imagePath,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> clientCreatedAt(DateTime value) =>
      _isd.ColumnValue(
        table.clientCreatedAt,
        value,
      );

  _isd.ColumnValue<String, String> state(String value) => _isd.ColumnValue(
    table.state,
    value,
  );

  _isd.ColumnValue<int, int> attempts(int value) => _isd.ColumnValue(
    table.attempts,
    value,
  );

  _isd.ColumnValue<String, String> lastError(String? value) => _isd.ColumnValue(
    table.lastError,
    value,
  );
}

class OutboxReportTable extends _isd.Table<int?> {
  OutboxReportTable({super.tableRelation}) : super(tableName: 'outbox_report') {
    updateTable = OutboxReportUpdateTable(this);
    clientReportId = _isd.ColumnUuid(
      'clientReportId',
      this,
    );
    zoneId = _isd.ColumnInt(
      'zoneId',
      this,
    );
    rawText = _isd.ColumnString(
      'rawText',
      this,
    );
    lat = _isd.ColumnDouble(
      'lat',
      this,
    );
    lng = _isd.ColumnDouble(
      'lng',
      this,
    );
    accuracyM = _isd.ColumnDouble(
      'accuracyM',
      this,
    );
    imagePath = _isd.ColumnString(
      'imagePath',
      this,
    );
    clientCreatedAt = _isd.ColumnDateTime(
      'clientCreatedAt',
      this,
    );
    state = _isd.ColumnString(
      'state',
      this,
    );
    attempts = _isd.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    lastError = _isd.ColumnString(
      'lastError',
      this,
    );
  }

  late final OutboxReportUpdateTable updateTable;

  late final _isd.ColumnUuid clientReportId;

  late final _isd.ColumnInt zoneId;

  late final _isd.ColumnString rawText;

  late final _isd.ColumnDouble lat;

  late final _isd.ColumnDouble lng;

  late final _isd.ColumnDouble accuracyM;

  late final _isd.ColumnString imagePath;

  late final _isd.ColumnDateTime clientCreatedAt;

  late final _isd.ColumnString state;

  late final _isd.ColumnInt attempts;

  late final _isd.ColumnString lastError;

  @override
  List<_isd.Column> get columns => [
    id,
    clientReportId,
    zoneId,
    rawText,
    lat,
    lng,
    accuracyM,
    imagePath,
    clientCreatedAt,
    state,
    attempts,
    lastError,
  ];
}

class OutboxReportInclude extends _isd.IncludeObject {
  OutboxReportInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => OutboxReport.t;
}

class OutboxReportIncludeList extends _isd.IncludeList {
  OutboxReportIncludeList._({
    _isd.WhereExpressionBuilder<OutboxReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OutboxReport.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => OutboxReport.t;
}

class OutboxReportRepository {
  const OutboxReportRepository._();

  /// Returns a list of [OutboxReport]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<OutboxReport>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OutboxReportTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OutboxReportTable>? orderBy,
    _isd.OrderByListBuilder<OutboxReportTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OutboxReport>(
      where: where?.call(OutboxReport.t),
      orderBy: orderBy?.call(OutboxReport.t),
      orderByList: orderByList?.call(OutboxReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OutboxReport] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<OutboxReport?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OutboxReportTable>? where,
    int? offset,
    _isd.OrderByBuilder<OutboxReportTable>? orderBy,
    _isd.OrderByListBuilder<OutboxReportTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OutboxReport>(
      where: where?.call(OutboxReport.t),
      orderBy: orderBy?.call(OutboxReport.t),
      orderByList: orderByList?.call(OutboxReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OutboxReport] by its [id] or null if no such row exists.
  Future<OutboxReport?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OutboxReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OutboxReport]s in the list and returns the inserted rows.
  ///
  /// The returned [OutboxReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxReport>> insert(
    _isd.DatabaseSession session,
    List<OutboxReport> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OutboxReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OutboxReport] and returns the inserted row.
  ///
  /// The returned [OutboxReport] will have its `id` field set.
  Future<OutboxReport> insertRow(
    _isd.DatabaseSession session,
    OutboxReport row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<OutboxReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OutboxReport]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [OutboxReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxReport>> upsert(
    _isd.DatabaseSession session,
    List<OutboxReport> rows, {
    required _isd.ColumnSelections<OutboxReportTable> conflictColumns,
    _isd.ColumnSelections<OutboxReportTable>? updateColumns,
    _isd.WhereExpressionBuilder<OutboxReportTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OutboxReport>(
      rows,
      conflictColumns: conflictColumns(OutboxReport.t),
      updateColumns: updateColumns?.call(OutboxReport.t),
      updateWhere: updateWhere?.call(OutboxReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OutboxReport] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [OutboxReport] will have its `id` field set.
  Future<OutboxReport?> upsertRow(
    _isd.DatabaseSession session,
    OutboxReport row, {
    required _isd.ColumnSelections<OutboxReportTable> conflictColumns,
    _isd.ColumnSelections<OutboxReportTable>? updateColumns,
    _isd.WhereExpressionBuilder<OutboxReportTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OutboxReport>(
      row,
      conflictColumns: conflictColumns(OutboxReport.t),
      updateColumns: updateColumns?.call(OutboxReport.t),
      updateWhere: updateWhere?.call(OutboxReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [OutboxReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxReport>> update(
    _isd.DatabaseSession session,
    List<OutboxReport> rows, {
    _isd.ColumnSelections<OutboxReportTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OutboxReport>(
      rows,
      columns: columns?.call(OutboxReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OutboxReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OutboxReport> updateRow(
    _isd.DatabaseSession session,
    OutboxReport row, {
    _isd.ColumnSelections<OutboxReportTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<OutboxReport>(
      row,
      columns: columns?.call(OutboxReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OutboxReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OutboxReport?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<OutboxReportUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<OutboxReport>(
      id,
      columnValues: columnValues(OutboxReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OutboxReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxReport>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<OutboxReportUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<OutboxReportTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OutboxReportTable>? orderBy,
    _isd.OrderByListBuilder<OutboxReportTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OutboxReport>(
      columnValues: columnValues(OutboxReport.t.updateTable),
      where: where(OutboxReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OutboxReport.t),
      orderByList: orderByList?.call(OutboxReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OutboxReport]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxReport>> delete(
    _isd.DatabaseSession session,
    List<OutboxReport> rows, {
    _isd.OrderByBuilder<OutboxReportTable>? orderBy,
    _isd.OrderByListBuilder<OutboxReportTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OutboxReport>(
      rows,
      orderBy: orderBy?.call(OutboxReport.t),
      orderByList: orderByList?.call(OutboxReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OutboxReport].
  Future<OutboxReport> deleteRow(
    _isd.DatabaseSession session,
    OutboxReport row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OutboxReport>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxReport>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OutboxReportTable> where,
    _isd.OrderByBuilder<OutboxReportTable>? orderBy,
    _isd.OrderByListBuilder<OutboxReportTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OutboxReport>(
      where: where(OutboxReport.t),
      orderBy: orderBy?.call(OutboxReport.t),
      orderByList: orderByList?.call(OutboxReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OutboxReportTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<OutboxReport>(
      where: where?.call(OutboxReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OutboxReport] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OutboxReportTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OutboxReport>(
      where: where(OutboxReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
