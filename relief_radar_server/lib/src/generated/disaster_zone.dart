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

abstract class DisasterZone
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DisasterZone._({
    this.id,
    required this.name,
    required this.kind,
    required this.center,
    this.bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) : active = active ?? true,
       timeScale = timeScale ?? 1.0,
       createdAt = createdAt ?? DateTime.now();

  factory DisasterZone({
    int? id,
    required String name,
    required String kind,
    required _is.GeographyPoint center,
    _is.GeographyPolygon? bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) = _DisasterZoneImpl;

  factory DisasterZone.fromJson(Map<String, dynamic> jsonSerialization) {
    return DisasterZone(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      kind: jsonSerialization['kind'] as String,
      center: _is.GeographyPointJsonExtension.fromJson(
        jsonSerialization['center'],
      ),
      bounds: jsonSerialization['bounds'] == null
          ? null
          : _is.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['bounds'],
            ),
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
      timeScale: (jsonSerialization['timeScale'] as num?)?.toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DisasterZoneTable();

  static const db = DisasterZoneRepository._();

  @override
  int? id;

  String name;

  String kind;

  _is.GeographyPoint center;

  _is.GeographyPolygon? bounds;

  bool active;

  double timeScale;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DisasterZone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DisasterZone copyWith({
    int? id,
    String? name,
    String? kind,
    _is.GeographyPoint? center,
    _is.GeographyPolygon? bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DisasterZone',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'center': center.toJson(),
      if (bounds != null) 'bounds': bounds?.toJson(),
      'active': active,
      'timeScale': timeScale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DisasterZone',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'center': center.toJson(),
      if (bounds != null) 'bounds': bounds?.toJson(),
      'active': active,
      'timeScale': timeScale,
      'createdAt': createdAt.toJson(),
    };
  }

  static DisasterZoneInclude include() {
    return DisasterZoneInclude._();
  }

  static DisasterZoneIncludeList includeList({
    _is.WhereExpressionBuilder<DisasterZoneTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DisasterZoneTable>? orderBy,
    _is.OrderByListBuilder<DisasterZoneTable>? orderByList,
    DisasterZoneInclude? include,
  }) {
    return DisasterZoneIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DisasterZone.t),
      orderByList: orderByList?.call(DisasterZone.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DisasterZoneImpl extends DisasterZone {
  _DisasterZoneImpl({
    int? id,
    required String name,
    required String kind,
    required _is.GeographyPoint center,
    _is.GeographyPolygon? bounds,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         kind: kind,
         center: center,
         bounds: bounds,
         active: active,
         timeScale: timeScale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DisasterZone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DisasterZone copyWith({
    Object? id = _Undefined,
    String? name,
    String? kind,
    _is.GeographyPoint? center,
    Object? bounds = _Undefined,
    bool? active,
    double? timeScale,
    DateTime? createdAt,
  }) {
    return DisasterZone(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      center: center ?? this.center,
      bounds: bounds is _is.GeographyPolygon? ? bounds : this.bounds,
      active: active ?? this.active,
      timeScale: timeScale ?? this.timeScale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DisasterZoneUpdateTable extends _is.UpdateTable<DisasterZoneTable> {
  DisasterZoneUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> center(
    _is.GeographyPoint value,
  ) => _is.ColumnValue(
    table.center,
    value,
  );

  _is.ColumnValue<_is.GeographyPolygon, _is.GeographyPolygon> bounds(
    _is.GeographyPolygon? value,
  ) => _is.ColumnValue(
    table.bounds,
    value,
  );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );

  _is.ColumnValue<double, double> timeScale(double value) => _is.ColumnValue(
    table.timeScale,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DisasterZoneTable extends _is.Table<int?> {
  DisasterZoneTable({super.tableRelation}) : super(tableName: 'disaster_zone') {
    updateTable = DisasterZoneUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    center = _is.ColumnGeographyPoint(
      'center',
      this,
    );
    bounds = _is.ColumnGeographyPolygon(
      'bounds',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
    timeScale = _is.ColumnDouble(
      'timeScale',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final DisasterZoneUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString kind;

  late final _is.ColumnGeographyPoint center;

  late final _is.ColumnGeographyPolygon bounds;

  late final _is.ColumnBool active;

  late final _is.ColumnDouble timeScale;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    kind,
    center,
    bounds,
    active,
    timeScale,
    createdAt,
  ];
}

class DisasterZoneInclude extends _is.IncludeObject {
  DisasterZoneInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DisasterZone.t;
}

class DisasterZoneIncludeList extends _is.IncludeList {
  DisasterZoneIncludeList._({
    _is.WhereExpressionBuilder<DisasterZoneTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DisasterZone.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DisasterZone.t;
}

class DisasterZoneRepository {
  const DisasterZoneRepository._();

  /// Returns a list of [DisasterZone]s matching the given query parameters.
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
  Future<List<DisasterZone>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DisasterZoneTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DisasterZoneTable>? orderBy,
    _is.OrderByListBuilder<DisasterZoneTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DisasterZone>(
      where: where?.call(DisasterZone.t),
      orderBy: orderBy?.call(DisasterZone.t),
      orderByList: orderByList?.call(DisasterZone.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DisasterZone] matching the given query parameters.
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
  Future<DisasterZone?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DisasterZoneTable>? where,
    int? offset,
    _is.OrderByBuilder<DisasterZoneTable>? orderBy,
    _is.OrderByListBuilder<DisasterZoneTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DisasterZone>(
      where: where?.call(DisasterZone.t),
      orderBy: orderBy?.call(DisasterZone.t),
      orderByList: orderByList?.call(DisasterZone.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DisasterZone] by its [id] or null if no such row exists.
  Future<DisasterZone?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DisasterZone>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DisasterZone]s in the list and returns the inserted rows.
  ///
  /// The returned [DisasterZone]s will have their `id` fields set.
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
  Future<List<DisasterZone>> insert(
    _is.DatabaseSession session,
    List<DisasterZone> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DisasterZone>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DisasterZone] and returns the inserted row.
  ///
  /// The returned [DisasterZone] will have its `id` field set.
  Future<DisasterZone> insertRow(
    _is.DatabaseSession session,
    DisasterZone row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DisasterZone>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DisasterZone]s in the list and returns the resulting rows.
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
  /// The returned [DisasterZone]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DisasterZone>> upsert(
    _is.DatabaseSession session,
    List<DisasterZone> rows, {
    required _is.ColumnSelections<DisasterZoneTable> conflictColumns,
    _is.ColumnSelections<DisasterZoneTable>? updateColumns,
    _is.WhereExpressionBuilder<DisasterZoneTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DisasterZone>(
      rows,
      conflictColumns: conflictColumns(DisasterZone.t),
      updateColumns: updateColumns?.call(DisasterZone.t),
      updateWhere: updateWhere?.call(DisasterZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DisasterZone] and returns the resulting row.
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
  /// The returned [DisasterZone] will have its `id` field set.
  Future<DisasterZone?> upsertRow(
    _is.DatabaseSession session,
    DisasterZone row, {
    required _is.ColumnSelections<DisasterZoneTable> conflictColumns,
    _is.ColumnSelections<DisasterZoneTable>? updateColumns,
    _is.WhereExpressionBuilder<DisasterZoneTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DisasterZone>(
      row,
      conflictColumns: conflictColumns(DisasterZone.t),
      updateColumns: updateColumns?.call(DisasterZone.t),
      updateWhere: updateWhere?.call(DisasterZone.t),
      transaction: transaction,
    );
  }

  /// Updates all [DisasterZone]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DisasterZone>> update(
    _is.DatabaseSession session,
    List<DisasterZone> rows, {
    _is.ColumnSelections<DisasterZoneTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DisasterZone>(
      rows,
      columns: columns?.call(DisasterZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DisasterZone]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DisasterZone> updateRow(
    _is.DatabaseSession session,
    DisasterZone row, {
    _is.ColumnSelections<DisasterZoneTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DisasterZone>(
      row,
      columns: columns?.call(DisasterZone.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DisasterZone] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DisasterZone?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DisasterZoneUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DisasterZone>(
      id,
      columnValues: columnValues(DisasterZone.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DisasterZone]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DisasterZone>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DisasterZoneUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DisasterZoneTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DisasterZoneTable>? orderBy,
    _is.OrderByListBuilder<DisasterZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DisasterZone>(
      columnValues: columnValues(DisasterZone.t.updateTable),
      where: where(DisasterZone.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DisasterZone.t),
      orderByList: orderByList?.call(DisasterZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DisasterZone]s in the list and returns the deleted rows.
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
  Future<List<DisasterZone>> delete(
    _is.DatabaseSession session,
    List<DisasterZone> rows, {
    _is.OrderByBuilder<DisasterZoneTable>? orderBy,
    _is.OrderByListBuilder<DisasterZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DisasterZone>(
      rows,
      orderBy: orderBy?.call(DisasterZone.t),
      orderByList: orderByList?.call(DisasterZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DisasterZone].
  Future<DisasterZone> deleteRow(
    _is.DatabaseSession session,
    DisasterZone row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DisasterZone>(
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
  Future<List<DisasterZone>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DisasterZoneTable> where,
    _is.OrderByBuilder<DisasterZoneTable>? orderBy,
    _is.OrderByListBuilder<DisasterZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DisasterZone>(
      where: where(DisasterZone.t),
      orderBy: orderBy?.call(DisasterZone.t),
      orderByList: orderByList?.call(DisasterZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DisasterZoneTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DisasterZone>(
      where: where?.call(DisasterZone.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DisasterZone] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DisasterZoneTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DisasterZone>(
      where: where(DisasterZone.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
