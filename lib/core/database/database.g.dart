// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NovelsTable extends Novels with TableInfo<$NovelsTable, Novel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceNovelUrlMeta = const VerificationMeta(
    'sourceNovelUrl',
  );
  @override
  late final GeneratedColumn<String> sourceNovelUrl = GeneratedColumn<String>(
    'source_novel_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLocalMeta = const VerificationMeta(
    'isLocal',
  );
  @override
  late final GeneratedColumn<bool> isLocal = GeneratedColumn<bool>(
    'is_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFormatMeta = const VerificationMeta(
    'localFormat',
  );
  @override
  late final GeneratedColumn<String> localFormat = GeneratedColumn<String>(
    'local_format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastReadChapterIdMeta = const VerificationMeta(
    'lastReadChapterId',
  );
  @override
  late final GeneratedColumn<int> lastReadChapterId = GeneratedColumn<int>(
    'last_read_chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    coverUrl,
    description,
    sourceId,
    sourceNovelUrl,
    status,
    isLocal,
    localPath,
    localFormat,
    isFavorite,
    lastReadChapterId,
    lastReadAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Novel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('source_novel_url')) {
      context.handle(
        _sourceNovelUrlMeta,
        sourceNovelUrl.isAcceptableOrUnknown(
          data['source_novel_url']!,
          _sourceNovelUrlMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_local')) {
      context.handle(
        _isLocalMeta,
        isLocal.isAcceptableOrUnknown(data['is_local']!, _isLocalMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('local_format')) {
      context.handle(
        _localFormatMeta,
        localFormat.isAcceptableOrUnknown(
          data['local_format']!,
          _localFormatMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_read_chapter_id')) {
      context.handle(
        _lastReadChapterIdMeta,
        lastReadChapterId.isAcceptableOrUnknown(
          data['last_read_chapter_id']!,
          _lastReadChapterIdMeta,
        ),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Novel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Novel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      sourceNovelUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_novel_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      isLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_local'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      localFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_format'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastReadChapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_read_chapter_id'],
      ),
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_read_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NovelsTable createAlias(String alias) {
    return $NovelsTable(attachedDatabase, alias);
  }
}

class Novel extends DataClass implements Insertable<Novel> {
  final int id;
  final String title;
  final String? author;
  final String? coverUrl;
  final String? description;
  final String? sourceId;
  final String? sourceNovelUrl;
  final String? status;
  final bool isLocal;
  final String? localPath;
  final String? localFormat;
  final bool isFavorite;
  final int? lastReadChapterId;
  final DateTime? lastReadAt;
  final DateTime createdAt;
  const Novel({
    required this.id,
    required this.title,
    this.author,
    this.coverUrl,
    this.description,
    this.sourceId,
    this.sourceNovelUrl,
    this.status,
    required this.isLocal,
    this.localPath,
    this.localFormat,
    required this.isFavorite,
    this.lastReadChapterId,
    this.lastReadAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    if (!nullToAbsent || sourceNovelUrl != null) {
      map['source_novel_url'] = Variable<String>(sourceNovelUrl);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['is_local'] = Variable<bool>(isLocal);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || localFormat != null) {
      map['local_format'] = Variable<String>(localFormat);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastReadChapterId != null) {
      map['last_read_chapter_id'] = Variable<int>(lastReadChapterId);
    }
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NovelsCompanion toCompanion(bool nullToAbsent) {
    return NovelsCompanion(
      id: Value(id),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      sourceNovelUrl: sourceNovelUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceNovelUrl),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      isLocal: Value(isLocal),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      localFormat: localFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(localFormat),
      isFavorite: Value(isFavorite),
      lastReadChapterId: lastReadChapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadChapterId),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      createdAt: Value(createdAt),
    );
  }

  factory Novel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Novel(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      description: serializer.fromJson<String?>(json['description']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      sourceNovelUrl: serializer.fromJson<String?>(json['sourceNovelUrl']),
      status: serializer.fromJson<String?>(json['status']),
      isLocal: serializer.fromJson<bool>(json['isLocal']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      localFormat: serializer.fromJson<String?>(json['localFormat']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastReadChapterId: serializer.fromJson<int?>(json['lastReadChapterId']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'description': serializer.toJson<String?>(description),
      'sourceId': serializer.toJson<String?>(sourceId),
      'sourceNovelUrl': serializer.toJson<String?>(sourceNovelUrl),
      'status': serializer.toJson<String?>(status),
      'isLocal': serializer.toJson<bool>(isLocal),
      'localPath': serializer.toJson<String?>(localPath),
      'localFormat': serializer.toJson<String?>(localFormat),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastReadChapterId': serializer.toJson<int?>(lastReadChapterId),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Novel copyWith({
    int? id,
    String? title,
    Value<String?> author = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> sourceId = const Value.absent(),
    Value<String?> sourceNovelUrl = const Value.absent(),
    Value<String?> status = const Value.absent(),
    bool? isLocal,
    Value<String?> localPath = const Value.absent(),
    Value<String?> localFormat = const Value.absent(),
    bool? isFavorite,
    Value<int?> lastReadChapterId = const Value.absent(),
    Value<DateTime?> lastReadAt = const Value.absent(),
    DateTime? createdAt,
  }) => Novel(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    description: description.present ? description.value : this.description,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    sourceNovelUrl: sourceNovelUrl.present
        ? sourceNovelUrl.value
        : this.sourceNovelUrl,
    status: status.present ? status.value : this.status,
    isLocal: isLocal ?? this.isLocal,
    localPath: localPath.present ? localPath.value : this.localPath,
    localFormat: localFormat.present ? localFormat.value : this.localFormat,
    isFavorite: isFavorite ?? this.isFavorite,
    lastReadChapterId: lastReadChapterId.present
        ? lastReadChapterId.value
        : this.lastReadChapterId,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Novel copyWithCompanion(NovelsCompanion data) {
    return Novel(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      description: data.description.present
          ? data.description.value
          : this.description,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceNovelUrl: data.sourceNovelUrl.present
          ? data.sourceNovelUrl.value
          : this.sourceNovelUrl,
      status: data.status.present ? data.status.value : this.status,
      isLocal: data.isLocal.present ? data.isLocal.value : this.isLocal,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      localFormat: data.localFormat.present
          ? data.localFormat.value
          : this.localFormat,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastReadChapterId: data.lastReadChapterId.present
          ? data.lastReadChapterId.value
          : this.lastReadChapterId,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Novel(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('description: $description, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceNovelUrl: $sourceNovelUrl, ')
          ..write('status: $status, ')
          ..write('isLocal: $isLocal, ')
          ..write('localPath: $localPath, ')
          ..write('localFormat: $localFormat, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastReadChapterId: $lastReadChapterId, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    coverUrl,
    description,
    sourceId,
    sourceNovelUrl,
    status,
    isLocal,
    localPath,
    localFormat,
    isFavorite,
    lastReadChapterId,
    lastReadAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Novel &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.coverUrl == this.coverUrl &&
          other.description == this.description &&
          other.sourceId == this.sourceId &&
          other.sourceNovelUrl == this.sourceNovelUrl &&
          other.status == this.status &&
          other.isLocal == this.isLocal &&
          other.localPath == this.localPath &&
          other.localFormat == this.localFormat &&
          other.isFavorite == this.isFavorite &&
          other.lastReadChapterId == this.lastReadChapterId &&
          other.lastReadAt == this.lastReadAt &&
          other.createdAt == this.createdAt);
}

class NovelsCompanion extends UpdateCompanion<Novel> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<String?> coverUrl;
  final Value<String?> description;
  final Value<String?> sourceId;
  final Value<String?> sourceNovelUrl;
  final Value<String?> status;
  final Value<bool> isLocal;
  final Value<String?> localPath;
  final Value<String?> localFormat;
  final Value<bool> isFavorite;
  final Value<int?> lastReadChapterId;
  final Value<DateTime?> lastReadAt;
  final Value<DateTime> createdAt;
  const NovelsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceNovelUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.isLocal = const Value.absent(),
    this.localPath = const Value.absent(),
    this.localFormat = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastReadChapterId = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NovelsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.author = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceNovelUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.isLocal = const Value.absent(),
    this.localPath = const Value.absent(),
    this.localFormat = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastReadChapterId = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Novel> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? coverUrl,
    Expression<String>? description,
    Expression<String>? sourceId,
    Expression<String>? sourceNovelUrl,
    Expression<String>? status,
    Expression<bool>? isLocal,
    Expression<String>? localPath,
    Expression<String>? localFormat,
    Expression<bool>? isFavorite,
    Expression<int>? lastReadChapterId,
    Expression<DateTime>? lastReadAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (description != null) 'description': description,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceNovelUrl != null) 'source_novel_url': sourceNovelUrl,
      if (status != null) 'status': status,
      if (isLocal != null) 'is_local': isLocal,
      if (localPath != null) 'local_path': localPath,
      if (localFormat != null) 'local_format': localFormat,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastReadChapterId != null) 'last_read_chapter_id': lastReadChapterId,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NovelsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? author,
    Value<String?>? coverUrl,
    Value<String?>? description,
    Value<String?>? sourceId,
    Value<String?>? sourceNovelUrl,
    Value<String?>? status,
    Value<bool>? isLocal,
    Value<String?>? localPath,
    Value<String?>? localFormat,
    Value<bool>? isFavorite,
    Value<int?>? lastReadChapterId,
    Value<DateTime?>? lastReadAt,
    Value<DateTime>? createdAt,
  }) {
    return NovelsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      sourceId: sourceId ?? this.sourceId,
      sourceNovelUrl: sourceNovelUrl ?? this.sourceNovelUrl,
      status: status ?? this.status,
      isLocal: isLocal ?? this.isLocal,
      localPath: localPath ?? this.localPath,
      localFormat: localFormat ?? this.localFormat,
      isFavorite: isFavorite ?? this.isFavorite,
      lastReadChapterId: lastReadChapterId ?? this.lastReadChapterId,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceNovelUrl.present) {
      map['source_novel_url'] = Variable<String>(sourceNovelUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isLocal.present) {
      map['is_local'] = Variable<bool>(isLocal.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (localFormat.present) {
      map['local_format'] = Variable<String>(localFormat.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastReadChapterId.present) {
      map['last_read_chapter_id'] = Variable<int>(lastReadChapterId.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NovelsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('description: $description, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceNovelUrl: $sourceNovelUrl, ')
          ..write('status: $status, ')
          ..write('isLocal: $isLocal, ')
          ..write('localPath: $localPath, ')
          ..write('localFormat: $localFormat, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastReadChapterId: $lastReadChapterId, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _novelIdMeta = const VerificationMeta(
    'novelId',
  );
  @override
  late final GeneratedColumn<int> novelId = GeneratedColumn<int>(
    'novel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES novels (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterIndexMeta = const VerificationMeta(
    'chapterIndex',
  );
  @override
  late final GeneratedColumn<double> chapterIndex = GeneratedColumn<double>(
    'chapter_index',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDownloadedMeta = const VerificationMeta(
    'isDownloaded',
  );
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
    'is_downloaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_downloaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _readProgressMeta = const VerificationMeta(
    'readProgress',
  );
  @override
  late final GeneratedColumn<double> readProgress = GeneratedColumn<double>(
    'read_progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    novelId,
    chapterIndex,
    title,
    url,
    content,
    isDownloaded,
    isRead,
    readProgress,
    releaseDate,
    localFilePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('novel_id')) {
      context.handle(
        _novelIdMeta,
        novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
        _chapterIndexMeta,
        chapterIndex.isAcceptableOrUnknown(
          data['chapter_index']!,
          _chapterIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterIndexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
        _isDownloadedMeta,
        isDownloaded.isAcceptableOrUnknown(
          data['is_downloaded']!,
          _isDownloadedMeta,
        ),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('read_progress')) {
      context.handle(
        _readProgressMeta,
        readProgress.isAcceptableOrUnknown(
          data['read_progress']!,
          _readProgressMeta,
        ),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      novelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}novel_id'],
      )!,
      chapterIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chapter_index'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      isDownloaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_downloaded'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      readProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}read_progress'],
      )!,
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      ),
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final int id;
  final int novelId;
  final double chapterIndex;
  final String title;
  final String? url;
  final String? content;
  final bool isDownloaded;
  final bool isRead;
  final double readProgress;
  final DateTime? releaseDate;
  final String? localFilePath;
  const Chapter({
    required this.id,
    required this.novelId,
    required this.chapterIndex,
    required this.title,
    this.url,
    this.content,
    required this.isDownloaded,
    required this.isRead,
    required this.readProgress,
    this.releaseDate,
    this.localFilePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['novel_id'] = Variable<int>(novelId);
    map['chapter_index'] = Variable<double>(chapterIndex);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['is_read'] = Variable<bool>(isRead);
    map['read_progress'] = Variable<double>(readProgress);
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    if (!nullToAbsent || localFilePath != null) {
      map['local_file_path'] = Variable<String>(localFilePath);
    }
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      novelId: Value(novelId),
      chapterIndex: Value(chapterIndex),
      title: Value(title),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      isDownloaded: Value(isDownloaded),
      isRead: Value(isRead),
      readProgress: Value(readProgress),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      localFilePath: localFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localFilePath),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<int>(json['id']),
      novelId: serializer.fromJson<int>(json['novelId']),
      chapterIndex: serializer.fromJson<double>(json['chapterIndex']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String?>(json['url']),
      content: serializer.fromJson<String?>(json['content']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      readProgress: serializer.fromJson<double>(json['readProgress']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      localFilePath: serializer.fromJson<String?>(json['localFilePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'novelId': serializer.toJson<int>(novelId),
      'chapterIndex': serializer.toJson<double>(chapterIndex),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String?>(url),
      'content': serializer.toJson<String?>(content),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'isRead': serializer.toJson<bool>(isRead),
      'readProgress': serializer.toJson<double>(readProgress),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'localFilePath': serializer.toJson<String?>(localFilePath),
    };
  }

  Chapter copyWith({
    int? id,
    int? novelId,
    double? chapterIndex,
    String? title,
    Value<String?> url = const Value.absent(),
    Value<String?> content = const Value.absent(),
    bool? isDownloaded,
    bool? isRead,
    double? readProgress,
    Value<DateTime?> releaseDate = const Value.absent(),
    Value<String?> localFilePath = const Value.absent(),
  }) => Chapter(
    id: id ?? this.id,
    novelId: novelId ?? this.novelId,
    chapterIndex: chapterIndex ?? this.chapterIndex,
    title: title ?? this.title,
    url: url.present ? url.value : this.url,
    content: content.present ? content.value : this.content,
    isDownloaded: isDownloaded ?? this.isDownloaded,
    isRead: isRead ?? this.isRead,
    readProgress: readProgress ?? this.readProgress,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    localFilePath: localFilePath.present
        ? localFilePath.value
        : this.localFilePath,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      content: data.content.present ? data.content.value : this.content,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      readProgress: data.readProgress.present
          ? data.readProgress.value
          : this.readProgress,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('content: $content, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('isRead: $isRead, ')
          ..write('readProgress: $readProgress, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('localFilePath: $localFilePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    novelId,
    chapterIndex,
    title,
    url,
    content,
    isDownloaded,
    isRead,
    readProgress,
    releaseDate,
    localFilePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.novelId == this.novelId &&
          other.chapterIndex == this.chapterIndex &&
          other.title == this.title &&
          other.url == this.url &&
          other.content == this.content &&
          other.isDownloaded == this.isDownloaded &&
          other.isRead == this.isRead &&
          other.readProgress == this.readProgress &&
          other.releaseDate == this.releaseDate &&
          other.localFilePath == this.localFilePath);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<int> id;
  final Value<int> novelId;
  final Value<double> chapterIndex;
  final Value<String> title;
  final Value<String?> url;
  final Value<String?> content;
  final Value<bool> isDownloaded;
  final Value<bool> isRead;
  final Value<double> readProgress;
  final Value<DateTime?> releaseDate;
  final Value<String?> localFilePath;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.novelId = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.content = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.isRead = const Value.absent(),
    this.readProgress = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.localFilePath = const Value.absent(),
  });
  ChaptersCompanion.insert({
    this.id = const Value.absent(),
    required int novelId,
    required double chapterIndex,
    required String title,
    this.url = const Value.absent(),
    this.content = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.isRead = const Value.absent(),
    this.readProgress = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.localFilePath = const Value.absent(),
  }) : novelId = Value(novelId),
       chapterIndex = Value(chapterIndex),
       title = Value(title);
  static Insertable<Chapter> custom({
    Expression<int>? id,
    Expression<int>? novelId,
    Expression<double>? chapterIndex,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? content,
    Expression<bool>? isDownloaded,
    Expression<bool>? isRead,
    Expression<double>? readProgress,
    Expression<DateTime>? releaseDate,
    Expression<String>? localFilePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (novelId != null) 'novel_id': novelId,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (content != null) 'content': content,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (isRead != null) 'is_read': isRead,
      if (readProgress != null) 'read_progress': readProgress,
      if (releaseDate != null) 'release_date': releaseDate,
      if (localFilePath != null) 'local_file_path': localFilePath,
    });
  }

  ChaptersCompanion copyWith({
    Value<int>? id,
    Value<int>? novelId,
    Value<double>? chapterIndex,
    Value<String>? title,
    Value<String?>? url,
    Value<String?>? content,
    Value<bool>? isDownloaded,
    Value<bool>? isRead,
    Value<double>? readProgress,
    Value<DateTime?>? releaseDate,
    Value<String?>? localFilePath,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      title: title ?? this.title,
      url: url ?? this.url,
      content: content ?? this.content,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isRead: isRead ?? this.isRead,
      readProgress: readProgress ?? this.readProgress,
      releaseDate: releaseDate ?? this.releaseDate,
      localFilePath: localFilePath ?? this.localFilePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (novelId.present) {
      map['novel_id'] = Variable<int>(novelId.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<double>(chapterIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (readProgress.present) {
      map['read_progress'] = Variable<double>(readProgress.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('content: $content, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('isRead: $isRead, ')
          ..write('readProgress: $readProgress, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('localFilePath: $localFilePath')
          ..write(')'))
        .toString();
  }
}

class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconUrlMeta = const VerificationMeta(
    'iconUrl',
  );
  @override
  late final GeneratedColumn<String> iconUrl = GeneratedColumn<String>(
    'icon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCustomRepoMeta = const VerificationMeta(
    'isCustomRepo',
  );
  @override
  late final GeneratedColumn<bool> isCustomRepo = GeneratedColumn<bool>(
    'is_custom_repo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_repo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repoUrlMeta = const VerificationMeta(
    'repoUrl',
  );
  @override
  late final GeneratedColumn<String> repoUrl = GeneratedColumn<String>(
    'repo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1.0.0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    lang,
    baseUrl,
    iconUrl,
    isEnabled,
    isCustomRepo,
    repoUrl,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<Source> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('icon_url')) {
      context.handle(
        _iconUrlMeta,
        iconUrl.isAcceptableOrUnknown(data['icon_url']!, _iconUrlMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('is_custom_repo')) {
      context.handle(
        _isCustomRepoMeta,
        isCustomRepo.isAcceptableOrUnknown(
          data['is_custom_repo']!,
          _isCustomRepoMeta,
        ),
      );
    }
    if (data.containsKey('repo_url')) {
      context.handle(
        _repoUrlMeta,
        repoUrl.isAcceptableOrUnknown(data['repo_url']!, _repoUrlMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      iconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_url'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isCustomRepo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_repo'],
      )!,
      repoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repo_url'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }
}

class Source extends DataClass implements Insertable<Source> {
  final String id;
  final String name;
  final String lang;
  final String baseUrl;
  final String? iconUrl;
  final bool isEnabled;
  final bool isCustomRepo;
  final String? repoUrl;
  final String version;
  const Source({
    required this.id,
    required this.name,
    required this.lang,
    required this.baseUrl,
    this.iconUrl,
    required this.isEnabled,
    required this.isCustomRepo,
    this.repoUrl,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['lang'] = Variable<String>(lang);
    map['base_url'] = Variable<String>(baseUrl);
    if (!nullToAbsent || iconUrl != null) {
      map['icon_url'] = Variable<String>(iconUrl);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_custom_repo'] = Variable<bool>(isCustomRepo);
    if (!nullToAbsent || repoUrl != null) {
      map['repo_url'] = Variable<String>(repoUrl);
    }
    map['version'] = Variable<String>(version);
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      name: Value(name),
      lang: Value(lang),
      baseUrl: Value(baseUrl),
      iconUrl: iconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUrl),
      isEnabled: Value(isEnabled),
      isCustomRepo: Value(isCustomRepo),
      repoUrl: repoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(repoUrl),
      version: Value(version),
    );
  }

  factory Source.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lang: serializer.fromJson<String>(json['lang']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      iconUrl: serializer.fromJson<String?>(json['iconUrl']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isCustomRepo: serializer.fromJson<bool>(json['isCustomRepo']),
      repoUrl: serializer.fromJson<String?>(json['repoUrl']),
      version: serializer.fromJson<String>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lang': serializer.toJson<String>(lang),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'iconUrl': serializer.toJson<String?>(iconUrl),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isCustomRepo': serializer.toJson<bool>(isCustomRepo),
      'repoUrl': serializer.toJson<String?>(repoUrl),
      'version': serializer.toJson<String>(version),
    };
  }

  Source copyWith({
    String? id,
    String? name,
    String? lang,
    String? baseUrl,
    Value<String?> iconUrl = const Value.absent(),
    bool? isEnabled,
    bool? isCustomRepo,
    Value<String?> repoUrl = const Value.absent(),
    String? version,
  }) => Source(
    id: id ?? this.id,
    name: name ?? this.name,
    lang: lang ?? this.lang,
    baseUrl: baseUrl ?? this.baseUrl,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    isEnabled: isEnabled ?? this.isEnabled,
    isCustomRepo: isCustomRepo ?? this.isCustomRepo,
    repoUrl: repoUrl.present ? repoUrl.value : this.repoUrl,
    version: version ?? this.version,
  );
  Source copyWithCompanion(SourcesCompanion data) {
    return Source(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lang: data.lang.present ? data.lang.value : this.lang,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      iconUrl: data.iconUrl.present ? data.iconUrl.value : this.iconUrl,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isCustomRepo: data.isCustomRepo.present
          ? data.isCustomRepo.value
          : this.isCustomRepo,
      repoUrl: data.repoUrl.present ? data.repoUrl.value : this.repoUrl,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lang: $lang, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustomRepo: $isCustomRepo, ')
          ..write('repoUrl: $repoUrl, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    lang,
    baseUrl,
    iconUrl,
    isEnabled,
    isCustomRepo,
    repoUrl,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.id == this.id &&
          other.name == this.name &&
          other.lang == this.lang &&
          other.baseUrl == this.baseUrl &&
          other.iconUrl == this.iconUrl &&
          other.isEnabled == this.isEnabled &&
          other.isCustomRepo == this.isCustomRepo &&
          other.repoUrl == this.repoUrl &&
          other.version == this.version);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> lang;
  final Value<String> baseUrl;
  final Value<String?> iconUrl;
  final Value<bool> isEnabled;
  final Value<bool> isCustomRepo;
  final Value<String?> repoUrl;
  final Value<String> version;
  final Value<int> rowid;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lang = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustomRepo = const Value.absent(),
    this.repoUrl = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcesCompanion.insert({
    required String id,
    required String name,
    this.lang = const Value.absent(),
    required String baseUrl,
    this.iconUrl = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustomRepo = const Value.absent(),
    this.repoUrl = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       baseUrl = Value(baseUrl);
  static Insertable<Source> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? lang,
    Expression<String>? baseUrl,
    Expression<String>? iconUrl,
    Expression<bool>? isEnabled,
    Expression<bool>? isCustomRepo,
    Expression<String>? repoUrl,
    Expression<String>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lang != null) 'lang': lang,
      if (baseUrl != null) 'base_url': baseUrl,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isCustomRepo != null) 'is_custom_repo': isCustomRepo,
      if (repoUrl != null) 'repo_url': repoUrl,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? lang,
    Value<String>? baseUrl,
    Value<String?>? iconUrl,
    Value<bool>? isEnabled,
    Value<bool>? isCustomRepo,
    Value<String?>? repoUrl,
    Value<String>? version,
    Value<int>? rowid,
  }) {
    return SourcesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lang: lang ?? this.lang,
      baseUrl: baseUrl ?? this.baseUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustomRepo: isCustomRepo ?? this.isCustomRepo,
      repoUrl: repoUrl ?? this.repoUrl,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (iconUrl.present) {
      map['icon_url'] = Variable<String>(iconUrl.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isCustomRepo.present) {
      map['is_custom_repo'] = Variable<bool>(isCustomRepo.value);
    }
    if (repoUrl.present) {
      map['repo_url'] = Variable<String>(repoUrl.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lang: $lang, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustomRepo: $isCustomRepo, ')
          ..write('repoUrl: $repoUrl, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TranslationMemoryTable extends TranslationMemory
    with TableInfo<$TranslationMemoryTable, TranslationMemoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationMemoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _textHashMeta = const VerificationMeta(
    'textHash',
  );
  @override
  late final GeneratedColumn<String> textHash = GeneratedColumn<String>(
    'text_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLangMeta = const VerificationMeta(
    'sourceLang',
  );
  @override
  late final GeneratedColumn<String> sourceLang = GeneratedColumn<String>(
    'source_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLangMeta = const VerificationMeta(
    'targetLang',
  );
  @override
  late final GeneratedColumn<String> targetLang = GeneratedColumn<String>(
    'target_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalTextMeta = const VerificationMeta(
    'originalText',
  );
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
    'original_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translatedTextMeta = const VerificationMeta(
    'translatedText',
  );
  @override
  late final GeneratedColumn<String> translatedText = GeneratedColumn<String>(
    'translated_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelUsedMeta = const VerificationMeta(
    'modelUsed',
  );
  @override
  late final GeneratedColumn<String> modelUsed = GeneratedColumn<String>(
    'model_used',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    textHash,
    sourceLang,
    targetLang,
    originalText,
    translatedText,
    modelUsed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translation_memory';
  @override
  VerificationContext validateIntegrity(
    Insertable<TranslationMemoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_hash')) {
      context.handle(
        _textHashMeta,
        textHash.isAcceptableOrUnknown(data['text_hash']!, _textHashMeta),
      );
    } else if (isInserting) {
      context.missing(_textHashMeta);
    }
    if (data.containsKey('source_lang')) {
      context.handle(
        _sourceLangMeta,
        sourceLang.isAcceptableOrUnknown(data['source_lang']!, _sourceLangMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceLangMeta);
    }
    if (data.containsKey('target_lang')) {
      context.handle(
        _targetLangMeta,
        targetLang.isAcceptableOrUnknown(data['target_lang']!, _targetLangMeta),
      );
    } else if (isInserting) {
      context.missing(_targetLangMeta);
    }
    if (data.containsKey('original_text')) {
      context.handle(
        _originalTextMeta,
        originalText.isAcceptableOrUnknown(
          data['original_text']!,
          _originalTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('translated_text')) {
      context.handle(
        _translatedTextMeta,
        translatedText.isAcceptableOrUnknown(
          data['translated_text']!,
          _translatedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translatedTextMeta);
    }
    if (data.containsKey('model_used')) {
      context.handle(
        _modelUsedMeta,
        modelUsed.isAcceptableOrUnknown(data['model_used']!, _modelUsedMeta),
      );
    } else if (isInserting) {
      context.missing(_modelUsedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranslationMemoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslationMemoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      textHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_hash'],
      )!,
      sourceLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_lang'],
      )!,
      targetLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_lang'],
      )!,
      originalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_text'],
      )!,
      translatedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translated_text'],
      )!,
      modelUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_used'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TranslationMemoryTable createAlias(String alias) {
    return $TranslationMemoryTable(attachedDatabase, alias);
  }
}

class TranslationMemoryData extends DataClass
    implements Insertable<TranslationMemoryData> {
  final int id;
  final String textHash;
  final String sourceLang;
  final String targetLang;
  final String originalText;
  final String translatedText;
  final String modelUsed;
  final DateTime createdAt;
  const TranslationMemoryData({
    required this.id,
    required this.textHash,
    required this.sourceLang,
    required this.targetLang,
    required this.originalText,
    required this.translatedText,
    required this.modelUsed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_hash'] = Variable<String>(textHash);
    map['source_lang'] = Variable<String>(sourceLang);
    map['target_lang'] = Variable<String>(targetLang);
    map['original_text'] = Variable<String>(originalText);
    map['translated_text'] = Variable<String>(translatedText);
    map['model_used'] = Variable<String>(modelUsed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TranslationMemoryCompanion toCompanion(bool nullToAbsent) {
    return TranslationMemoryCompanion(
      id: Value(id),
      textHash: Value(textHash),
      sourceLang: Value(sourceLang),
      targetLang: Value(targetLang),
      originalText: Value(originalText),
      translatedText: Value(translatedText),
      modelUsed: Value(modelUsed),
      createdAt: Value(createdAt),
    );
  }

  factory TranslationMemoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslationMemoryData(
      id: serializer.fromJson<int>(json['id']),
      textHash: serializer.fromJson<String>(json['textHash']),
      sourceLang: serializer.fromJson<String>(json['sourceLang']),
      targetLang: serializer.fromJson<String>(json['targetLang']),
      originalText: serializer.fromJson<String>(json['originalText']),
      translatedText: serializer.fromJson<String>(json['translatedText']),
      modelUsed: serializer.fromJson<String>(json['modelUsed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textHash': serializer.toJson<String>(textHash),
      'sourceLang': serializer.toJson<String>(sourceLang),
      'targetLang': serializer.toJson<String>(targetLang),
      'originalText': serializer.toJson<String>(originalText),
      'translatedText': serializer.toJson<String>(translatedText),
      'modelUsed': serializer.toJson<String>(modelUsed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TranslationMemoryData copyWith({
    int? id,
    String? textHash,
    String? sourceLang,
    String? targetLang,
    String? originalText,
    String? translatedText,
    String? modelUsed,
    DateTime? createdAt,
  }) => TranslationMemoryData(
    id: id ?? this.id,
    textHash: textHash ?? this.textHash,
    sourceLang: sourceLang ?? this.sourceLang,
    targetLang: targetLang ?? this.targetLang,
    originalText: originalText ?? this.originalText,
    translatedText: translatedText ?? this.translatedText,
    modelUsed: modelUsed ?? this.modelUsed,
    createdAt: createdAt ?? this.createdAt,
  );
  TranslationMemoryData copyWithCompanion(TranslationMemoryCompanion data) {
    return TranslationMemoryData(
      id: data.id.present ? data.id.value : this.id,
      textHash: data.textHash.present ? data.textHash.value : this.textHash,
      sourceLang: data.sourceLang.present
          ? data.sourceLang.value
          : this.sourceLang,
      targetLang: data.targetLang.present
          ? data.targetLang.value
          : this.targetLang,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      translatedText: data.translatedText.present
          ? data.translatedText.value
          : this.translatedText,
      modelUsed: data.modelUsed.present ? data.modelUsed.value : this.modelUsed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslationMemoryData(')
          ..write('id: $id, ')
          ..write('textHash: $textHash, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('originalText: $originalText, ')
          ..write('translatedText: $translatedText, ')
          ..write('modelUsed: $modelUsed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    textHash,
    sourceLang,
    targetLang,
    originalText,
    translatedText,
    modelUsed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslationMemoryData &&
          other.id == this.id &&
          other.textHash == this.textHash &&
          other.sourceLang == this.sourceLang &&
          other.targetLang == this.targetLang &&
          other.originalText == this.originalText &&
          other.translatedText == this.translatedText &&
          other.modelUsed == this.modelUsed &&
          other.createdAt == this.createdAt);
}

class TranslationMemoryCompanion
    extends UpdateCompanion<TranslationMemoryData> {
  final Value<int> id;
  final Value<String> textHash;
  final Value<String> sourceLang;
  final Value<String> targetLang;
  final Value<String> originalText;
  final Value<String> translatedText;
  final Value<String> modelUsed;
  final Value<DateTime> createdAt;
  const TranslationMemoryCompanion({
    this.id = const Value.absent(),
    this.textHash = const Value.absent(),
    this.sourceLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.originalText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.modelUsed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TranslationMemoryCompanion.insert({
    this.id = const Value.absent(),
    required String textHash,
    required String sourceLang,
    required String targetLang,
    required String originalText,
    required String translatedText,
    required String modelUsed,
    this.createdAt = const Value.absent(),
  }) : textHash = Value(textHash),
       sourceLang = Value(sourceLang),
       targetLang = Value(targetLang),
       originalText = Value(originalText),
       translatedText = Value(translatedText),
       modelUsed = Value(modelUsed);
  static Insertable<TranslationMemoryData> custom({
    Expression<int>? id,
    Expression<String>? textHash,
    Expression<String>? sourceLang,
    Expression<String>? targetLang,
    Expression<String>? originalText,
    Expression<String>? translatedText,
    Expression<String>? modelUsed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textHash != null) 'text_hash': textHash,
      if (sourceLang != null) 'source_lang': sourceLang,
      if (targetLang != null) 'target_lang': targetLang,
      if (originalText != null) 'original_text': originalText,
      if (translatedText != null) 'translated_text': translatedText,
      if (modelUsed != null) 'model_used': modelUsed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TranslationMemoryCompanion copyWith({
    Value<int>? id,
    Value<String>? textHash,
    Value<String>? sourceLang,
    Value<String>? targetLang,
    Value<String>? originalText,
    Value<String>? translatedText,
    Value<String>? modelUsed,
    Value<DateTime>? createdAt,
  }) {
    return TranslationMemoryCompanion(
      id: id ?? this.id,
      textHash: textHash ?? this.textHash,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      originalText: originalText ?? this.originalText,
      translatedText: translatedText ?? this.translatedText,
      modelUsed: modelUsed ?? this.modelUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textHash.present) {
      map['text_hash'] = Variable<String>(textHash.value);
    }
    if (sourceLang.present) {
      map['source_lang'] = Variable<String>(sourceLang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = Variable<String>(targetLang.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (translatedText.present) {
      map['translated_text'] = Variable<String>(translatedText.value);
    }
    if (modelUsed.present) {
      map['model_used'] = Variable<String>(modelUsed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationMemoryCompanion(')
          ..write('id: $id, ')
          ..write('textHash: $textHash, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('originalText: $originalText, ')
          ..write('translatedText: $translatedText, ')
          ..write('modelUsed: $modelUsed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NovelsTable novels = $NovelsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $TranslationMemoryTable translationMemory =
      $TranslationMemoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    novels,
    chapters,
    sources,
    translationMemory,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'novels',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chapters', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$NovelsTableCreateCompanionBuilder =
    NovelsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> author,
      Value<String?> coverUrl,
      Value<String?> description,
      Value<String?> sourceId,
      Value<String?> sourceNovelUrl,
      Value<String?> status,
      Value<bool> isLocal,
      Value<String?> localPath,
      Value<String?> localFormat,
      Value<bool> isFavorite,
      Value<int?> lastReadChapterId,
      Value<DateTime?> lastReadAt,
      Value<DateTime> createdAt,
    });
typedef $$NovelsTableUpdateCompanionBuilder =
    NovelsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> author,
      Value<String?> coverUrl,
      Value<String?> description,
      Value<String?> sourceId,
      Value<String?> sourceNovelUrl,
      Value<String?> status,
      Value<bool> isLocal,
      Value<String?> localPath,
      Value<String?> localFormat,
      Value<bool> isFavorite,
      Value<int?> lastReadChapterId,
      Value<DateTime?> lastReadAt,
      Value<DateTime> createdAt,
    });

final class $$NovelsTableReferences
    extends BaseReferences<_$AppDatabase, $NovelsTable, Novel> {
  $$NovelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: $_aliasNameGenerator(db.novels.id, db.chapters.novelId),
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.novelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NovelsTableFilterComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceNovelUrl => $composableBuilder(
    column: $table.sourceNovelUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocal => $composableBuilder(
    column: $table.isLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFormat => $composableBuilder(
    column: $table.localFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReadChapterId => $composableBuilder(
    column: $table.lastReadChapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NovelsTableOrderingComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceNovelUrl => $composableBuilder(
    column: $table.sourceNovelUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocal => $composableBuilder(
    column: $table.isLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFormat => $composableBuilder(
    column: $table.localFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadChapterId => $composableBuilder(
    column: $table.lastReadChapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NovelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get sourceNovelUrl => $composableBuilder(
    column: $table.sourceNovelUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isLocal =>
      $composableBuilder(column: $table.isLocal, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get localFormat => $composableBuilder(
    column: $table.localFormat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReadChapterId => $composableBuilder(
    column: $table.lastReadChapterId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NovelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NovelsTable,
          Novel,
          $$NovelsTableFilterComposer,
          $$NovelsTableOrderingComposer,
          $$NovelsTableAnnotationComposer,
          $$NovelsTableCreateCompanionBuilder,
          $$NovelsTableUpdateCompanionBuilder,
          (Novel, $$NovelsTableReferences),
          Novel,
          PrefetchHooks Function({bool chaptersRefs})
        > {
  $$NovelsTableTableManager(_$AppDatabase db, $NovelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NovelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NovelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NovelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String?> sourceNovelUrl = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<bool> isLocal = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> localFormat = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> lastReadChapterId = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NovelsCompanion(
                id: id,
                title: title,
                author: author,
                coverUrl: coverUrl,
                description: description,
                sourceId: sourceId,
                sourceNovelUrl: sourceNovelUrl,
                status: status,
                isLocal: isLocal,
                localPath: localPath,
                localFormat: localFormat,
                isFavorite: isFavorite,
                lastReadChapterId: lastReadChapterId,
                lastReadAt: lastReadAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> author = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String?> sourceNovelUrl = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<bool> isLocal = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> localFormat = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> lastReadChapterId = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NovelsCompanion.insert(
                id: id,
                title: title,
                author: author,
                coverUrl: coverUrl,
                description: description,
                sourceId: sourceId,
                sourceNovelUrl: sourceNovelUrl,
                status: status,
                isLocal: isLocal,
                localPath: localPath,
                localFormat: localFormat,
                isFavorite: isFavorite,
                lastReadChapterId: lastReadChapterId,
                lastReadAt: lastReadAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NovelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({chaptersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chaptersRefs) db.chapters],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chaptersRefs)
                    await $_getPrefetchedData<Novel, $NovelsTable, Chapter>(
                      currentTable: table,
                      referencedTable: $$NovelsTableReferences
                          ._chaptersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NovelsTableReferences(db, table, p0).chaptersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.novelId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NovelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NovelsTable,
      Novel,
      $$NovelsTableFilterComposer,
      $$NovelsTableOrderingComposer,
      $$NovelsTableAnnotationComposer,
      $$NovelsTableCreateCompanionBuilder,
      $$NovelsTableUpdateCompanionBuilder,
      (Novel, $$NovelsTableReferences),
      Novel,
      PrefetchHooks Function({bool chaptersRefs})
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      Value<int> id,
      required int novelId,
      required double chapterIndex,
      required String title,
      Value<String?> url,
      Value<String?> content,
      Value<bool> isDownloaded,
      Value<bool> isRead,
      Value<double> readProgress,
      Value<DateTime?> releaseDate,
      Value<String?> localFilePath,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<int> id,
      Value<int> novelId,
      Value<double> chapterIndex,
      Value<String> title,
      Value<String?> url,
      Value<String?> content,
      Value<bool> isDownloaded,
      Value<bool> isRead,
      Value<double> readProgress,
      Value<DateTime?> releaseDate,
      Value<String?> localFilePath,
    });

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NovelsTable _novelIdTable(_$AppDatabase db) => db.novels.createAlias(
    $_aliasNameGenerator(db.chapters.novelId, db.novels.id),
  );

  $$NovelsTableProcessedTableManager get novelId {
    final $_column = $_itemColumn<int>('novel_id')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_novelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
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

  ColumnFilters<double> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get readProgress => $composableBuilder(
    column: $table.readProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get novelId {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
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

  ColumnOrderings<double> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get readProgress => $composableBuilder(
    column: $table.readProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get novelId {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<double> get readProgress => $composableBuilder(
    column: $table.readProgress,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  $$NovelsTableAnnotationComposer get novelId {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, $$ChaptersTableReferences),
          Chapter,
          PrefetchHooks Function({bool novelId})
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> novelId = const Value.absent(),
                Value<double> chapterIndex = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<bool> isDownloaded = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<double> readProgress = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                novelId: novelId,
                chapterIndex: chapterIndex,
                title: title,
                url: url,
                content: content,
                isDownloaded: isDownloaded,
                isRead: isRead,
                readProgress: readProgress,
                releaseDate: releaseDate,
                localFilePath: localFilePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int novelId,
                required double chapterIndex,
                required String title,
                Value<String?> url = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<bool> isDownloaded = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<double> readProgress = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                novelId: novelId,
                chapterIndex: chapterIndex,
                title: title,
                url: url,
                content: content,
                isDownloaded: isDownloaded,
                isRead: isRead,
                readProgress: readProgress,
                releaseDate: releaseDate,
                localFilePath: localFilePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({novelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (novelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.novelId,
                                referencedTable: $$ChaptersTableReferences
                                    ._novelIdTable(db),
                                referencedColumn: $$ChaptersTableReferences
                                    ._novelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, $$ChaptersTableReferences),
      Chapter,
      PrefetchHooks Function({bool novelId})
    >;
typedef $$SourcesTableCreateCompanionBuilder =
    SourcesCompanion Function({
      required String id,
      required String name,
      Value<String> lang,
      required String baseUrl,
      Value<String?> iconUrl,
      Value<bool> isEnabled,
      Value<bool> isCustomRepo,
      Value<String?> repoUrl,
      Value<String> version,
      Value<int> rowid,
    });
typedef $$SourcesTableUpdateCompanionBuilder =
    SourcesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> lang,
      Value<String> baseUrl,
      Value<String?> iconUrl,
      Value<bool> isEnabled,
      Value<bool> isCustomRepo,
      Value<String?> repoUrl,
      Value<String> version,
      Value<int> rowid,
    });

class $$SourcesTableFilterComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomRepo => $composableBuilder(
    column: $table.isCustomRepo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repoUrl => $composableBuilder(
    column: $table.repoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomRepo => $composableBuilder(
    column: $table.isCustomRepo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repoUrl => $composableBuilder(
    column: $table.repoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get iconUrl =>
      $composableBuilder(column: $table.iconUrl, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isCustomRepo => $composableBuilder(
    column: $table.isCustomRepo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repoUrl =>
      $composableBuilder(column: $table.repoUrl, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$SourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourcesTable,
          Source,
          $$SourcesTableFilterComposer,
          $$SourcesTableOrderingComposer,
          $$SourcesTableAnnotationComposer,
          $$SourcesTableCreateCompanionBuilder,
          $$SourcesTableUpdateCompanionBuilder,
          (Source, BaseReferences<_$AppDatabase, $SourcesTable, Source>),
          Source,
          PrefetchHooks Function()
        > {
  $$SourcesTableTableManager(_$AppDatabase db, $SourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isCustomRepo = const Value.absent(),
                Value<String?> repoUrl = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion(
                id: id,
                name: name,
                lang: lang,
                baseUrl: baseUrl,
                iconUrl: iconUrl,
                isEnabled: isEnabled,
                isCustomRepo: isCustomRepo,
                repoUrl: repoUrl,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> lang = const Value.absent(),
                required String baseUrl,
                Value<String?> iconUrl = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isCustomRepo = const Value.absent(),
                Value<String?> repoUrl = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion.insert(
                id: id,
                name: name,
                lang: lang,
                baseUrl: baseUrl,
                iconUrl: iconUrl,
                isEnabled: isEnabled,
                isCustomRepo: isCustomRepo,
                repoUrl: repoUrl,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourcesTable,
      Source,
      $$SourcesTableFilterComposer,
      $$SourcesTableOrderingComposer,
      $$SourcesTableAnnotationComposer,
      $$SourcesTableCreateCompanionBuilder,
      $$SourcesTableUpdateCompanionBuilder,
      (Source, BaseReferences<_$AppDatabase, $SourcesTable, Source>),
      Source,
      PrefetchHooks Function()
    >;
typedef $$TranslationMemoryTableCreateCompanionBuilder =
    TranslationMemoryCompanion Function({
      Value<int> id,
      required String textHash,
      required String sourceLang,
      required String targetLang,
      required String originalText,
      required String translatedText,
      required String modelUsed,
      Value<DateTime> createdAt,
    });
typedef $$TranslationMemoryTableUpdateCompanionBuilder =
    TranslationMemoryCompanion Function({
      Value<int> id,
      Value<String> textHash,
      Value<String> sourceLang,
      Value<String> targetLang,
      Value<String> originalText,
      Value<String> translatedText,
      Value<String> modelUsed,
      Value<DateTime> createdAt,
    });

class $$TranslationMemoryTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationMemoryTable> {
  $$TranslationMemoryTableFilterComposer({
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

  ColumnFilters<String> get textHash => $composableBuilder(
    column: $table.textHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelUsed => $composableBuilder(
    column: $table.modelUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TranslationMemoryTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationMemoryTable> {
  $$TranslationMemoryTableOrderingComposer({
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

  ColumnOrderings<String> get textHash => $composableBuilder(
    column: $table.textHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelUsed => $composableBuilder(
    column: $table.modelUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TranslationMemoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationMemoryTable> {
  $$TranslationMemoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textHash =>
      $composableBuilder(column: $table.textHash, builder: (column) => column);

  GeneratedColumn<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelUsed =>
      $composableBuilder(column: $table.modelUsed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TranslationMemoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TranslationMemoryTable,
          TranslationMemoryData,
          $$TranslationMemoryTableFilterComposer,
          $$TranslationMemoryTableOrderingComposer,
          $$TranslationMemoryTableAnnotationComposer,
          $$TranslationMemoryTableCreateCompanionBuilder,
          $$TranslationMemoryTableUpdateCompanionBuilder,
          (
            TranslationMemoryData,
            BaseReferences<
              _$AppDatabase,
              $TranslationMemoryTable,
              TranslationMemoryData
            >,
          ),
          TranslationMemoryData,
          PrefetchHooks Function()
        > {
  $$TranslationMemoryTableTableManager(
    _$AppDatabase db,
    $TranslationMemoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationMemoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationMemoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationMemoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> textHash = const Value.absent(),
                Value<String> sourceLang = const Value.absent(),
                Value<String> targetLang = const Value.absent(),
                Value<String> originalText = const Value.absent(),
                Value<String> translatedText = const Value.absent(),
                Value<String> modelUsed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TranslationMemoryCompanion(
                id: id,
                textHash: textHash,
                sourceLang: sourceLang,
                targetLang: targetLang,
                originalText: originalText,
                translatedText: translatedText,
                modelUsed: modelUsed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String textHash,
                required String sourceLang,
                required String targetLang,
                required String originalText,
                required String translatedText,
                required String modelUsed,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TranslationMemoryCompanion.insert(
                id: id,
                textHash: textHash,
                sourceLang: sourceLang,
                targetLang: targetLang,
                originalText: originalText,
                translatedText: translatedText,
                modelUsed: modelUsed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TranslationMemoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TranslationMemoryTable,
      TranslationMemoryData,
      $$TranslationMemoryTableFilterComposer,
      $$TranslationMemoryTableOrderingComposer,
      $$TranslationMemoryTableAnnotationComposer,
      $$TranslationMemoryTableCreateCompanionBuilder,
      $$TranslationMemoryTableUpdateCompanionBuilder,
      (
        TranslationMemoryData,
        BaseReferences<
          _$AppDatabase,
          $TranslationMemoryTable,
          TranslationMemoryData
        >,
      ),
      TranslationMemoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NovelsTableTableManager get novels =>
      $$NovelsTableTableManager(_db, _db.novels);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$TranslationMemoryTableTableManager get translationMemory =>
      $$TranslationMemoryTableTableManager(_db, _db.translationMemory);
}
