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
import 'assignment_status.dart' as _ikrvejjw;

abstract class Assignment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Assignment._({
    this.id,
    required this.incidentId,
    required this.responderId,
    required this.status,
    required this.offeredAtLevel,
    DateTime? offeredAt,
    this.respondedAt,
    this.etaMinutes,
  }) : offeredAt = offeredAt ?? DateTime.now();

  factory Assignment({
    int? id,
    required int incidentId,
    required int responderId,
    required _ikrvejjw.AssignmentStatus status,
    required int offeredAtLevel,
    DateTime? offeredAt,
    DateTime? respondedAt,
    int? etaMinutes,
  }) = _AssignmentImpl;

  factory Assignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Assignment(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      responderId: jsonSerialization['responderId'] as int,
      status: _ikrvejjw.AssignmentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      offeredAtLevel: jsonSerialization['offeredAtLevel'] as int,
      offeredAt: jsonSerialization['offeredAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['offeredAt']),
      respondedAt: jsonSerialization['respondedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['respondedAt'],
            ),
      etaMinutes: jsonSerialization['etaMinutes'] as int?,
    );
  }

  static final t = AssignmentTable();

  static const db = AssignmentRepository._();

  @override
  int? id;

  int incidentId;

  int responderId;

  _ikrvejjw.AssignmentStatus status;

  int offeredAtLevel;

  DateTime offeredAt;

  DateTime? respondedAt;

  int? etaMinutes;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Assignment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Assignment copyWith({
    int? id,
    int? incidentId,
    int? responderId,
    _ikrvejjw.AssignmentStatus? status,
    int? offeredAtLevel,
    DateTime? offeredAt,
    DateTime? respondedAt,
    int? etaMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Assignment',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'responderId': responderId,
      'status': status.toJson(),
      'offeredAtLevel': offeredAtLevel,
      'offeredAt': offeredAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Assignment',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'responderId': responderId,
      'status': status.toJson(),
      'offeredAtLevel': offeredAtLevel,
      'offeredAt': offeredAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
    };
  }

  static AssignmentInclude include() {
    return AssignmentInclude._();
  }

  static AssignmentIncludeList includeList({
    _is.WhereExpressionBuilder<AssignmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AssignmentTable>? orderBy,
    _is.OrderByListBuilder<AssignmentTable>? orderByList,
    AssignmentInclude? include,
  }) {
    return AssignmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Assignment.t),
      orderByList: orderByList?.call(Assignment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssignmentImpl extends Assignment {
  _AssignmentImpl({
    int? id,
    required int incidentId,
    required int responderId,
    required _ikrvejjw.AssignmentStatus status,
    required int offeredAtLevel,
    DateTime? offeredAt,
    DateTime? respondedAt,
    int? etaMinutes,
  }) : super._(
         id: id,
         incidentId: incidentId,
         responderId: responderId,
         status: status,
         offeredAtLevel: offeredAtLevel,
         offeredAt: offeredAt,
         respondedAt: respondedAt,
         etaMinutes: etaMinutes,
       );

  /// Returns a shallow copy of this [Assignment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Assignment copyWith({
    Object? id = _Undefined,
    int? incidentId,
    int? responderId,
    _ikrvejjw.AssignmentStatus? status,
    int? offeredAtLevel,
    DateTime? offeredAt,
    Object? respondedAt = _Undefined,
    Object? etaMinutes = _Undefined,
  }) {
    return Assignment(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      responderId: responderId ?? this.responderId,
      status: status ?? this.status,
      offeredAtLevel: offeredAtLevel ?? this.offeredAtLevel,
      offeredAt: offeredAt ?? this.offeredAt,
      respondedAt: respondedAt is DateTime? ? respondedAt : this.respondedAt,
      etaMinutes: etaMinutes is int? ? etaMinutes : this.etaMinutes,
    );
  }
}

class AssignmentUpdateTable extends _is.UpdateTable<AssignmentTable> {
  AssignmentUpdateTable(super.table);

  _is.ColumnValue<int, int> incidentId(int value) => _is.ColumnValue(
    table.incidentId,
    value,
  );

  _is.ColumnValue<int, int> responderId(int value) => _is.ColumnValue(
    table.responderId,
    value,
  );

