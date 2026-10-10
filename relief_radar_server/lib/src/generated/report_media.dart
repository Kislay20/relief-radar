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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

abstract class ReportMedia
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ReportMedia._({
    this.id,
    required this.reportId,
    required this.mime,
    required this.bytes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReportMedia({
    int? id,
    required int reportId,
    required String mime,
    required _idt.ByteData bytes,
    DateTime? createdAt,
  }) = _ReportMediaImpl;

  factory ReportMedia.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportMedia(
      id: jsonSerialization['id'] as int?,
      reportId: jsonSerialization['reportId'] as int,
      mime: jsonSerialization['mime'] as String,
      bytes: _is.ByteDataJsonExtension.fromJson(jsonSerialization['bytes']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ReportMediaTable();

  static const db = ReportMediaRepository._();

  @override
  int? id;

  int reportId;

  String mime;

  _idt.ByteData bytes;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReportMedia]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportMedia copyWith({
    int? id,
    int? reportId,
    String? mime,
    _idt.ByteData? bytes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportMedia',
      if (id != null) 'id': id,
      'reportId': reportId,
      'mime': mime,
      'bytes': bytes.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportMedia',
      if (id != null) 'id': id,
      'reportId': reportId,
      'mime': mime,
      'bytes': bytes.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ReportMediaInclude include() {
    return ReportMediaInclude._();
  }

  static ReportMediaIncludeList includeList({
    _is.WhereExpressionBuilder<ReportMediaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportMediaTable>? orderBy,
    _is.OrderByListBuilder<ReportMediaTable>? orderByList,
    ReportMediaInclude? include,
  }) {
    return ReportMediaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReportMedia.t),
      orderByList: orderByList?.call(ReportMedia.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportMediaImpl extends ReportMedia {
  _ReportMediaImpl({
    int? id,
    required int reportId,
    required String mime,
    required _idt.ByteData bytes,
    DateTime? createdAt,
  }) : super._(
         id: id,
         reportId: reportId,
         mime: mime,
         bytes: bytes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReportMedia]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportMedia copyWith({
    Object? id = _Undefined,
    int? reportId,
    String? mime,
    _idt.ByteData? bytes,
    DateTime? createdAt,
  }) {
    return ReportMedia(
      id: id is int? ? id : this.id,
      reportId: reportId ?? this.reportId,
      mime: mime ?? this.mime,
      bytes: bytes ?? this.bytes.clone(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReportMediaUpdateTable extends _is.UpdateTable<ReportMediaTable> {
  ReportMediaUpdateTable(super.table);

  _is.ColumnValue<int, int> reportId(int value) => _is.ColumnValue(
    table.reportId,
    value,
  );

  _is.ColumnValue<String, String> mime(String value) => _is.ColumnValue(
    table.mime,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> bytes(_idt.ByteData value) =>
      _is.ColumnValue(
        table.bytes,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReportMediaTable extends _is.Table<int?> {
  ReportMediaTable({super.tableRelation}) : super(tableName: 'report_media') {
    updateTable = ReportMediaUpdateTable(this);
    reportId = _is.ColumnInt(
      'reportId',
      this,
    );
    mime = _is.ColumnString(
      'mime',
      this,
    );
    bytes = _is.ColumnByteData(
      'bytes',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ReportMediaUpdateTable updateTable;

  late final _is.ColumnInt reportId;

  late final _is.ColumnString mime;

  late final _is.ColumnByteData bytes;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    reportId,
    mime,
    bytes,
    createdAt,
  ];
}

class ReportMediaInclude extends _is.IncludeObject {
  ReportMediaInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ReportMedia.t;
}

class ReportMediaIncludeList extends _is.IncludeList {
  ReportMediaIncludeList._({
    _is.WhereExpressionBuilder<ReportMediaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReportMedia.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ReportMedia.t;
}

class ReportMediaRepository {
  const ReportMediaRepository._();

  /// Returns a list of [ReportMedia]s matching the given query parameters.
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
  Future<List<ReportMedia>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportMediaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportMediaTable>? orderBy,
    _is.OrderByListBuilder<ReportMediaTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReportMedia>(
      where: where?.call(ReportMedia.t),
      orderBy: orderBy?.call(ReportMedia.t),
      orderByList: orderByList?.call(ReportMedia.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReportMedia] matching the given query parameters.
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
  Future<ReportMedia?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportMediaTable>? where,
    int? offset,
    _is.OrderByBuilder<ReportMediaTable>? orderBy,
    _is.OrderByListBuilder<ReportMediaTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReportMedia>(
      where: where?.call(ReportMedia.t),
      orderBy: orderBy?.call(ReportMedia.t),
      orderByList: orderByList?.call(ReportMedia.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReportMedia] by its [id] or null if no such row exists.
  Future<ReportMedia?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReportMedia>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReportMedia]s in the list and returns the inserted rows.
  ///
  /// The returned [ReportMedia]s will have their `id` fields set.
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
  Future<List<ReportMedia>> insert(
    _is.DatabaseSession session,
    List<ReportMedia> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReportMedia>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReportMedia] and returns the inserted row.
  ///
  /// The returned [ReportMedia] will have its `id` field set.
  Future<ReportMedia> insertRow(
    _is.DatabaseSession session,
    ReportMedia row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReportMedia>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReportMedia]s in the list and returns the resulting rows.
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
  /// The returned [ReportMedia]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportMedia>> upsert(
    _is.DatabaseSession session,
    List<ReportMedia> rows, {
    required _is.ColumnSelections<ReportMediaTable> conflictColumns,
    _is.ColumnSelections<ReportMediaTable>? updateColumns,
    _is.WhereExpressionBuilder<ReportMediaTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReportMedia>(
      rows,
      conflictColumns: conflictColumns(ReportMedia.t),
      updateColumns: updateColumns?.call(ReportMedia.t),
      updateWhere: updateWhere?.call(ReportMedia.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReportMedia] and returns the resulting row.
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
  /// The returned [ReportMedia] will have its `id` field set.
  Future<ReportMedia?> upsertRow(
    _is.DatabaseSession session,
    ReportMedia row, {
    required _is.ColumnSelections<ReportMediaTable> conflictColumns,
    _is.ColumnSelections<ReportMediaTable>? updateColumns,
    _is.WhereExpressionBuilder<ReportMediaTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReportMedia>(
      row,
      conflictColumns: conflictColumns(ReportMedia.t),
      updateColumns: updateColumns?.call(ReportMedia.t),
      updateWhere: updateWhere?.call(ReportMedia.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReportMedia]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportMedia>> update(
    _is.DatabaseSession session,
    List<ReportMedia> rows, {
    _is.ColumnSelections<ReportMediaTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReportMedia>(
      rows,
      columns: columns?.call(ReportMedia.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReportMedia]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReportMedia> updateRow(
    _is.DatabaseSession session,
    ReportMedia row, {
    _is.ColumnSelections<ReportMediaTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReportMedia>(
      row,
      columns: columns?.call(ReportMedia.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReportMedia] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReportMedia?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ReportMediaUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReportMedia>(
      id,
      columnValues: columnValues(ReportMedia.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReportMedia]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportMedia>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReportMediaUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReportMediaTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportMediaTable>? orderBy,
    _is.OrderByListBuilder<ReportMediaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReportMedia>(
      columnValues: columnValues(ReportMedia.t.updateTable),
      where: where(ReportMedia.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReportMedia.t),
      orderByList: orderByList?.call(ReportMedia.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReportMedia]s in the list and returns the deleted rows.
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
  Future<List<ReportMedia>> delete(
    _is.DatabaseSession session,
    List<ReportMedia> rows, {
    _is.OrderByBuilder<ReportMediaTable>? orderBy,
    _is.OrderByListBuilder<ReportMediaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReportMedia>(
      rows,
      orderBy: orderBy?.call(ReportMedia.t),
      orderByList: orderByList?.call(ReportMedia.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReportMedia].
  Future<ReportMedia> deleteRow(
    _is.DatabaseSession session,
    ReportMedia row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReportMedia>(
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
  Future<List<ReportMedia>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReportMediaTable> where,
    _is.OrderByBuilder<ReportMediaTable>? orderBy,
    _is.OrderByListBuilder<ReportMediaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReportMedia>(
      where: where(ReportMedia.t),
      orderBy: orderBy?.call(ReportMedia.t),
      orderByList: orderByList?.call(ReportMedia.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportMediaTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReportMedia>(
      where: where?.call(ReportMedia.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReportMedia] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReportMediaTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReportMedia>(
      where: where(ReportMedia.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
