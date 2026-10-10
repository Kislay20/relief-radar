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

abstract class ResponderLocation
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ResponderLocation._({
    this.id,
    required this.responderId,
    required this.latitude,
    required this.longitude,
    DateTime? timestamp,
    required this.status,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ResponderLocation({
    int? id,
    required int responderId,
    required double latitude,
    required double longitude,
    DateTime? timestamp,
    required String status,
  }) = _ResponderLocationImpl;

  factory ResponderLocation.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResponderLocation(
      id: jsonSerialization['id'] as int?,
      responderId: jsonSerialization['responderId'] as int,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      status: jsonSerialization['status'] as String,
    );
  }

  static final t = ResponderLocationTable();

  static const db = ResponderLocationRepository._();

  @override
  int? id;

  int responderId;

  double latitude;

  double longitude;

  DateTime timestamp;

  String status;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ResponderLocation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResponderLocation copyWith({
    int? id,
    int? responderId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResponderLocation',
      if (id != null) 'id': id,
      'responderId': responderId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toJson(),
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResponderLocation',
      if (id != null) 'id': id,
      'responderId': responderId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toJson(),
      'status': status,
    };
  }

  static ResponderLocationInclude include() {
    return ResponderLocationInclude._();
  }

  static ResponderLocationIncludeList includeList({
    _is.WhereExpressionBuilder<ResponderLocationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResponderLocationTable>? orderBy,
    _is.OrderByListBuilder<ResponderLocationTable>? orderByList,
    ResponderLocationInclude? include,
  }) {
    return ResponderLocationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResponderLocation.t),
      orderByList: orderByList?.call(ResponderLocation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderLocationImpl extends ResponderLocation {
  _ResponderLocationImpl({
    int? id,
    required int responderId,
    required double latitude,
    required double longitude,
    DateTime? timestamp,
    required String status,
  }) : super._(
         id: id,
         responderId: responderId,
         latitude: latitude,
         longitude: longitude,
         timestamp: timestamp,
         status: status,
       );

  /// Returns a shallow copy of this [ResponderLocation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResponderLocation copyWith({
    Object? id = _Undefined,
    int? responderId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    String? status,
  }) {
    return ResponderLocation(
      id: id is int? ? id : this.id,
      responderId: responderId ?? this.responderId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

class ResponderLocationUpdateTable
    extends _is.UpdateTable<ResponderLocationTable> {
  ResponderLocationUpdateTable(super.table);

  _is.ColumnValue<int, int> responderId(int value) => _is.ColumnValue(
    table.responderId,
    value,
  );

  _is.ColumnValue<double, double> latitude(double value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _is.ColumnValue(
        table.timestamp,
        value,
      );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );
}

class ResponderLocationTable extends _is.Table<int?> {
  ResponderLocationTable({super.tableRelation})
    : super(tableName: 'responder_location') {
    updateTable = ResponderLocationUpdateTable(this);
    responderId = _is.ColumnInt(
      'responderId',
      this,
    );
    latitude = _is.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _is.ColumnDouble(
      'longitude',
      this,
    );
    timestamp = _is.ColumnDateTime(
      'timestamp',
      this,
      hasDefault: true,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
  }

  late final ResponderLocationUpdateTable updateTable;

  late final _is.ColumnInt responderId;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnDateTime timestamp;

  late final _is.ColumnString status;

  @override
  List<_is.Column> get columns => [
    id,
    responderId,
    latitude,
    longitude,
    timestamp,
    status,
  ];
}

class ResponderLocationInclude extends _is.IncludeObject {
  ResponderLocationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ResponderLocation.t;
}

class ResponderLocationIncludeList extends _is.IncludeList {
  ResponderLocationIncludeList._({
    _is.WhereExpressionBuilder<ResponderLocationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ResponderLocation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ResponderLocation.t;
}

class ResponderLocationRepository {
  const ResponderLocationRepository._();

  /// Returns a list of [ResponderLocation]s matching the given query parameters.
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
  Future<List<ResponderLocation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResponderLocationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResponderLocationTable>? orderBy,
    _is.OrderByListBuilder<ResponderLocationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ResponderLocation>(
      where: where?.call(ResponderLocation.t),
      orderBy: orderBy?.call(ResponderLocation.t),
      orderByList: orderByList?.call(ResponderLocation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ResponderLocation] matching the given query parameters.
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
  Future<ResponderLocation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResponderLocationTable>? where,
    int? offset,
    _is.OrderByBuilder<ResponderLocationTable>? orderBy,
    _is.OrderByListBuilder<ResponderLocationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ResponderLocation>(
      where: where?.call(ResponderLocation.t),
      orderBy: orderBy?.call(ResponderLocation.t),
      orderByList: orderByList?.call(ResponderLocation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ResponderLocation] by its [id] or null if no such row exists.
  Future<ResponderLocation?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ResponderLocation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ResponderLocation]s in the list and returns the inserted rows.
  ///
  /// The returned [ResponderLocation]s will have their `id` fields set.
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
  Future<List<ResponderLocation>> insert(
    _is.DatabaseSession session,
    List<ResponderLocation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ResponderLocation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ResponderLocation] and returns the inserted row.
  ///
  /// The returned [ResponderLocation] will have its `id` field set.
  Future<ResponderLocation> insertRow(
    _is.DatabaseSession session,
    ResponderLocation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ResponderLocation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ResponderLocation]s in the list and returns the resulting rows.
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
  /// The returned [ResponderLocation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResponderLocation>> upsert(
    _is.DatabaseSession session,
    List<ResponderLocation> rows, {
    required _is.ColumnSelections<ResponderLocationTable> conflictColumns,
    _is.ColumnSelections<ResponderLocationTable>? updateColumns,
    _is.WhereExpressionBuilder<ResponderLocationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ResponderLocation>(
      rows,
      conflictColumns: conflictColumns(ResponderLocation.t),
      updateColumns: updateColumns?.call(ResponderLocation.t),
      updateWhere: updateWhere?.call(ResponderLocation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ResponderLocation] and returns the resulting row.
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
  /// The returned [ResponderLocation] will have its `id` field set.
  Future<ResponderLocation?> upsertRow(
    _is.DatabaseSession session,
    ResponderLocation row, {
    required _is.ColumnSelections<ResponderLocationTable> conflictColumns,
    _is.ColumnSelections<ResponderLocationTable>? updateColumns,
    _is.WhereExpressionBuilder<ResponderLocationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ResponderLocation>(
      row,
      conflictColumns: conflictColumns(ResponderLocation.t),
      updateColumns: updateColumns?.call(ResponderLocation.t),
      updateWhere: updateWhere?.call(ResponderLocation.t),
      transaction: transaction,
    );
  }

  /// Updates all [ResponderLocation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResponderLocation>> update(
    _is.DatabaseSession session,
    List<ResponderLocation> rows, {
    _is.ColumnSelections<ResponderLocationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ResponderLocation>(
      rows,
      columns: columns?.call(ResponderLocation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ResponderLocation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ResponderLocation> updateRow(
    _is.DatabaseSession session,
    ResponderLocation row, {
    _is.ColumnSelections<ResponderLocationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ResponderLocation>(
      row,
      columns: columns?.call(ResponderLocation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ResponderLocation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ResponderLocation?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ResponderLocationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ResponderLocation>(
      id,
      columnValues: columnValues(ResponderLocation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ResponderLocation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResponderLocation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ResponderLocationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ResponderLocationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResponderLocationTable>? orderBy,
    _is.OrderByListBuilder<ResponderLocationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ResponderLocation>(
      columnValues: columnValues(ResponderLocation.t.updateTable),
      where: where(ResponderLocation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResponderLocation.t),
      orderByList: orderByList?.call(ResponderLocation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ResponderLocation]s in the list and returns the deleted rows.
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
  Future<List<ResponderLocation>> delete(
    _is.DatabaseSession session,
    List<ResponderLocation> rows, {
    _is.OrderByBuilder<ResponderLocationTable>? orderBy,
    _is.OrderByListBuilder<ResponderLocationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ResponderLocation>(
      rows,
      orderBy: orderBy?.call(ResponderLocation.t),
      orderByList: orderByList?.call(ResponderLocation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ResponderLocation].
  Future<ResponderLocation> deleteRow(
    _is.DatabaseSession session,
    ResponderLocation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ResponderLocation>(
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
  Future<List<ResponderLocation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResponderLocationTable> where,
    _is.OrderByBuilder<ResponderLocationTable>? orderBy,
    _is.OrderByListBuilder<ResponderLocationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ResponderLocation>(
      where: where(ResponderLocation.t),
      orderBy: orderBy?.call(ResponderLocation.t),
      orderByList: orderByList?.call(ResponderLocation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResponderLocationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ResponderLocation>(
      where: where?.call(ResponderLocation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ResponderLocation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResponderLocationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ResponderLocation>(
      where: where(ResponderLocation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
