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

abstract class StreamHead
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StreamHead._({
    this.id,
    required this.streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) : headSeq = headSeq ?? 0,
       updatedAt = updatedAt ?? DateTime.now();

  factory StreamHead({
    int? id,
    required String streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) = _StreamHeadImpl;

  factory StreamHead.fromJson(Map<String, dynamic> jsonSerialization) {
    return StreamHead(
      id: jsonSerialization['id'] as int?,
      streamId: jsonSerialization['streamId'] as String,
      headSeq: jsonSerialization['headSeq'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = StreamHeadTable();

  static const db = StreamHeadRepository._();

  @override
  int? id;

  String streamId;

  int headSeq;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StreamHead]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StreamHead copyWith({
    int? id,
    String? streamId,
    int? headSeq,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StreamHead',
      if (id != null) 'id': id,
      'streamId': streamId,
      'headSeq': headSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StreamHead',
      if (id != null) 'id': id,
      'streamId': streamId,
      'headSeq': headSeq,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static StreamHeadInclude include() {
    return StreamHeadInclude._();
  }

  static StreamHeadIncludeList includeList({
    _is.WhereExpressionBuilder<StreamHeadTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StreamHeadTable>? orderBy,
    _is.OrderByListBuilder<StreamHeadTable>? orderByList,
    StreamHeadInclude? include,
  }) {
    return StreamHeadIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StreamHead.t),
      orderByList: orderByList?.call(StreamHead.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StreamHeadImpl extends StreamHead {
  _StreamHeadImpl({
    int? id,
    required String streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         streamId: streamId,
         headSeq: headSeq,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [StreamHead]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StreamHead copyWith({
    Object? id = _Undefined,
    String? streamId,
    int? headSeq,
    DateTime? updatedAt,
  }) {
    return StreamHead(
      id: id is int? ? id : this.id,
      streamId: streamId ?? this.streamId,
      headSeq: headSeq ?? this.headSeq,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StreamHeadUpdateTable extends _is.UpdateTable<StreamHeadTable> {
  StreamHeadUpdateTable(super.table);

  _is.ColumnValue<String, String> streamId(String value) => _is.ColumnValue(
    table.streamId,
    value,
  );

  _is.ColumnValue<int, int> headSeq(int value) => _is.ColumnValue(
    table.headSeq,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class StreamHeadTable extends _is.Table<int?> {
  StreamHeadTable({super.tableRelation}) : super(tableName: 'stream_head') {
    updateTable = StreamHeadUpdateTable(this);
    streamId = _is.ColumnString(
      'streamId',
      this,
    );
    headSeq = _is.ColumnInt(
      'headSeq',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final StreamHeadUpdateTable updateTable;

  late final _is.ColumnString streamId;

  late final _is.ColumnInt headSeq;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    streamId,
    headSeq,
    updatedAt,
  ];
}

class StreamHeadInclude extends _is.IncludeObject {
  StreamHeadInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StreamHead.t;
}

class StreamHeadIncludeList extends _is.IncludeList {
  StreamHeadIncludeList._({
    _is.WhereExpressionBuilder<StreamHeadTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StreamHead.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StreamHead.t;
}

class StreamHeadRepository {
  const StreamHeadRepository._();

  /// Returns a list of [StreamHead]s matching the given query parameters.
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
  Future<List<StreamHead>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StreamHeadTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StreamHeadTable>? orderBy,
    _is.OrderByListBuilder<StreamHeadTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StreamHead>(
      where: where?.call(StreamHead.t),
      orderBy: orderBy?.call(StreamHead.t),
      orderByList: orderByList?.call(StreamHead.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StreamHead] matching the given query parameters.
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
  Future<StreamHead?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StreamHeadTable>? where,
    int? offset,
    _is.OrderByBuilder<StreamHeadTable>? orderBy,
    _is.OrderByListBuilder<StreamHeadTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StreamHead>(
      where: where?.call(StreamHead.t),
      orderBy: orderBy?.call(StreamHead.t),
      orderByList: orderByList?.call(StreamHead.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StreamHead] by its [id] or null if no such row exists.
  Future<StreamHead?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StreamHead>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StreamHead]s in the list and returns the inserted rows.
  ///
  /// The returned [StreamHead]s will have their `id` fields set.
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
  Future<List<StreamHead>> insert(
    _is.DatabaseSession session,
    List<StreamHead> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StreamHead>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StreamHead] and returns the inserted row.
  ///
  /// The returned [StreamHead] will have its `id` field set.
  Future<StreamHead> insertRow(
    _is.DatabaseSession session,
    StreamHead row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StreamHead>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StreamHead]s in the list and returns the resulting rows.
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
  /// The returned [StreamHead]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StreamHead>> upsert(
    _is.DatabaseSession session,
    List<StreamHead> rows, {
    required _is.ColumnSelections<StreamHeadTable> conflictColumns,
    _is.ColumnSelections<StreamHeadTable>? updateColumns,
    _is.WhereExpressionBuilder<StreamHeadTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StreamHead>(
      rows,
      conflictColumns: conflictColumns(StreamHead.t),
      updateColumns: updateColumns?.call(StreamHead.t),
      updateWhere: updateWhere?.call(StreamHead.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StreamHead] and returns the resulting row.
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
  /// The returned [StreamHead] will have its `id` field set.
  Future<StreamHead?> upsertRow(
    _is.DatabaseSession session,
    StreamHead row, {
    required _is.ColumnSelections<StreamHeadTable> conflictColumns,
    _is.ColumnSelections<StreamHeadTable>? updateColumns,
    _is.WhereExpressionBuilder<StreamHeadTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StreamHead>(
      row,
      conflictColumns: conflictColumns(StreamHead.t),
      updateColumns: updateColumns?.call(StreamHead.t),
      updateWhere: updateWhere?.call(StreamHead.t),
      transaction: transaction,
    );
  }

  /// Updates all [StreamHead]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StreamHead>> update(
    _is.DatabaseSession session,
    List<StreamHead> rows, {
    _is.ColumnSelections<StreamHeadTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StreamHead>(
      rows,
      columns: columns?.call(StreamHead.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StreamHead]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StreamHead> updateRow(
    _is.DatabaseSession session,
    StreamHead row, {
    _is.ColumnSelections<StreamHeadTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StreamHead>(
      row,
      columns: columns?.call(StreamHead.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StreamHead] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StreamHead?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StreamHeadUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StreamHead>(
      id,
      columnValues: columnValues(StreamHead.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StreamHead]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StreamHead>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StreamHeadUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StreamHeadTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StreamHeadTable>? orderBy,
    _is.OrderByListBuilder<StreamHeadTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StreamHead>(
      columnValues: columnValues(StreamHead.t.updateTable),
      where: where(StreamHead.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StreamHead.t),
      orderByList: orderByList?.call(StreamHead.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StreamHead]s in the list and returns the deleted rows.
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
  Future<List<StreamHead>> delete(
    _is.DatabaseSession session,
    List<StreamHead> rows, {
    _is.OrderByBuilder<StreamHeadTable>? orderBy,
    _is.OrderByListBuilder<StreamHeadTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StreamHead>(
      rows,
      orderBy: orderBy?.call(StreamHead.t),
      orderByList: orderByList?.call(StreamHead.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StreamHead].
  Future<StreamHead> deleteRow(
    _is.DatabaseSession session,
    StreamHead row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StreamHead>(
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
  Future<List<StreamHead>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StreamHeadTable> where,
    _is.OrderByBuilder<StreamHeadTable>? orderBy,
    _is.OrderByListBuilder<StreamHeadTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StreamHead>(
      where: where(StreamHead.t),
      orderBy: orderBy?.call(StreamHead.t),
      orderByList: orderByList?.call(StreamHead.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StreamHeadTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StreamHead>(
      where: where?.call(StreamHead.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StreamHead] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StreamHeadTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StreamHead>(
      where: where(StreamHead.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
