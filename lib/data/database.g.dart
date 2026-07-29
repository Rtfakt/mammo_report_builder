// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SavedReportsTable extends SavedReports
    with TableInfo<$SavedReportsTable, SavedReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _examJsonMeta = const VerificationMeta(
    'examJson',
  );
  @override
  late final GeneratedColumn<String> examJson = GeneratedColumn<String>(
    'exam_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullTextMeta = const VerificationMeta(
    'fullText',
  );
  @override
  late final GeneratedColumn<String> fullText = GeneratedColumn<String>(
    'full_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionTextMeta = const VerificationMeta(
    'descriptionText',
  );
  @override
  late final GeneratedColumn<String> descriptionText = GeneratedColumn<String>(
    'description_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conclusionTextMeta = const VerificationMeta(
    'conclusionText',
  );
  @override
  late final GeneratedColumn<String> conclusionText = GeneratedColumn<String>(
    'conclusion_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    examJson,
    fullText,
    descriptionText,
    conclusionText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('exam_json')) {
      context.handle(
        _examJsonMeta,
        examJson.isAcceptableOrUnknown(data['exam_json']!, _examJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_examJsonMeta);
    }
    if (data.containsKey('full_text')) {
      context.handle(
        _fullTextMeta,
        fullText.isAcceptableOrUnknown(data['full_text']!, _fullTextMeta),
      );
    } else if (isInserting) {
      context.missing(_fullTextMeta);
    }
    if (data.containsKey('description_text')) {
      context.handle(
        _descriptionTextMeta,
        descriptionText.isAcceptableOrUnknown(
          data['description_text']!,
          _descriptionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionTextMeta);
    }
    if (data.containsKey('conclusion_text')) {
      context.handle(
        _conclusionTextMeta,
        conclusionText.isAcceptableOrUnknown(
          data['conclusion_text']!,
          _conclusionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conclusionTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      examJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_json'],
      )!,
      fullText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_text'],
      )!,
      descriptionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_text'],
      )!,
      conclusionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conclusion_text'],
      )!,
    );
  }

  @override
  $SavedReportsTable createAlias(String alias) {
    return $SavedReportsTable(attachedDatabase, alias);
  }
}

class SavedReport extends DataClass implements Insertable<SavedReport> {
  final int id;
  final DateTime createdAt;
  final String examJson;
  final String fullText;
  final String descriptionText;
  final String conclusionText;
  const SavedReport({
    required this.id,
    required this.createdAt,
    required this.examJson,
    required this.fullText,
    required this.descriptionText,
    required this.conclusionText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['exam_json'] = Variable<String>(examJson);
    map['full_text'] = Variable<String>(fullText);
    map['description_text'] = Variable<String>(descriptionText);
    map['conclusion_text'] = Variable<String>(conclusionText);
    return map;
  }

  SavedReportsCompanion toCompanion(bool nullToAbsent) {
    return SavedReportsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      examJson: Value(examJson),
      fullText: Value(fullText),
      descriptionText: Value(descriptionText),
      conclusionText: Value(conclusionText),
    );
  }

  factory SavedReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedReport(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      examJson: serializer.fromJson<String>(json['examJson']),
      fullText: serializer.fromJson<String>(json['fullText']),
      descriptionText: serializer.fromJson<String>(json['descriptionText']),
      conclusionText: serializer.fromJson<String>(json['conclusionText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'examJson': serializer.toJson<String>(examJson),
      'fullText': serializer.toJson<String>(fullText),
      'descriptionText': serializer.toJson<String>(descriptionText),
      'conclusionText': serializer.toJson<String>(conclusionText),
    };
  }

  SavedReport copyWith({
    int? id,
    DateTime? createdAt,
    String? examJson,
    String? fullText,
    String? descriptionText,
    String? conclusionText,
  }) => SavedReport(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    examJson: examJson ?? this.examJson,
    fullText: fullText ?? this.fullText,
    descriptionText: descriptionText ?? this.descriptionText,
    conclusionText: conclusionText ?? this.conclusionText,
  );
  SavedReport copyWithCompanion(SavedReportsCompanion data) {
    return SavedReport(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      examJson: data.examJson.present ? data.examJson.value : this.examJson,
      fullText: data.fullText.present ? data.fullText.value : this.fullText,
      descriptionText: data.descriptionText.present
          ? data.descriptionText.value
          : this.descriptionText,
      conclusionText: data.conclusionText.present
          ? data.conclusionText.value
          : this.conclusionText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedReport(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('examJson: $examJson, ')
          ..write('fullText: $fullText, ')
          ..write('descriptionText: $descriptionText, ')
          ..write('conclusionText: $conclusionText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    examJson,
    fullText,
    descriptionText,
    conclusionText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedReport &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.examJson == this.examJson &&
          other.fullText == this.fullText &&
          other.descriptionText == this.descriptionText &&
          other.conclusionText == this.conclusionText);
}

class SavedReportsCompanion extends UpdateCompanion<SavedReport> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> examJson;
  final Value<String> fullText;
  final Value<String> descriptionText;
  final Value<String> conclusionText;
  const SavedReportsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.examJson = const Value.absent(),
    this.fullText = const Value.absent(),
    this.descriptionText = const Value.absent(),
    this.conclusionText = const Value.absent(),
  });
  SavedReportsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String examJson,
    required String fullText,
    required String descriptionText,
    required String conclusionText,
  }) : examJson = Value(examJson),
       fullText = Value(fullText),
       descriptionText = Value(descriptionText),
       conclusionText = Value(conclusionText);
  static Insertable<SavedReport> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? examJson,
    Expression<String>? fullText,
    Expression<String>? descriptionText,
    Expression<String>? conclusionText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (examJson != null) 'exam_json': examJson,
      if (fullText != null) 'full_text': fullText,
      if (descriptionText != null) 'description_text': descriptionText,
      if (conclusionText != null) 'conclusion_text': conclusionText,
    });
  }

  SavedReportsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String>? examJson,
    Value<String>? fullText,
    Value<String>? descriptionText,
    Value<String>? conclusionText,
  }) {
    return SavedReportsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      examJson: examJson ?? this.examJson,
      fullText: fullText ?? this.fullText,
      descriptionText: descriptionText ?? this.descriptionText,
      conclusionText: conclusionText ?? this.conclusionText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (examJson.present) {
      map['exam_json'] = Variable<String>(examJson.value);
    }
    if (fullText.present) {
      map['full_text'] = Variable<String>(fullText.value);
    }
    if (descriptionText.present) {
      map['description_text'] = Variable<String>(descriptionText.value);
    }
    if (conclusionText.present) {
      map['conclusion_text'] = Variable<String>(conclusionText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedReportsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('examJson: $examJson, ')
          ..write('fullText: $fullText, ')
          ..write('descriptionText: $descriptionText, ')
          ..write('conclusionText: $conclusionText')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedReportsTable savedReports = $SavedReportsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedReports];
}

typedef $$SavedReportsTableCreateCompanionBuilder =
    SavedReportsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      required String examJson,
      required String fullText,
      required String descriptionText,
      required String conclusionText,
    });