  _is.ColumnValue<_ikrvejjw.AssignmentStatus, _ikrvejjw.AssignmentStatus>
  status(_ikrvejjw.AssignmentStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> offeredAtLevel(int value) => _is.ColumnValue(
    table.offeredAtLevel,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> offeredAt(DateTime value) =>
      _is.ColumnValue(
        table.offeredAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> respondedAt(DateTime? value) =>
      _is.ColumnValue(
        table.respondedAt,
        value,
      );

  _is.ColumnValue<int, int> etaMinutes(int? value) => _is.ColumnValue(
    table.etaMinutes,
    value,
  );
}

class AssignmentTable extends _is.Table<int?> {
  AssignmentTable({super.tableRelation}) : super(tableName: 'assignment') {
    updateTable = AssignmentUpdateTable(this);
    incidentId = _is.ColumnInt(
      'incidentId',
      this,
    );
    responderId = _is.ColumnInt(
      'responderId',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    offeredAtLevel = _is.ColumnInt(
      'offeredAtLevel',
      this,
    );
    offeredAt = _is.ColumnDateTime(
      'offeredAt',
      this,
      hasDefault: true,
    );
    respondedAt = _is.ColumnDateTime(
      'respondedAt',
      this,
    );
    etaMinutes = _is.ColumnInt(
      'etaMinutes',
      this,
    );
  }

  late final AssignmentUpdateTable updateTable;

  late final _is.ColumnInt incidentId;

  late final _is.ColumnInt responderId;

  late final _is.ColumnEnum<_ikrvejjw.AssignmentStatus> status;

  late final _is.ColumnInt offeredAtLevel;

  late final _is.ColumnDateTime offeredAt;

  late final _is.ColumnDateTime respondedAt;

  late final _is.ColumnInt etaMinutes;

  @override
  List<_is.Column> get columns => [
    id,
    incidentId,
    responderId,
    status,
    offeredAtLevel,
    offeredAt,
    respondedAt,
    etaMinutes,
  ];
}

class AssignmentInclude extends _is.IncludeObject {
  AssignmentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Assignment.t;
}

class AssignmentIncludeList extends _is.IncludeList {
  AssignmentIncludeList._({
    _is.WhereExpressionBuilder<AssignmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Assignment.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Assignment.t;
}

class AssignmentRepository {
  const AssignmentRepository._();

  /// Returns a list of [Assignment]s matching the given query parameters.
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
  Future<List<Assignment>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AssignmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AssignmentTable>? orderBy,
    _is.OrderByListBuilder<AssignmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Assignment>(
      where: where?.call(Assignment.t),
      orderBy: orderBy?.call(Assignment.t),
      orderByList: orderByList?.call(Assignment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Assignment] matching the given query parameters.
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
  Future<Assignment?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AssignmentTable>? where,
    int? offset,
    _is.OrderByBuilder<AssignmentTable>? orderBy,
    _is.OrderByListBuilder<AssignmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Assignment>(
      where: where?.call(Assignment.t),
      orderBy: orderBy?.call(Assignment.t),
      orderByList: orderByList?.call(Assignment.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Assignment] by its [id] or null if no such row exists.
  Future<Assignment?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Assignment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Assignment]s in the list and returns the inserted rows.
  ///
  /// The returned [Assignment]s will have their `id` fields set.
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
  Future<List<Assignment>> insert(
    _is.DatabaseSession session,
    List<Assignment> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Assignment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Assignment] and returns the inserted row.
  ///
  /// The returned [Assignment] will have its `id` field set.
  Future<Assignment> insertRow(
    _is.DatabaseSession session,
    Assignment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Assignment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Assignment]s in the list and returns the resulting rows.
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
  /// The returned [Assignment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Assignment>> upsert(
    _is.DatabaseSession session,
    List<Assignment> rows, {
    required _is.ColumnSelections<AssignmentTable> conflictColumns,
    _is.ColumnSelections<AssignmentTable>? updateColumns,
    _is.WhereExpressionBuilder<AssignmentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Assignment>(
      rows,
      conflictColumns: conflictColumns(Assignment.t),
      updateColumns: updateColumns?.call(Assignment.t),
      updateWhere: updateWhere?.call(Assignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Assignment] and returns the resulting row.
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
  /// The returned [Assignment] will have its `id` field set.
  Future<Assignment?> upsertRow(
    _is.DatabaseSession session,
    Assignment row, {
    required _is.ColumnSelections<AssignmentTable> conflictColumns,
    _is.ColumnSelections<AssignmentTable>? updateColumns,
    _is.WhereExpressionBuilder<AssignmentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Assignment>(
      row,
      conflictColumns: conflictColumns(Assignment.t),
      updateColumns: updateColumns?.call(Assignment.t),
      updateWhere: updateWhere?.call(Assignment.t),
      transaction: transaction,
    );
  }

  /// Updates all [Assignment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Assignment>> update(
    _is.DatabaseSession session,
    List<Assignment> rows, {
    _is.ColumnSelections<AssignmentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Assignment>(
      rows,
      columns: columns?.call(Assignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Assignment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Assignment> updateRow(
    _is.DatabaseSession session,
    Assignment row, {
    _is.ColumnSelections<AssignmentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Assignment>(
      row,
      columns: columns?.call(Assignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Assignment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Assignment?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AssignmentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Assignment>(
      id,
      columnValues: columnValues(Assignment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Assignment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Assignment>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AssignmentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AssignmentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AssignmentTable>? orderBy,
    _is.OrderByListBuilder<AssignmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Assignment>(
      columnValues: columnValues(Assignment.t.updateTable),
      where: where(Assignment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Assignment.t),
      orderByList: orderByList?.call(Assignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Assignment]s in the list and returns the deleted rows.
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
  Future<List<Assignment>> delete(
    _is.DatabaseSession session,
    List<Assignment> rows, {
    _is.OrderByBuilder<AssignmentTable>? orderBy,
    _is.OrderByListBuilder<AssignmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Assignment>(
      rows,
      orderBy: orderBy?.call(Assignment.t),
      orderByList: orderByList?.call(Assignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Assignment].
  Future<Assignment> deleteRow(
    _is.DatabaseSession session,
    Assignment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Assignment>(
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
  Future<List<Assignment>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AssignmentTable> where,
    _is.OrderByBuilder<AssignmentTable>? orderBy,
    _is.OrderByListBuilder<AssignmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Assignment>(
      where: where(Assignment.t),
      orderBy: orderBy?.call(Assignment.t),
      orderByList: orderByList?.call(Assignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AssignmentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Assignment>(
      where: where?.call(Assignment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Assignment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AssignmentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Assignment>(
      where: where(Assignment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
