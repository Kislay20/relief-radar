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
import 'package:relief_radar_client/src/protocol/protocol.dart' as _if75qna0;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'incident_snapshot.dart' as _idmorftz;

abstract class IncidentCache
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  IncidentCache._({
    this.id,
    required this.incidentId,
    required this.zoneId,
    required this.snapshot,
  });

  factory IncidentCache({
    int? id,
    required int incidentId,
    required int zoneId,
    required _idmorftz.IncidentSnapshot snapshot,
  }) = _IncidentCacheImpl;

  factory IncidentCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentCache(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      zoneId: jsonSerialization['zoneId'] as int,
      snapshot: _if75qna0.Protocol().deserialize<_idmorftz.IncidentSnapshot>(
        jsonSerialization['snapshot'],
      ),
    );
  }

  static final t = IncidentCacheTable();

  static const db = IncidentCacheRepository._();

  @override
  int? id;

  int incidentId;

  int zoneId;

  _idmorftz.IncidentSnapshot snapshot;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [IncidentCache]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IncidentCache copyWith({
    int? id,
    int? incidentId,
    int? zoneId,
    _idmorftz.IncidentSnapshot? snapshot,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentCache',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'zoneId': zoneId,
      'snapshot': snapshot.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentCache',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'zoneId': zoneId,
      'snapshot': snapshot.toJsonForProtocol(),
    };
  }

  static IncidentCacheInclude include() {
    return IncidentCacheInclude._();
  }

  static IncidentCacheIncludeList includeList({
    _isd.WhereExpressionBuilder<IncidentCacheTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<IncidentCacheTable>? orderBy,
    _isd.OrderByListBuilder<IncidentCacheTable>? orderByList,
    IncidentCacheInclude? include,
  }) {
    return IncidentCacheIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IncidentCache.t),
      orderByList: orderByList?.call(IncidentCache.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentCacheImpl extends IncidentCache {
  _IncidentCacheImpl({
    int? id,
    required int incidentId,
    required int zoneId,
    required _idmorftz.IncidentSnapshot snapshot,
  }) : super._(
         id: id,
         incidentId: incidentId,
         zoneId: zoneId,
         snapshot: snapshot,
       );

  /// Returns a shallow copy of this [IncidentCache]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IncidentCache copyWith({
    Object? id = _Undefined,
    int? incidentId,
    int? zoneId,
    _idmorftz.IncidentSnapshot? snapshot,
  }) {
    return IncidentCache(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      zoneId: zoneId ?? this.zoneId,
      snapshot: snapshot ?? this.snapshot.copyWith(),
    );
  }
}

class IncidentCacheUpdateTable extends _isd.UpdateTable<IncidentCacheTable> {
  IncidentCacheUpdateTable(super.table);

  _isd.ColumnValue<int, int> incidentId(int value) => _isd.ColumnValue(
    table.incidentId,
    value,
  );

  _isd.ColumnValue<int, int> zoneId(int value) => _isd.ColumnValue(
    table.zoneId,
    value,
  );

  _isd.ColumnValue<_idmorftz.IncidentSnapshot, _idmorftz.IncidentSnapshot>
  snapshot(_idmorftz.IncidentSnapshot value) => _isd.ColumnValue(
    table.snapshot,
    value,
  );
}

class IncidentCacheTable extends _isd.Table<int?> {
  IncidentCacheTable({super.tableRelation})
    : super(tableName: 'incident_cache') {
    updateTable = IncidentCacheUpdateTable(this);
    incidentId = _isd.ColumnInt(
      'incidentId',
      this,
    );
    zoneId = _isd.ColumnInt(
      'zoneId',
      this,
    );
    snapshot = _isd.ColumnSerializable<_idmorftz.IncidentSnapshot>(
      'snapshot',
      this,
    );
  }

  late final IncidentCacheUpdateTable updateTable;

  late final _isd.ColumnInt incidentId;

  late final _isd.ColumnInt zoneId;

  late final _isd.ColumnSerializable<_idmorftz.IncidentSnapshot> snapshot;

  @override
  List<_isd.Column> get columns => [
    id,
    incidentId,
    zoneId,
    snapshot,
  ];
}

class IncidentCacheInclude extends _isd.IncludeObject {
  IncidentCacheInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => IncidentCache.t;
}