typedef $$SavedReportsTableUpdateCompanionBuilder =
    SavedReportsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String> examJson,
      Value<String> fullText,
      Value<String> descriptionText,
      Value<String> conclusionText,
    });

class $$SavedReportsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedReportsTable> {
  $$SavedReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examJson => $composableBuilder(
    column: $table.examJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullText => $composableBuilder(
    column: $table.fullText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionText => $composableBuilder(
    column: $table.descriptionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conclusionText => $composableBuilder(
    column: $table.conclusionText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedReportsTable> {
  $$SavedReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examJson => $composableBuilder(
    column: $table.examJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullText => $composableBuilder(
    column: $table.fullText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionText => $composableBuilder(
    column: $table.descriptionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conclusionText => $composableBuilder(
    column: $table.conclusionText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedReportsTable> {
  $$SavedReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get examJson =>
      $composableBuilder(column: $table.examJson, builder: (column) => column);

  GeneratedColumn<String> get fullText =>
      $composableBuilder(column: $table.fullText, builder: (column) => column);

  GeneratedColumn<String> get descriptionText => $composableBuilder(
    column: $table.descriptionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conclusionText => $composableBuilder(
    column: $table.conclusionText,
    builder: (column) => column,
  );
}

class $$SavedReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedReportsTable,
          SavedReport,
          $$SavedReportsTableFilterComposer,
          $$SavedReportsTableOrderingComposer,
          $$SavedReportsTableAnnotationComposer,
          $$SavedReportsTableCreateCompanionBuilder,
          $$SavedReportsTableUpdateCompanionBuilder,
          (
            SavedReport,
            BaseReferences<_$AppDatabase, $SavedReportsTable, SavedReport>,
          ),
          SavedReport,
          PrefetchHooks Function()
        > {
  $$SavedReportsTableTableManager(_$AppDatabase db, $SavedReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> examJson = const Value.absent(),
                Value<String> fullText = const Value.absent(),
                Value<String> descriptionText = const Value.absent(),
                Value<String> conclusionText = const Value.absent(),
              }) => SavedReportsCompanion(
                id: id,
                createdAt: createdAt,
                examJson: examJson,
                fullText: fullText,
                descriptionText: descriptionText,
                conclusionText: conclusionText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String examJson,
                required String fullText,
                required String descriptionText,
                required String conclusionText,
              }) => SavedReportsCompanion.insert(
                id: id,
                createdAt: createdAt,
                examJson: examJson,
                fullText: fullText,
                descriptionText: descriptionText,
                conclusionText: conclusionText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedReportsTable,
      SavedReport,
      $$SavedReportsTableFilterComposer,
      $$SavedReportsTableOrderingComposer,
      $$SavedReportsTableAnnotationComposer,
      $$SavedReportsTableCreateCompanionBuilder,
      $$SavedReportsTableUpdateCompanionBuilder,
      (
        SavedReport,
        BaseReferences<_$AppDatabase, $SavedReportsTable, SavedReport>,
      ),
      SavedReport,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedReportsTableTableManager get savedReports =>
      $$SavedReportsTableTableManager(_db, _db.savedReports);
}
