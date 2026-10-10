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

abstract class StreamCursor
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  StreamCursor._({
    this.id,
    required this.streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) : lastSeq = lastSeq ?? 0,
       updatedAt = updatedAt ?? DateTime.now();

  factory StreamCursor({
    int? id,
    required String streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) = _StreamCursorImpl;

  factory StreamCursor.fromJson(Map<String, dynamic> jsonSerialization) {
    return StreamCursor(
      id: jsonSerialization['id'] as int?,
      streamId: jsonSerialization['streamId'] as String,
      lastSeq: jsonSerialization['lastSeq'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = StreamCursorTable();

  static const db = StreamCursorRepository._();

  @override
  int? id;

  String streamId;

  int lastSeq;

  DateTime updatedAt;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [StreamCursor]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StreamCursor copyWith({
    int? id,
    String? streamId,
    int? lastSeq,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StreamCursor',
      if (id != null) 'id': id,
      'streamId': streamId,
      'lastSeq': lastSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StreamCursor',
      if (id != null) 'id': id,
      'streamId': streamId,
      'lastSeq': lastSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static StreamCursorInclude include() {
    return StreamCursorInclude._();
  }

  static StreamCursorIncludeList includeList({
    _isd.WhereExpressionBuilder<StreamCursorTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StreamCursorTable>? orderBy,
    _isd.OrderByListBuilder<StreamCursorTable>? orderByList,
    StreamCursorInclude? include,
  }) {
    return StreamCursorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StreamCursor.t),
      orderByList: orderByList?.call(StreamCursor.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StreamCursorImpl extends StreamCursor {
  _StreamCursorImpl({
    int? id,
    required String streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         streamId: streamId,
         lastSeq: lastSeq,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [StreamCursor]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StreamCursor copyWith({
    Object? id = _Undefined,
    String? streamId,
    int? lastSeq,
    DateTime? updatedAt,
  }) {
    return StreamCursor(
      id: id is int? ? id : this.id,
      streamId: streamId ?? this.streamId,
      lastSeq: lastSeq ?? this.lastSeq,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StreamCursorUpdateTable extends _isd.UpdateTable<StreamCursorTable> {
  StreamCursorUpdateTable(super.table);

  _isd.ColumnValue<String, String> streamId(String value) => _isd.ColumnValue(
    table.streamId,
    value,
  );

  _isd.ColumnValue<int, int> lastSeq(int value) => _isd.ColumnValue(
    table.lastSeq,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _isd.ColumnValue(
        table.updatedAt,
        value,
      );
}

class StreamCursorTable extends _isd.Table<int?> {
  StreamCursorTable({super.tableRelation}) : super(tableName: 'stream_cursor') {
    updateTable = StreamCursorUpdateTable(this);
    streamId = _isd.ColumnString(
      'streamId',
      this,
    );
    lastSeq = _isd.ColumnInt(
      'lastSeq',
      this,
      hasDefault: true,
    );
    updatedAt = _isd.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final StreamCursorUpdateTable updateTable;

  late final _isd.ColumnString streamId;

  late final _isd.ColumnInt lastSeq;

  late final _isd.ColumnDateTime updatedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    streamId,
    lastSeq,
    updatedAt,
  ];
}

class StreamCursorInclude extends _isd.IncludeObject {
  StreamCursorInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => StreamCursor.t;
}

class StreamCursorIncludeList extends _isd.IncludeList {
  StreamCursorIncludeList._({
    _isd.WhereExpressionBuilder<StreamCursorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StreamCursor.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => StreamCursor.t;
}

class StreamCursorRepository {
  const StreamCursorRepository._();

  /// Returns a list of [StreamCursor]s matching the given query parameters.
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
  Future<List<StreamCursor>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<StreamCursorTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StreamCursorTable>? orderBy,
    _isd.OrderByListBuilder<StreamCursorTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StreamCursor>(
      where: where?.call(StreamCursor.t),
      orderBy: orderBy?.call(StreamCursor.t),
      orderByList: orderByList?.call(StreamCursor.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StreamCursor] matching the given query parameters.
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
  Future<StreamCursor?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<StreamCursorTable>? where,
    int? offset,
    _isd.OrderByBuilder<StreamCursorTable>? orderBy,
    _isd.OrderByListBuilder<StreamCursorTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StreamCursor>(
      where: where?.call(StreamCursor.t),
      orderBy: orderBy?.call(StreamCursor.t),
      orderByList: orderByList?.call(StreamCursor.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StreamCursor] by its [id] or null if no such row exists.
  Future<StreamCursor?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StreamCursor>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StreamCursor]s in the list and returns the inserted rows.
  ///
  /// The returned [StreamCursor]s will have their `id` fields set.
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
  Future<List<StreamCursor>> insert(
    _isd.DatabaseSession session,
    List<StreamCursor> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StreamCursor>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StreamCursor] and returns the inserted row.
  ///
  /// The returned [StreamCursor] will have its `id` field set.
  Future<StreamCursor> insertRow(
    _isd.DatabaseSession session,
    StreamCursor row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<StreamCursor>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StreamCursor]s in the list and returns the resulting rows.
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
  /// The returned [StreamCursor]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StreamCursor>> upsert(
    _isd.DatabaseSession session,
    List<StreamCursor> rows, {
    required _isd.ColumnSelections<StreamCursorTable> conflictColumns,
    _isd.ColumnSelections<StreamCursorTable>? updateColumns,
    _isd.WhereExpressionBuilder<StreamCursorTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StreamCursor>(
      rows,
      conflictColumns: conflictColumns(StreamCursor.t),
      updateColumns: updateColumns?.call(StreamCursor.t),
      updateWhere: updateWhere?.call(StreamCursor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StreamCursor] and returns the resulting row.
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
  /// The returned [StreamCursor] will have its `id` field set.
  Future<StreamCursor?> upsertRow(
    _isd.DatabaseSession session,
    StreamCursor row, {
    required _isd.ColumnSelections<StreamCursorTable> conflictColumns,
    _isd.ColumnSelections<StreamCursorTable>? updateColumns,
    _isd.WhereExpressionBuilder<StreamCursorTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StreamCursor>(
      row,
      conflictColumns: conflictColumns(StreamCursor.t),
      updateColumns: updateColumns?.call(StreamCursor.t),
      updateWhere: updateWhere?.call(StreamCursor.t),
      transaction: transaction,
    );
  }

  /// Updates all [StreamCursor]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StreamCursor>> update(
    _isd.DatabaseSession session,
    List<StreamCursor> rows, {
    _isd.ColumnSelections<StreamCursorTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StreamCursor>(
      rows,
      columns: columns?.call(StreamCursor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StreamCursor]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StreamCursor> updateRow(
    _isd.DatabaseSession session,
    StreamCursor row, {
    _isd.ColumnSelections<StreamCursorTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<StreamCursor>(
      row,
      columns: columns?.call(StreamCursor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StreamCursor] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StreamCursor?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<StreamCursorUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<StreamCursor>(
      id,
      columnValues: columnValues(StreamCursor.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StreamCursor]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StreamCursor>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<StreamCursorUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<StreamCursorTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StreamCursorTable>? orderBy,
    _isd.OrderByListBuilder<StreamCursorTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StreamCursor>(
      columnValues: columnValues(StreamCursor.t.updateTable),
      where: where(StreamCursor.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StreamCursor.t),
      orderByList: orderByList?.call(StreamCursor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StreamCursor]s in the list and returns the deleted rows.
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
  Future<List<StreamCursor>> delete(
    _isd.DatabaseSession session,
    List<StreamCursor> rows, {
    _isd.OrderByBuilder<StreamCursorTable>? orderBy,
    _isd.OrderByListBuilder<StreamCursorTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StreamCursor>(
      rows,
      orderBy: orderBy?.call(StreamCursor.t),
      orderByList: orderByList?.call(StreamCursor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StreamCursor].
  Future<StreamCursor> deleteRow(
    _isd.DatabaseSession session,
    StreamCursor row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StreamCursor>(
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
  Future<List<StreamCursor>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<StreamCursorTable> where,
    _isd.OrderByBuilder<StreamCursorTable>? orderBy,
    _isd.OrderByListBuilder<StreamCursorTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StreamCursor>(
      where: where(StreamCursor.t),
      orderBy: orderBy?.call(StreamCursor.t),
      orderByList: orderByList?.call(StreamCursor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<StreamCursorTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<StreamCursor>(
      where: where?.call(StreamCursor.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StreamCursor] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<StreamCursorTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StreamCursor>(
      where: where(StreamCursor.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