class IncidentCacheIncludeList extends _isd.IncludeList {
  IncidentCacheIncludeList._({
    _isd.WhereExpressionBuilder<IncidentCacheTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IncidentCache.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => IncidentCache.t;
}

class IncidentCacheRepository {
  const IncidentCacheRepository._();

  /// Returns a list of [IncidentCache]s matching the given query parameters.
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
  Future<List<IncidentCache>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<IncidentCacheTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<IncidentCacheTable>? orderBy,
    _isd.OrderByListBuilder<IncidentCacheTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IncidentCache>(
      where: where?.call(IncidentCache.t),
      orderBy: orderBy?.call(IncidentCache.t),
      orderByList: orderByList?.call(IncidentCache.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IncidentCache] matching the given query parameters.
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
  Future<IncidentCache?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<IncidentCacheTable>? where,
    int? offset,
    _isd.OrderByBuilder<IncidentCacheTable>? orderBy,
    _isd.OrderByListBuilder<IncidentCacheTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IncidentCache>(
      where: where?.call(IncidentCache.t),
      orderBy: orderBy?.call(IncidentCache.t),
      orderByList: orderByList?.call(IncidentCache.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IncidentCache] by its [id] or null if no such row exists.
  Future<IncidentCache?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IncidentCache>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IncidentCache]s in the list and returns the inserted rows.
  ///
  /// The returned [IncidentCache]s will have their `id` fields set.
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
  Future<List<IncidentCache>> insert(
    _isd.DatabaseSession session,
    List<IncidentCache> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IncidentCache>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IncidentCache] and returns the inserted row.
  ///
  /// The returned [IncidentCache] will have its `id` field set.
  Future<IncidentCache> insertRow(
    _isd.DatabaseSession session,
    IncidentCache row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<IncidentCache>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IncidentCache]s in the list and returns the resulting rows.
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
  /// The returned [IncidentCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IncidentCache>> upsert(
    _isd.DatabaseSession session,
    List<IncidentCache> rows, {
    required _isd.ColumnSelections<IncidentCacheTable> conflictColumns,
    _isd.ColumnSelections<IncidentCacheTable>? updateColumns,
    _isd.WhereExpressionBuilder<IncidentCacheTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IncidentCache>(
      rows,
      conflictColumns: conflictColumns(IncidentCache.t),
      updateColumns: updateColumns?.call(IncidentCache.t),
      updateWhere: updateWhere?.call(IncidentCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IncidentCache] and returns the resulting row.
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
  /// The returned [IncidentCache] will have its `id` field set.
  Future<IncidentCache?> upsertRow(
    _isd.DatabaseSession session,
    IncidentCache row, {
    required _isd.ColumnSelections<IncidentCacheTable> conflictColumns,
    _isd.ColumnSelections<IncidentCacheTable>? updateColumns,
    _isd.WhereExpressionBuilder<IncidentCacheTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IncidentCache>(
      row,
      conflictColumns: conflictColumns(IncidentCache.t),
      updateColumns: updateColumns?.call(IncidentCache.t),
      updateWhere: updateWhere?.call(IncidentCache.t),
      transaction: transaction,
    );
  }

  /// Updates all [IncidentCache]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IncidentCache>> update(
    _isd.DatabaseSession session,
    List<IncidentCache> rows, {
    _isd.ColumnSelections<IncidentCacheTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IncidentCache>(
      rows,
      columns: columns?.call(IncidentCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IncidentCache]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IncidentCache> updateRow(
    _isd.DatabaseSession session,
    IncidentCache row, {
    _isd.ColumnSelections<IncidentCacheTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<IncidentCache>(
      row,
      columns: columns?.call(IncidentCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IncidentCache] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IncidentCache?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<IncidentCacheUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<IncidentCache>(
      id,
      columnValues: columnValues(IncidentCache.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IncidentCache]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IncidentCache>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<IncidentCacheUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<IncidentCacheTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<IncidentCacheTable>? orderBy,
    _isd.OrderByListBuilder<IncidentCacheTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IncidentCache>(
      columnValues: columnValues(IncidentCache.t.updateTable),
      where: where(IncidentCache.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IncidentCache.t),
      orderByList: orderByList?.call(IncidentCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IncidentCache]s in the list and returns the deleted rows.
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
  Future<List<IncidentCache>> delete(
    _isd.DatabaseSession session,
    List<IncidentCache> rows, {
    _isd.OrderByBuilder<IncidentCacheTable>? orderBy,
    _isd.OrderByListBuilder<IncidentCacheTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IncidentCache>(
      rows,
      orderBy: orderBy?.call(IncidentCache.t),
      orderByList: orderByList?.call(IncidentCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IncidentCache].
  Future<IncidentCache> deleteRow(
    _isd.DatabaseSession session,
    IncidentCache row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IncidentCache>(
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
  Future<List<IncidentCache>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<IncidentCacheTable> where,
    _isd.OrderByBuilder<IncidentCacheTable>? orderBy,
    _isd.OrderByListBuilder<IncidentCacheTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IncidentCache>(
      where: where(IncidentCache.t),
      orderBy: orderBy?.call(IncidentCache.t),
      orderByList: orderByList?.call(IncidentCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<IncidentCacheTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<IncidentCache>(
      where: where?.call(IncidentCache.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IncidentCache] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<IncidentCacheTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IncidentCache>(
      where: where(IncidentCache.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
