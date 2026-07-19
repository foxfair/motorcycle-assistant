// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MotorcyclesTable extends Motorcycles
    with TableInfo<$MotorcyclesTable, Motorcycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotorcyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
      'make', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
      'vin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nickname, make, model, year, vin, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motorcycles';
  @override
  VerificationContext validateIntegrity(Insertable<Motorcycle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
          _makeMeta, make.isAcceptableOrUnknown(data['make']!, _makeMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    }
    if (data.containsKey('vin')) {
      context.handle(
          _vinMeta, vin.isAcceptableOrUnknown(data['vin']!, _vinMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Motorcycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Motorcycle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname'])!,
      make: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}make']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      vin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vin']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $MotorcyclesTable createAlias(String alias) {
    return $MotorcyclesTable(attachedDatabase, alias);
  }
}

class Motorcycle extends DataClass implements Insertable<Motorcycle> {
  final int id;
  final String nickname;
  final String? make;
  final String? model;
  final int? year;
  final String? vin;
  final String? notes;
  const Motorcycle(
      {required this.id,
      required this.nickname,
      this.make,
      this.model,
      this.year,
      this.vin,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || make != null) {
      map['make'] = Variable<String>(make);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || vin != null) {
      map['vin'] = Variable<String>(vin);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MotorcyclesCompanion toCompanion(bool nullToAbsent) {
    return MotorcyclesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      make: make == null && nullToAbsent ? const Value.absent() : Value(make),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      vin: vin == null && nullToAbsent ? const Value.absent() : Value(vin),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Motorcycle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Motorcycle(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      make: serializer.fromJson<String?>(json['make']),
      model: serializer.fromJson<String?>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      vin: serializer.fromJson<String?>(json['vin']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String>(nickname),
      'make': serializer.toJson<String?>(make),
      'model': serializer.toJson<String?>(model),
      'year': serializer.toJson<int?>(year),
      'vin': serializer.toJson<String?>(vin),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Motorcycle copyWith(
          {int? id,
          String? nickname,
          Value<String?> make = const Value.absent(),
          Value<String?> model = const Value.absent(),
          Value<int?> year = const Value.absent(),
          Value<String?> vin = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Motorcycle(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        make: make.present ? make.value : this.make,
        model: model.present ? model.value : this.model,
        year: year.present ? year.value : this.year,
        vin: vin.present ? vin.value : this.vin,
        notes: notes.present ? notes.value : this.notes,
      );
  Motorcycle copyWithCompanion(MotorcyclesCompanion data) {
    return Motorcycle(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      vin: data.vin.present ? data.vin.value : this.vin,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Motorcycle(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('vin: $vin, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nickname, make, model, year, vin, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Motorcycle &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.make == this.make &&
          other.model == this.model &&
          other.year == this.year &&
          other.vin == this.vin &&
          other.notes == this.notes);
}

class MotorcyclesCompanion extends UpdateCompanion<Motorcycle> {
  final Value<int> id;
  final Value<String> nickname;
  final Value<String?> make;
  final Value<String?> model;
  final Value<int?> year;
  final Value<String?> vin;
  final Value<String?> notes;
  const MotorcyclesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.vin = const Value.absent(),
    this.notes = const Value.absent(),
  });
  MotorcyclesCompanion.insert({
    this.id = const Value.absent(),
    required String nickname,
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.vin = const Value.absent(),
    this.notes = const Value.absent(),
  }) : nickname = Value(nickname);
  static Insertable<Motorcycle> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<String>? make,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? vin,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (vin != null) 'vin': vin,
      if (notes != null) 'notes': notes,
    });
  }

  MotorcyclesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nickname,
      Value<String?>? make,
      Value<String?>? model,
      Value<int?>? year,
      Value<String?>? vin,
      Value<String?>? notes}) {
    return MotorcyclesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotorcyclesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('vin: $vin, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceLogsTable extends MaintenanceLogs
    with TableInfo<$MaintenanceLogsTable, MaintenanceLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _mileageMeta =
      const VerificationMeta('mileage');
  @override
  late final GeneratedColumn<int> mileage = GeneratedColumn<int>(
      'mileage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskMeta = const VerificationMeta('task');
  @override
  late final GeneratedColumn<String> task = GeneratedColumn<String>(
      'task', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextMaintenanceMileageMeta =
      const VerificationMeta('nextMaintenanceMileage');
  @override
  late final GeneratedColumn<int> nextMaintenanceMileage = GeneratedColumn<int>(
      'next_maintenance_mileage', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nextMaintenanceDateMeta =
      const VerificationMeta('nextMaintenanceDate');
  @override
  late final GeneratedColumn<DateTime> nextMaintenanceDate =
      GeneratedColumn<DateTime>('next_maintenance_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        date,
        mileage,
        task,
        notes,
        nextMaintenanceMileage,
        nextMaintenanceDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_logs';
  @override
  VerificationContext validateIntegrity(Insertable<MaintenanceLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mileage')) {
      context.handle(_mileageMeta,
          mileage.isAcceptableOrUnknown(data['mileage']!, _mileageMeta));
    } else if (isInserting) {
      context.missing(_mileageMeta);
    }
    if (data.containsKey('task')) {
      context.handle(
          _taskMeta, task.isAcceptableOrUnknown(data['task']!, _taskMeta));
    } else if (isInserting) {
      context.missing(_taskMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('next_maintenance_mileage')) {
      context.handle(
          _nextMaintenanceMileageMeta,
          nextMaintenanceMileage.isAcceptableOrUnknown(
              data['next_maintenance_mileage']!, _nextMaintenanceMileageMeta));
    }
    if (data.containsKey('next_maintenance_date')) {
      context.handle(
          _nextMaintenanceDateMeta,
          nextMaintenanceDate.isAcceptableOrUnknown(
              data['next_maintenance_date']!, _nextMaintenanceDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      mileage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mileage'])!,
      task: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      nextMaintenanceMileage: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}next_maintenance_mileage']),
      nextMaintenanceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}next_maintenance_date']),
    );
  }

  @override
  $MaintenanceLogsTable createAlias(String alias) {
    return $MaintenanceLogsTable(attachedDatabase, alias);
  }
}

class MaintenanceLog extends DataClass implements Insertable<MaintenanceLog> {
  final int id;
  final int motorcycleId;
  final DateTime date;
  final int mileage;
  final String task;
  final String? notes;
  final int? nextMaintenanceMileage;
  final DateTime? nextMaintenanceDate;
  const MaintenanceLog(
      {required this.id,
      required this.motorcycleId,
      required this.date,
      required this.mileage,
      required this.task,
      this.notes,
      this.nextMaintenanceMileage,
      this.nextMaintenanceDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['date'] = Variable<DateTime>(date);
    map['mileage'] = Variable<int>(mileage);
    map['task'] = Variable<String>(task);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || nextMaintenanceMileage != null) {
      map['next_maintenance_mileage'] = Variable<int>(nextMaintenanceMileage);
    }
    if (!nullToAbsent || nextMaintenanceDate != null) {
      map['next_maintenance_date'] = Variable<DateTime>(nextMaintenanceDate);
    }
    return map;
  }

  MaintenanceLogsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceLogsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      date: Value(date),
      mileage: Value(mileage),
      task: Value(task),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      nextMaintenanceMileage: nextMaintenanceMileage == null && nullToAbsent
          ? const Value.absent()
          : Value(nextMaintenanceMileage),
      nextMaintenanceDate: nextMaintenanceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextMaintenanceDate),
    );
  }

  factory MaintenanceLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceLog(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      mileage: serializer.fromJson<int>(json['mileage']),
      task: serializer.fromJson<String>(json['task']),
      notes: serializer.fromJson<String?>(json['notes']),
      nextMaintenanceMileage:
          serializer.fromJson<int?>(json['nextMaintenanceMileage']),
      nextMaintenanceDate:
          serializer.fromJson<DateTime?>(json['nextMaintenanceDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'date': serializer.toJson<DateTime>(date),
      'mileage': serializer.toJson<int>(mileage),
      'task': serializer.toJson<String>(task),
      'notes': serializer.toJson<String?>(notes),
      'nextMaintenanceMileage': serializer.toJson<int?>(nextMaintenanceMileage),
      'nextMaintenanceDate': serializer.toJson<DateTime?>(nextMaintenanceDate),
    };
  }

  MaintenanceLog copyWith(
          {int? id,
          int? motorcycleId,
          DateTime? date,
          int? mileage,
          String? task,
          Value<String?> notes = const Value.absent(),
          Value<int?> nextMaintenanceMileage = const Value.absent(),
          Value<DateTime?> nextMaintenanceDate = const Value.absent()}) =>
      MaintenanceLog(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        date: date ?? this.date,
        mileage: mileage ?? this.mileage,
        task: task ?? this.task,
        notes: notes.present ? notes.value : this.notes,
        nextMaintenanceMileage: nextMaintenanceMileage.present
            ? nextMaintenanceMileage.value
            : this.nextMaintenanceMileage,
        nextMaintenanceDate: nextMaintenanceDate.present
            ? nextMaintenanceDate.value
            : this.nextMaintenanceDate,
      );
  MaintenanceLog copyWithCompanion(MaintenanceLogsCompanion data) {
    return MaintenanceLog(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      date: data.date.present ? data.date.value : this.date,
      mileage: data.mileage.present ? data.mileage.value : this.mileage,
      task: data.task.present ? data.task.value : this.task,
      notes: data.notes.present ? data.notes.value : this.notes,
      nextMaintenanceMileage: data.nextMaintenanceMileage.present
          ? data.nextMaintenanceMileage.value
          : this.nextMaintenanceMileage,
      nextMaintenanceDate: data.nextMaintenanceDate.present
          ? data.nextMaintenanceDate.value
          : this.nextMaintenanceDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLog(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('date: $date, ')
          ..write('mileage: $mileage, ')
          ..write('task: $task, ')
          ..write('notes: $notes, ')
          ..write('nextMaintenanceMileage: $nextMaintenanceMileage, ')
          ..write('nextMaintenanceDate: $nextMaintenanceDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, motorcycleId, date, mileage, task, notes,
      nextMaintenanceMileage, nextMaintenanceDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceLog &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.date == this.date &&
          other.mileage == this.mileage &&
          other.task == this.task &&
          other.notes == this.notes &&
          other.nextMaintenanceMileage == this.nextMaintenanceMileage &&
          other.nextMaintenanceDate == this.nextMaintenanceDate);
}

class MaintenanceLogsCompanion extends UpdateCompanion<MaintenanceLog> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<DateTime> date;
  final Value<int> mileage;
  final Value<String> task;
  final Value<String?> notes;
  final Value<int?> nextMaintenanceMileage;
  final Value<DateTime?> nextMaintenanceDate;
  const MaintenanceLogsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.date = const Value.absent(),
    this.mileage = const Value.absent(),
    this.task = const Value.absent(),
    this.notes = const Value.absent(),
    this.nextMaintenanceMileage = const Value.absent(),
    this.nextMaintenanceDate = const Value.absent(),
  });
  MaintenanceLogsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required DateTime date,
    required int mileage,
    required String task,
    this.notes = const Value.absent(),
    this.nextMaintenanceMileage = const Value.absent(),
    this.nextMaintenanceDate = const Value.absent(),
  })  : motorcycleId = Value(motorcycleId),
        date = Value(date),
        mileage = Value(mileage),
        task = Value(task);
  static Insertable<MaintenanceLog> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<DateTime>? date,
    Expression<int>? mileage,
    Expression<String>? task,
    Expression<String>? notes,
    Expression<int>? nextMaintenanceMileage,
    Expression<DateTime>? nextMaintenanceDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (date != null) 'date': date,
      if (mileage != null) 'mileage': mileage,
      if (task != null) 'task': task,
      if (notes != null) 'notes': notes,
      if (nextMaintenanceMileage != null)
        'next_maintenance_mileage': nextMaintenanceMileage,
      if (nextMaintenanceDate != null)
        'next_maintenance_date': nextMaintenanceDate,
    });
  }

  MaintenanceLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<DateTime>? date,
      Value<int>? mileage,
      Value<String>? task,
      Value<String?>? notes,
      Value<int?>? nextMaintenanceMileage,
      Value<DateTime?>? nextMaintenanceDate}) {
    return MaintenanceLogsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      date: date ?? this.date,
      mileage: mileage ?? this.mileage,
      task: task ?? this.task,
      notes: notes ?? this.notes,
      nextMaintenanceMileage:
          nextMaintenanceMileage ?? this.nextMaintenanceMileage,
      nextMaintenanceDate: nextMaintenanceDate ?? this.nextMaintenanceDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mileage.present) {
      map['mileage'] = Variable<int>(mileage.value);
    }
    if (task.present) {
      map['task'] = Variable<String>(task.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (nextMaintenanceMileage.present) {
      map['next_maintenance_mileage'] =
          Variable<int>(nextMaintenanceMileage.value);
    }
    if (nextMaintenanceDate.present) {
      map['next_maintenance_date'] =
          Variable<DateTime>(nextMaintenanceDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLogsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('date: $date, ')
          ..write('mileage: $mileage, ')
          ..write('task: $task, ')
          ..write('notes: $notes, ')
          ..write('nextMaintenanceMileage: $nextMaintenanceMileage, ')
          ..write('nextMaintenanceDate: $nextMaintenanceDate')
          ..write(')'))
        .toString();
  }
}

class $FuelLogsTable extends FuelLogs with TableInfo<$FuelLogsTable, FuelLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _mileageMeta =
      const VerificationMeta('mileage');
  @override
  late final GeneratedColumn<int> mileage = GeneratedColumn<int>(
      'mileage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pricePerUnitMeta =
      const VerificationMeta('pricePerUnit');
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
      'price_per_unit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fullTankMeta =
      const VerificationMeta('fullTank');
  @override
  late final GeneratedColumn<bool> fullTank = GeneratedColumn<bool>(
      'full_tank', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("full_tank" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, motorcycleId, date, mileage, amount, pricePerUnit, fullTank];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_logs';
  @override
  VerificationContext validateIntegrity(Insertable<FuelLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mileage')) {
      context.handle(_mileageMeta,
          mileage.isAcceptableOrUnknown(data['mileage']!, _mileageMeta));
    } else if (isInserting) {
      context.missing(_mileageMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
          _pricePerUnitMeta,
          pricePerUnit.isAcceptableOrUnknown(
              data['price_per_unit']!, _pricePerUnitMeta));
    }
    if (data.containsKey('full_tank')) {
      context.handle(_fullTankMeta,
          fullTank.isAcceptableOrUnknown(data['full_tank']!, _fullTankMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      mileage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mileage'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      pricePerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_unit']),
      fullTank: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}full_tank'])!,
    );
  }

  @override
  $FuelLogsTable createAlias(String alias) {
    return $FuelLogsTable(attachedDatabase, alias);
  }
}

class FuelLog extends DataClass implements Insertable<FuelLog> {
  final int id;
  final int motorcycleId;
  final DateTime date;
  final int mileage;
  final double amount;
  final double? pricePerUnit;
  final bool fullTank;
  const FuelLog(
      {required this.id,
      required this.motorcycleId,
      required this.date,
      required this.mileage,
      required this.amount,
      this.pricePerUnit,
      required this.fullTank});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['date'] = Variable<DateTime>(date);
    map['mileage'] = Variable<int>(mileage);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || pricePerUnit != null) {
      map['price_per_unit'] = Variable<double>(pricePerUnit);
    }
    map['full_tank'] = Variable<bool>(fullTank);
    return map;
  }

  FuelLogsCompanion toCompanion(bool nullToAbsent) {
    return FuelLogsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      date: Value(date),
      mileage: Value(mileage),
      amount: Value(amount),
      pricePerUnit: pricePerUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerUnit),
      fullTank: Value(fullTank),
    );
  }

  factory FuelLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelLog(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      mileage: serializer.fromJson<int>(json['mileage']),
      amount: serializer.fromJson<double>(json['amount']),
      pricePerUnit: serializer.fromJson<double?>(json['pricePerUnit']),
      fullTank: serializer.fromJson<bool>(json['fullTank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'date': serializer.toJson<DateTime>(date),
      'mileage': serializer.toJson<int>(mileage),
      'amount': serializer.toJson<double>(amount),
      'pricePerUnit': serializer.toJson<double?>(pricePerUnit),
      'fullTank': serializer.toJson<bool>(fullTank),
    };
  }

  FuelLog copyWith(
          {int? id,
          int? motorcycleId,
          DateTime? date,
          int? mileage,
          double? amount,
          Value<double?> pricePerUnit = const Value.absent(),
          bool? fullTank}) =>
      FuelLog(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        date: date ?? this.date,
        mileage: mileage ?? this.mileage,
        amount: amount ?? this.amount,
        pricePerUnit:
            pricePerUnit.present ? pricePerUnit.value : this.pricePerUnit,
        fullTank: fullTank ?? this.fullTank,
      );
  FuelLog copyWithCompanion(FuelLogsCompanion data) {
    return FuelLog(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      date: data.date.present ? data.date.value : this.date,
      mileage: data.mileage.present ? data.mileage.value : this.mileage,
      amount: data.amount.present ? data.amount.value : this.amount,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      fullTank: data.fullTank.present ? data.fullTank.value : this.fullTank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelLog(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('date: $date, ')
          ..write('mileage: $mileage, ')
          ..write('amount: $amount, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('fullTank: $fullTank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, motorcycleId, date, mileage, amount, pricePerUnit, fullTank);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelLog &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.date == this.date &&
          other.mileage == this.mileage &&
          other.amount == this.amount &&
          other.pricePerUnit == this.pricePerUnit &&
          other.fullTank == this.fullTank);
}

class FuelLogsCompanion extends UpdateCompanion<FuelLog> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<DateTime> date;
  final Value<int> mileage;
  final Value<double> amount;
  final Value<double?> pricePerUnit;
  final Value<bool> fullTank;
  const FuelLogsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.date = const Value.absent(),
    this.mileage = const Value.absent(),
    this.amount = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.fullTank = const Value.absent(),
  });
  FuelLogsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required DateTime date,
    required int mileage,
    required double amount,
    this.pricePerUnit = const Value.absent(),
    this.fullTank = const Value.absent(),
  })  : motorcycleId = Value(motorcycleId),
        date = Value(date),
        mileage = Value(mileage),
        amount = Value(amount);
  static Insertable<FuelLog> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<DateTime>? date,
    Expression<int>? mileage,
    Expression<double>? amount,
    Expression<double>? pricePerUnit,
    Expression<bool>? fullTank,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (date != null) 'date': date,
      if (mileage != null) 'mileage': mileage,
      if (amount != null) 'amount': amount,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (fullTank != null) 'full_tank': fullTank,
    });
  }

  FuelLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<DateTime>? date,
      Value<int>? mileage,
      Value<double>? amount,
      Value<double?>? pricePerUnit,
      Value<bool>? fullTank}) {
    return FuelLogsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      date: date ?? this.date,
      mileage: mileage ?? this.mileage,
      amount: amount ?? this.amount,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      fullTank: fullTank ?? this.fullTank,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mileage.present) {
      map['mileage'] = Variable<int>(mileage.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (fullTank.present) {
      map['full_tank'] = Variable<bool>(fullTank.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelLogsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('date: $date, ')
          ..write('mileage: $mileage, ')
          ..write('amount: $amount, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('fullTank: $fullTank')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isOemPossessedMeta =
      const VerificationMeta('isOemPossessed');
  @override
  late final GeneratedColumn<bool> isOemPossessed = GeneratedColumn<bool>(
      'is_oem_possessed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_oem_possessed" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _installedMileageMeta =
      const VerificationMeta('installedMileage');
  @override
  late final GeneratedColumn<int> installedMileage = GeneratedColumn<int>(
      'installed_mileage', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _installedDateMeta =
      const VerificationMeta('installedDate');
  @override
  late final GeneratedColumn<DateTime> installedDate =
      GeneratedColumn<DateTime>('installed_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        name,
        status,
        isOemPossessed,
        installedMileage,
        installedDate,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(Insertable<Part> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_oem_possessed')) {
      context.handle(
          _isOemPossessedMeta,
          isOemPossessed.isAcceptableOrUnknown(
              data['is_oem_possessed']!, _isOemPossessedMeta));
    }
    if (data.containsKey('installed_mileage')) {
      context.handle(
          _installedMileageMeta,
          installedMileage.isAcceptableOrUnknown(
              data['installed_mileage']!, _installedMileageMeta));
    }
    if (data.containsKey('installed_date')) {
      context.handle(
          _installedDateMeta,
          installedDate.isAcceptableOrUnknown(
              data['installed_date']!, _installedDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isOemPossessed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_oem_possessed'])!,
      installedMileage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installed_mileage']),
      installedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}installed_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class Part extends DataClass implements Insertable<Part> {
  final int id;
  final int motorcycleId;
  final String name;
  final String status;
  final bool isOemPossessed;
  final int? installedMileage;
  final DateTime? installedDate;
  final String? notes;
  const Part(
      {required this.id,
      required this.motorcycleId,
      required this.name,
      required this.status,
      required this.isOemPossessed,
      this.installedMileage,
      this.installedDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['is_oem_possessed'] = Variable<bool>(isOemPossessed);
    if (!nullToAbsent || installedMileage != null) {
      map['installed_mileage'] = Variable<int>(installedMileage);
    }
    if (!nullToAbsent || installedDate != null) {
      map['installed_date'] = Variable<DateTime>(installedDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      name: Value(name),
      status: Value(status),
      isOemPossessed: Value(isOemPossessed),
      installedMileage: installedMileage == null && nullToAbsent
          ? const Value.absent()
          : Value(installedMileage),
      installedDate: installedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(installedDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Part.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      isOemPossessed: serializer.fromJson<bool>(json['isOemPossessed']),
      installedMileage: serializer.fromJson<int?>(json['installedMileage']),
      installedDate: serializer.fromJson<DateTime?>(json['installedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'isOemPossessed': serializer.toJson<bool>(isOemPossessed),
      'installedMileage': serializer.toJson<int?>(installedMileage),
      'installedDate': serializer.toJson<DateTime?>(installedDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Part copyWith(
          {int? id,
          int? motorcycleId,
          String? name,
          String? status,
          bool? isOemPossessed,
          Value<int?> installedMileage = const Value.absent(),
          Value<DateTime?> installedDate = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Part(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        name: name ?? this.name,
        status: status ?? this.status,
        isOemPossessed: isOemPossessed ?? this.isOemPossessed,
        installedMileage: installedMileage.present
            ? installedMileage.value
            : this.installedMileage,
        installedDate:
            installedDate.present ? installedDate.value : this.installedDate,
        notes: notes.present ? notes.value : this.notes,
      );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      isOemPossessed: data.isOemPossessed.present
          ? data.isOemPossessed.value
          : this.isOemPossessed,
      installedMileage: data.installedMileage.present
          ? data.installedMileage.value
          : this.installedMileage,
      installedDate: data.installedDate.present
          ? data.installedDate.value
          : this.installedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('isOemPossessed: $isOemPossessed, ')
          ..write('installedMileage: $installedMileage, ')
          ..write('installedDate: $installedDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, motorcycleId, name, status,
      isOemPossessed, installedMileage, installedDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.name == this.name &&
          other.status == this.status &&
          other.isOemPossessed == this.isOemPossessed &&
          other.installedMileage == this.installedMileage &&
          other.installedDate == this.installedDate &&
          other.notes == this.notes);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<String> name;
  final Value<String> status;
  final Value<bool> isOemPossessed;
  final Value<int?> installedMileage;
  final Value<DateTime?> installedDate;
  final Value<String?> notes;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.isOemPossessed = const Value.absent(),
    this.installedMileage = const Value.absent(),
    this.installedDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required String name,
    required String status,
    this.isOemPossessed = const Value.absent(),
    this.installedMileage = const Value.absent(),
    this.installedDate = const Value.absent(),
    this.notes = const Value.absent(),
  })  : motorcycleId = Value(motorcycleId),
        name = Value(name),
        status = Value(status);
  static Insertable<Part> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<String>? name,
    Expression<String>? status,
    Expression<bool>? isOemPossessed,
    Expression<int>? installedMileage,
    Expression<DateTime>? installedDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (isOemPossessed != null) 'is_oem_possessed': isOemPossessed,
      if (installedMileage != null) 'installed_mileage': installedMileage,
      if (installedDate != null) 'installed_date': installedDate,
      if (notes != null) 'notes': notes,
    });
  }

  PartsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<String>? name,
      Value<String>? status,
      Value<bool>? isOemPossessed,
      Value<int?>? installedMileage,
      Value<DateTime?>? installedDate,
      Value<String?>? notes}) {
    return PartsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      name: name ?? this.name,
      status: status ?? this.status,
      isOemPossessed: isOemPossessed ?? this.isOemPossessed,
      installedMileage: installedMileage ?? this.installedMileage,
      installedDate: installedDate ?? this.installedDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isOemPossessed.present) {
      map['is_oem_possessed'] = Variable<bool>(isOemPossessed.value);
    }
    if (installedMileage.present) {
      map['installed_mileage'] = Variable<int>(installedMileage.value);
    }
    if (installedDate.present) {
      map['installed_date'] = Variable<DateTime>(installedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('isOemPossessed: $isOemPossessed, ')
          ..write('installedMileage: $installedMileage, ')
          ..write('installedDate: $installedDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MotorcyclesTable motorcycles = $MotorcyclesTable(this);
  late final $MaintenanceLogsTable maintenanceLogs =
      $MaintenanceLogsTable(this);
  late final $FuelLogsTable fuelLogs = $FuelLogsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [motorcycles, maintenanceLogs, fuelLogs, parts];
}

typedef $$MotorcyclesTableCreateCompanionBuilder = MotorcyclesCompanion
    Function({
  Value<int> id,
  required String nickname,
  Value<String?> make,
  Value<String?> model,
  Value<int?> year,
  Value<String?> vin,
  Value<String?> notes,
});
typedef $$MotorcyclesTableUpdateCompanionBuilder = MotorcyclesCompanion
    Function({
  Value<int> id,
  Value<String> nickname,
  Value<String?> make,
  Value<String?> model,
  Value<int?> year,
  Value<String?> vin,
  Value<String?> notes,
});

final class $$MotorcyclesTableReferences
    extends BaseReferences<_$AppDatabase, $MotorcyclesTable, Motorcycle> {
  $$MotorcyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaintenanceLogsTable, List<MaintenanceLog>>
      _maintenanceLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.maintenanceLogs,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.maintenanceLogs.motorcycleId));

  $$MaintenanceLogsTableProcessedTableManager get maintenanceLogsRefs {
    final manager =
        $$MaintenanceLogsTableTableManager($_db, $_db.maintenanceLogs)
            .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FuelLogsTable, List<FuelLog>> _fuelLogsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.fuelLogs,
          aliasName: $_aliasNameGenerator(
              db.motorcycles.id, db.fuelLogs.motorcycleId));

  $$FuelLogsTableProcessedTableManager get fuelLogsRefs {
    final manager = $$FuelLogsTableTableManager($_db, $_db.fuelLogs)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_fuelLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartsTable, List<Part>> _partsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.parts,
          aliasName:
              $_aliasNameGenerator(db.motorcycles.id, db.parts.motorcycleId));

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MotorcyclesTableFilterComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get make => $composableBuilder(
      column: $table.make, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vin => $composableBuilder(
      column: $table.vin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  Expression<bool> maintenanceLogsRefs(
      Expression<bool> Function($$MaintenanceLogsTableFilterComposer f) f) {
    final $$MaintenanceLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceLogs,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceLogsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> fuelLogsRefs(
      Expression<bool> Function($$FuelLogsTableFilterComposer f) f) {
    final $$FuelLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fuelLogs,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuelLogsTableFilterComposer(
              $db: $db,
              $table: $db.fuelLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> partsRefs(
      Expression<bool> Function($$PartsTableFilterComposer f) f) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MotorcyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get make => $composableBuilder(
      column: $table.make, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vin => $composableBuilder(
      column: $table.vin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$MotorcyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> maintenanceLogsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceLogsTableAnnotationComposer a) f) {
    final $$MaintenanceLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceLogs,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> fuelLogsRefs<T extends Object>(
      Expression<T> Function($$FuelLogsTableAnnotationComposer a) f) {
    final $$FuelLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.fuelLogs,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FuelLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.fuelLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> partsRefs<T extends Object>(
      Expression<T> Function($$PartsTableAnnotationComposer a) f) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MotorcyclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MotorcyclesTable,
    Motorcycle,
    $$MotorcyclesTableFilterComposer,
    $$MotorcyclesTableOrderingComposer,
    $$MotorcyclesTableAnnotationComposer,
    $$MotorcyclesTableCreateCompanionBuilder,
    $$MotorcyclesTableUpdateCompanionBuilder,
    (Motorcycle, $$MotorcyclesTableReferences),
    Motorcycle,
    PrefetchHooks Function(
        {bool maintenanceLogsRefs, bool fuelLogsRefs, bool partsRefs})> {
  $$MotorcyclesTableTableManager(_$AppDatabase db, $MotorcyclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotorcyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotorcyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotorcyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nickname = const Value.absent(),
            Value<String?> make = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> vin = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MotorcyclesCompanion(
            id: id,
            nickname: nickname,
            make: make,
            model: model,
            year: year,
            vin: vin,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nickname,
            Value<String?> make = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> vin = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MotorcyclesCompanion.insert(
            id: id,
            nickname: nickname,
            make: make,
            model: model,
            year: year,
            vin: vin,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MotorcyclesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {maintenanceLogsRefs = false,
              fuelLogsRefs = false,
              partsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceLogsRefs) db.maintenanceLogs,
                if (fuelLogsRefs) db.fuelLogs,
                if (partsRefs) db.parts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceLogsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._maintenanceLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .maintenanceLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (fuelLogsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MotorcyclesTableReferences._fuelLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .fuelLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (partsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MotorcyclesTableReferences._partsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .partsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MotorcyclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MotorcyclesTable,
    Motorcycle,
    $$MotorcyclesTableFilterComposer,
    $$MotorcyclesTableOrderingComposer,
    $$MotorcyclesTableAnnotationComposer,
    $$MotorcyclesTableCreateCompanionBuilder,
    $$MotorcyclesTableUpdateCompanionBuilder,
    (Motorcycle, $$MotorcyclesTableReferences),
    Motorcycle,
    PrefetchHooks Function(
        {bool maintenanceLogsRefs, bool fuelLogsRefs, bool partsRefs})>;
typedef $$MaintenanceLogsTableCreateCompanionBuilder = MaintenanceLogsCompanion
    Function({
  Value<int> id,
  required int motorcycleId,
  required DateTime date,
  required int mileage,
  required String task,
  Value<String?> notes,
  Value<int?> nextMaintenanceMileage,
  Value<DateTime?> nextMaintenanceDate,
});
typedef $$MaintenanceLogsTableUpdateCompanionBuilder = MaintenanceLogsCompanion
    Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<DateTime> date,
  Value<int> mileage,
  Value<String> task,
  Value<String?> notes,
  Value<int?> nextMaintenanceMileage,
  Value<DateTime?> nextMaintenanceDate,
});

final class $$MaintenanceLogsTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceLogsTable, MaintenanceLog> {
  $$MaintenanceLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.maintenanceLogs.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager get motorcycleId {
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaintenanceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mileage => $composableBuilder(
      column: $table.mileage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get task => $composableBuilder(
      column: $table.task, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextMaintenanceMileage => $composableBuilder(
      column: $table.nextMaintenanceMileage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextMaintenanceDate => $composableBuilder(
      column: $table.nextMaintenanceDate,
      builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mileage => $composableBuilder(
      column: $table.mileage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get task => $composableBuilder(
      column: $table.task, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextMaintenanceMileage => $composableBuilder(
      column: $table.nextMaintenanceMileage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextMaintenanceDate => $composableBuilder(
      column: $table.nextMaintenanceDate,
      builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get mileage =>
      $composableBuilder(column: $table.mileage, builder: (column) => column);

  GeneratedColumn<String> get task =>
      $composableBuilder(column: $table.task, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get nextMaintenanceMileage => $composableBuilder(
      column: $table.nextMaintenanceMileage, builder: (column) => column);

  GeneratedColumn<DateTime> get nextMaintenanceDate => $composableBuilder(
      column: $table.nextMaintenanceDate, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceLogsTable,
    MaintenanceLog,
    $$MaintenanceLogsTableFilterComposer,
    $$MaintenanceLogsTableOrderingComposer,
    $$MaintenanceLogsTableAnnotationComposer,
    $$MaintenanceLogsTableCreateCompanionBuilder,
    $$MaintenanceLogsTableUpdateCompanionBuilder,
    (MaintenanceLog, $$MaintenanceLogsTableReferences),
    MaintenanceLog,
    PrefetchHooks Function({bool motorcycleId})> {
  $$MaintenanceLogsTableTableManager(
      _$AppDatabase db, $MaintenanceLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> mileage = const Value.absent(),
            Value<String> task = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> nextMaintenanceMileage = const Value.absent(),
            Value<DateTime?> nextMaintenanceDate = const Value.absent(),
          }) =>
              MaintenanceLogsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            date: date,
            mileage: mileage,
            task: task,
            notes: notes,
            nextMaintenanceMileage: nextMaintenanceMileage,
            nextMaintenanceDate: nextMaintenanceDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required DateTime date,
            required int mileage,
            required String task,
            Value<String?> notes = const Value.absent(),
            Value<int?> nextMaintenanceMileage = const Value.absent(),
            Value<DateTime?> nextMaintenanceDate = const Value.absent(),
          }) =>
              MaintenanceLogsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            date: date,
            mileage: mileage,
            task: task,
            notes: notes,
            nextMaintenanceMileage: nextMaintenanceMileage,
            nextMaintenanceDate: nextMaintenanceDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({motorcycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$MaintenanceLogsTableReferences._motorcycleIdTable(db),
                    referencedColumn: $$MaintenanceLogsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaintenanceLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenanceLogsTable,
    MaintenanceLog,
    $$MaintenanceLogsTableFilterComposer,
    $$MaintenanceLogsTableOrderingComposer,
    $$MaintenanceLogsTableAnnotationComposer,
    $$MaintenanceLogsTableCreateCompanionBuilder,
    $$MaintenanceLogsTableUpdateCompanionBuilder,
    (MaintenanceLog, $$MaintenanceLogsTableReferences),
    MaintenanceLog,
    PrefetchHooks Function({bool motorcycleId})>;
typedef $$FuelLogsTableCreateCompanionBuilder = FuelLogsCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required DateTime date,
  required int mileage,
  required double amount,
  Value<double?> pricePerUnit,
  Value<bool> fullTank,
});
typedef $$FuelLogsTableUpdateCompanionBuilder = FuelLogsCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<DateTime> date,
  Value<int> mileage,
  Value<double> amount,
  Value<double?> pricePerUnit,
  Value<bool> fullTank,
});

final class $$FuelLogsTableReferences
    extends BaseReferences<_$AppDatabase, $FuelLogsTable, FuelLog> {
  $$FuelLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias(
          $_aliasNameGenerator(db.fuelLogs.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager get motorcycleId {
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FuelLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelLogsTable> {
  $$FuelLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mileage => $composableBuilder(
      column: $table.mileage, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fullTank => $composableBuilder(
      column: $table.fullTank, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FuelLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelLogsTable> {
  $$FuelLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mileage => $composableBuilder(
      column: $table.mileage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fullTank => $composableBuilder(
      column: $table.fullTank, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FuelLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelLogsTable> {
  $$FuelLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get mileage =>
      $composableBuilder(column: $table.mileage, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => column);

  GeneratedColumn<bool> get fullTank =>
      $composableBuilder(column: $table.fullTank, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FuelLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FuelLogsTable,
    FuelLog,
    $$FuelLogsTableFilterComposer,
    $$FuelLogsTableOrderingComposer,
    $$FuelLogsTableAnnotationComposer,
    $$FuelLogsTableCreateCompanionBuilder,
    $$FuelLogsTableUpdateCompanionBuilder,
    (FuelLog, $$FuelLogsTableReferences),
    FuelLog,
    PrefetchHooks Function({bool motorcycleId})> {
  $$FuelLogsTableTableManager(_$AppDatabase db, $FuelLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> mileage = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double?> pricePerUnit = const Value.absent(),
            Value<bool> fullTank = const Value.absent(),
          }) =>
              FuelLogsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            date: date,
            mileage: mileage,
            amount: amount,
            pricePerUnit: pricePerUnit,
            fullTank: fullTank,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required DateTime date,
            required int mileage,
            required double amount,
            Value<double?> pricePerUnit = const Value.absent(),
            Value<bool> fullTank = const Value.absent(),
          }) =>
              FuelLogsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            date: date,
            mileage: mileage,
            amount: amount,
            pricePerUnit: pricePerUnit,
            fullTank: fullTank,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FuelLogsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({motorcycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$FuelLogsTableReferences._motorcycleIdTable(db),
                    referencedColumn:
                        $$FuelLogsTableReferences._motorcycleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FuelLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FuelLogsTable,
    FuelLog,
    $$FuelLogsTableFilterComposer,
    $$FuelLogsTableOrderingComposer,
    $$FuelLogsTableAnnotationComposer,
    $$FuelLogsTableCreateCompanionBuilder,
    $$FuelLogsTableUpdateCompanionBuilder,
    (FuelLog, $$FuelLogsTableReferences),
    FuelLog,
    PrefetchHooks Function({bool motorcycleId})>;
typedef $$PartsTableCreateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required String name,
  required String status,
  Value<bool> isOemPossessed,
  Value<int?> installedMileage,
  Value<DateTime?> installedDate,
  Value<String?> notes,
});
typedef $$PartsTableUpdateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<String> name,
  Value<String> status,
  Value<bool> isOemPossessed,
  Value<int?> installedMileage,
  Value<DateTime?> installedDate,
  Value<String?> notes,
});

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, Part> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias(
          $_aliasNameGenerator(db.parts.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager get motorcycleId {
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOemPossessed => $composableBuilder(
      column: $table.isOemPossessed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installedMileage => $composableBuilder(
      column: $table.installedMileage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get installedDate => $composableBuilder(
      column: $table.installedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOemPossessed => $composableBuilder(
      column: $table.isOemPossessed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installedMileage => $composableBuilder(
      column: $table.installedMileage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get installedDate => $composableBuilder(
      column: $table.installedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isOemPossessed => $composableBuilder(
      column: $table.isOemPossessed, builder: (column) => column);

  GeneratedColumn<int> get installedMileage => $composableBuilder(
      column: $table.installedMileage, builder: (column) => column);

  GeneratedColumn<DateTime> get installedDate => $composableBuilder(
      column: $table.installedDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsTable,
    Part,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (Part, $$PartsTableReferences),
    Part,
    PrefetchHooks Function({bool motorcycleId})> {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isOemPossessed = const Value.absent(),
            Value<int?> installedMileage = const Value.absent(),
            Value<DateTime?> installedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PartsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            status: status,
            isOemPossessed: isOemPossessed,
            installedMileage: installedMileage,
            installedDate: installedDate,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required String name,
            required String status,
            Value<bool> isOemPossessed = const Value.absent(),
            Value<int?> installedMileage = const Value.absent(),
            Value<DateTime?> installedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PartsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            status: status,
            isOemPossessed: isOemPossessed,
            installedMileage: installedMileage,
            installedDate: installedDate,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PartsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({motorcycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$PartsTableReferences._motorcycleIdTable(db),
                    referencedColumn:
                        $$PartsTableReferences._motorcycleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PartsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsTable,
    Part,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (Part, $$PartsTableReferences),
    Part,
    PrefetchHooks Function({bool motorcycleId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MotorcyclesTableTableManager get motorcycles =>
      $$MotorcyclesTableTableManager(_db, _db.motorcycles);
  $$MaintenanceLogsTableTableManager get maintenanceLogs =>
      $$MaintenanceLogsTableTableManager(_db, _db.maintenanceLogs);
  $$FuelLogsTableTableManager get fuelLogs =>
      $$FuelLogsTableTableManager(_db, _db.fuelLogs);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
}
