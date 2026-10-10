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
import 'package:relief_radar_server/src/generated/protocol.dart' as _i78gox42;
import 'package:serverpod/serverpod.dart' as _is;
import 'need_type.dart' as _iq4zvdzd;
import 'responder_status.dart' as _ivpp8a10;

abstract class Responder
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Responder._({
    this.id,
    required this.authUserId,
    required this.displayName,
    required this.capabilities,
    int? capacity,
    required this.status,
    this.location,
    this.lastSeenAt,
  }) : capacity = capacity ?? 1;

  factory Responder({
    int? id,
    required _is.UuidValue authUserId,
    required String displayName,
    required List<_iq4zvdzd.NeedType> capabilities,
    int? capacity,
    required _ivpp8a10.ResponderStatus status,
    _is.GeographyPoint? location,
    DateTime? lastSeenAt,
  }) = _ResponderImpl;

  factory Responder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Responder(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      capabilities: _i78gox42.Protocol().deserialize<List<_iq4zvdzd.NeedType>>(
        jsonSerialization['capabilities'],
      ),
      capacity: jsonSerialization['capacity'] as int?,
      status: _ivpp8a10.ResponderStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      location: jsonSerialization['location'] == null
          ? null
          : _is.GeographyPointJsonExtension.fromJson(
              jsonSerialization['location'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
    );
  }

  static final t = ResponderTable();

  static const db = ResponderRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String displayName;

  List<_iq4zvdzd.NeedType> capabilities;

  int capacity;

  _ivpp8a10.ResponderStatus status;

  _is.GeographyPoint? location;

  DateTime? lastSeenAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Responder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Responder copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? displayName,
    List<_iq4zvdzd.NeedType>? capabilities,
    int? capacity,
    _ivpp8a10.ResponderStatus? status,
    _is.GeographyPoint? location,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Responder',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'capabilities': capabilities.toJson(valueToJson: (v) => v.toJson()),
      'capacity': capacity,
      'status': status.toJson(),
      if (location != null) 'location': location?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Responder',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'capabilities': capabilities.toJson(valueToJson: (v) => v.toJson()),
      'capacity': capacity,
      'status': status.toJson(),
      if (location != null) 'location': location?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  static ResponderInclude include() {
    return ResponderInclude._();
  }

  static ResponderIncludeList includeList({
    _is.WhereExpressionBuilder<ResponderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResponderTable>? orderBy,
    _is.OrderByListBuilder<ResponderTable>? orderByList,
    ResponderInclude? include,
  }) {
    return ResponderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Responder.t),
      orderByList: orderByList?.call(Responder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderImpl extends Responder {
  _ResponderImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String displayName,
    required List<_iq4zvdzd.NeedType> capabilities,
    int? capacity,
    required _ivpp8a10.ResponderStatus status,
    _is.GeographyPoint? location,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         capabilities: capabilities,
         capacity: capacity,
         status: status,
         location: location,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [Responder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Responder copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? displayName,
    List<_iq4zvdzd.NeedType>? capabilities,
    int? capacity,
    _ivpp8a10.ResponderStatus? status,
    Object? location = _Undefined,
    Object? lastSeenAt = _Undefined,
  }) {
    return Responder(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      capabilities: capabilities ?? this.capabilities.map((e0) => e0).toList(),
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      location: location is _is.GeographyPoint? ? location : this.location,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
    );
  }
}

class ResponderUpdateTable extends _is.UpdateTable<ResponderTable> {
  ResponderUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<List<_iq4zvdzd.NeedType>, List<_iq4zvdzd.NeedType>>
  capabilities(List<_iq4zvdzd.NeedType> value) => _is.ColumnValue(
    table.capabilities,
    value,
  );

  _is.ColumnValue<int, int> capacity(int value) => _is.ColumnValue(
    table.capacity,
    value,
  );

  _is.ColumnValue<_ivpp8a10.ResponderStatus, _ivpp8a10.ResponderStatus> status(
    _ivpp8a10.ResponderStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> location(
    _is.GeographyPoint? value,
  ) => _is.ColumnValue(
    table.location,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );
}

class ResponderTable extends _is.Table<int?> {
  ResponderTable({super.tableRelation}) : super(tableName: 'responder') {
    updateTable = ResponderUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    capabilities = _is.ColumnSerializable<List<_iq4zvdzd.NeedType>>(
      'capabilities',
      this,
    );
    capacity = _is.ColumnInt(
      'capacity',
      this,
      hasDefault: true,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    location = _is.ColumnGeographyPoint(
      'location',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
    );
  }

  late final ResponderUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString displayName;

  late final _is.ColumnSerializable<List<_iq4zvdzd.NeedType>> capabilities;

  late final _is.ColumnInt capacity;

  late final _is.ColumnEnum<_ivpp8a10.ResponderStatus> status;

  late final _is.ColumnGeographyPoint location;

  late final _is.ColumnDateTime lastSeenAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    displayName,
    capabilities,
    capacity,
    status,
    location,
    lastSeenAt,
  ];
}

class ResponderInclude extends _is.IncludeObject {
  ResponderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Responder.t;
}

class ResponderIncludeList extends _is.IncludeList {
  ResponderIncludeList._({
    _is.WhereExpressionBuilder<ResponderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Responder.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Responder.t;
}

class ResponderRepository {
  const ResponderRepository._();

  /// Returns a list of [Responder]s matching the given query parameters.
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
  Future<List<Responder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResponderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResponderTable>? orderBy,
    _is.OrderByListBuilder<ResponderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Responder>(
      where: where?.call(Responder.t),
      orderBy: orderBy?.call(Responder.t),
      orderByList: orderByList?.call(Responder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Responder] matching the given query parameters.
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
  Future<Responder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResponderTable>? where,
    int? offset,
    _is.OrderByBuilder<ResponderTable>? orderBy,
    _is.OrderByListBuilder<ResponderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Responder>(
      where: where?.call(Responder.t),
      orderBy: orderBy?.call(Responder.t),
      orderByList: orderByList?.call(Responder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Responder] by its [id] or null if no such row exists.
  Future<Responder?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Responder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Responder]s in the list and returns the inserted rows.
  ///
  /// The returned [Responder]s will have their `id` fields set.
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
  Future<List<Responder>> insert(
    _is.DatabaseSession session,
    List<Responder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Responder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Responder] and returns the inserted row.
  ///
  /// The returned [Responder] will have its `id` field set.
  Future<Responder> insertRow(
    _is.DatabaseSession session,
    Responder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Responder>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Responder]s in the list and returns the resulting rows.
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
  /// The returned [Responder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Responder>> upsert(
    _is.DatabaseSession session,
    List<Responder> rows, {
    required _is.ColumnSelections<ResponderTable> conflictColumns,
    _is.ColumnSelections<ResponderTable>? updateColumns,
    _is.WhereExpressionBuilder<ResponderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Responder>(
      rows,
      conflictColumns: conflictColumns(Responder.t),
      updateColumns: updateColumns?.call(Responder.t),
      updateWhere: updateWhere?.call(Responder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Responder] and returns the resulting row.
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
  /// The returned [Responder] will have its `id` field set.
  Future<Responder?> upsertRow(
    _is.DatabaseSession session,
    Responder row, {
    required _is.ColumnSelections<ResponderTable> conflictColumns,
    _is.ColumnSelections<ResponderTable>? updateColumns,
    _is.WhereExpressionBuilder<ResponderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Responder>(
      row,
      conflictColumns: conflictColumns(Responder.t),
      updateColumns: updateColumns?.call(Responder.t),
      updateWhere: updateWhere?.call(Responder.t),
      transaction: transaction,
    );
  }

  /// Updates all [Responder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Responder>> update(
    _is.DatabaseSession session,
    List<Responder> rows, {
    _is.ColumnSelections<ResponderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Responder>(
      rows,
      columns: columns?.call(Responder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Responder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Responder> updateRow(
    _is.DatabaseSession session,
    Responder row, {
    _is.ColumnSelections<ResponderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Responder>(
      row,
      columns: columns?.call(Responder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Responder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Responder?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ResponderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Responder>(
      id,
      columnValues: columnValues(Responder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Responder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Responder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ResponderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ResponderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResponderTable>? orderBy,
    _is.OrderByListBuilder<ResponderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Responder>(
      columnValues: columnValues(Responder.t.updateTable),
      where: where(Responder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Responder.t),
      orderByList: orderByList?.call(Responder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Responder]s in the list and returns the deleted rows.
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
  Future<List<Responder>> delete(
    _is.DatabaseSession session,
    List<Responder> rows, {
    _is.OrderByBuilder<ResponderTable>? orderBy,
    _is.OrderByListBuilder<ResponderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Responder>(
      rows,
      orderBy: orderBy?.call(Responder.t),
      orderByList: orderByList?.call(Responder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Responder].
  Future<Responder> deleteRow(
    _is.DatabaseSession session,
    Responder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Responder>(
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
  Future<List<Responder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResponderTable> where,
    _is.OrderByBuilder<ResponderTable>? orderBy,
    _is.OrderByListBuilder<ResponderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Responder>(
      where: where(Responder.t),
      orderBy: orderBy?.call(Responder.t),
      orderByList: orderByList?.call(Responder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResponderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Responder>(
      where: where?.call(Responder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Responder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResponderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Responder>(
      where: where(Responder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
