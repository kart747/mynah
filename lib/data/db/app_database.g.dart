// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<BookFormat, String> format =
      GeneratedColumn<String>(
        'format',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BookFormat>($BooksTable.$converterformat);
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sentenceCountMeta = const VerificationMeta(
    'sentenceCount',
  );
  @override
  late final GeneratedColumn<int> sentenceCount = GeneratedColumn<int>(
    'sentence_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentSentenceMeta = const VerificationMeta(
    'currentSentence',
  );
  @override
  late final GeneratedColumn<int> currentSentence = GeneratedColumn<int>(
    'current_sentence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ImportStatus.pending.name),
      ).withConverter<ImportStatus>($BooksTable.$converterstatus);
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    format,
    filePath,
    coverPath,
    fileSize,
    wordCount,
    sentenceCount,
    currentSentence,
    status,
    addedAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
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
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    }
    if (data.containsKey('sentence_count')) {
      context.handle(
        _sentenceCountMeta,
        sentenceCount.isAcceptableOrUnknown(
          data['sentence_count']!,
          _sentenceCountMeta,
        ),
      );
    }
    if (data.containsKey('current_sentence')) {
      context.handle(
        _currentSentenceMeta,
        currentSentence.isAcceptableOrUnknown(
          data['current_sentence']!,
          _currentSentenceMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
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
      format: $BooksTable.$converterformat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}format'],
        )!,
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      )!,
      sentenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sentence_count'],
      )!,
      currentSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_sentence'],
      )!,
      status: $BooksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BookFormat, String, String> $converterformat =
      const EnumNameConverter<BookFormat>(BookFormat.values);
  static JsonTypeConverter2<ImportStatus, String, String> $converterstatus =
      const EnumNameConverter<ImportStatus>(ImportStatus.values);
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final String title;
  final String? author;
  final BookFormat format;

  /// Absolute path of the copy inside the app documents dir.
  final String filePath;

  /// Absolute path of the extracted cover image, if the book has one.
  final String? coverPath;
  final int fileSize;
  final int wordCount;
  final int sentenceCount;

  /// Global sentence index of the reading position (single source of truth).
  final int currentSentence;
  final ImportStatus status;
  final DateTime addedAt;
  final DateTime? lastOpenedAt;
  const Book({
    required this.id,
    required this.title,
    this.author,
    required this.format,
    required this.filePath,
    this.coverPath,
    required this.fileSize,
    required this.wordCount,
    required this.sentenceCount,
    required this.currentSentence,
    required this.status,
    required this.addedAt,
    this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    {
      map['format'] = Variable<String>(
        $BooksTable.$converterformat.toSql(format),
      );
    }
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['file_size'] = Variable<int>(fileSize);
    map['word_count'] = Variable<int>(wordCount);
    map['sentence_count'] = Variable<int>(sentenceCount);
    map['current_sentence'] = Variable<int>(currentSentence);
    {
      map['status'] = Variable<String>(
        $BooksTable.$converterstatus.toSql(status),
      );
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      format: Value(format),
      filePath: Value(filePath),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      fileSize: Value(fileSize),
      wordCount: Value(wordCount),
      sentenceCount: Value(sentenceCount),
      currentSentence: Value(currentSentence),
      status: Value(status),
      addedAt: Value(addedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      format: $BooksTable.$converterformat.fromJson(
        serializer.fromJson<String>(json['format']),
      ),
      filePath: serializer.fromJson<String>(json['filePath']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      sentenceCount: serializer.fromJson<int>(json['sentenceCount']),
      currentSentence: serializer.fromJson<int>(json['currentSentence']),
      status: $BooksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'format': serializer.toJson<String>(
        $BooksTable.$converterformat.toJson(format),
      ),
      'filePath': serializer.toJson<String>(filePath),
      'coverPath': serializer.toJson<String?>(coverPath),
      'fileSize': serializer.toJson<int>(fileSize),
      'wordCount': serializer.toJson<int>(wordCount),
      'sentenceCount': serializer.toJson<int>(sentenceCount),
      'currentSentence': serializer.toJson<int>(currentSentence),
      'status': serializer.toJson<String>(
        $BooksTable.$converterstatus.toJson(status),
      ),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  Book copyWith({
    int? id,
    String? title,
    Value<String?> author = const Value.absent(),
    BookFormat? format,
    String? filePath,
    Value<String?> coverPath = const Value.absent(),
    int? fileSize,
    int? wordCount,
    int? sentenceCount,
    int? currentSentence,
    ImportStatus? status,
    DateTime? addedAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
  }) => Book(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    format: format ?? this.format,
    filePath: filePath ?? this.filePath,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    fileSize: fileSize ?? this.fileSize,
    wordCount: wordCount ?? this.wordCount,
    sentenceCount: sentenceCount ?? this.sentenceCount,
    currentSentence: currentSentence ?? this.currentSentence,
    status: status ?? this.status,
    addedAt: addedAt ?? this.addedAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      format: data.format.present ? data.format.value : this.format,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      sentenceCount: data.sentenceCount.present
          ? data.sentenceCount.value
          : this.sentenceCount,
      currentSentence: data.currentSentence.present
          ? data.currentSentence.value
          : this.currentSentence,
      status: data.status.present ? data.status.value : this.status,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('format: $format, ')
          ..write('filePath: $filePath, ')
          ..write('coverPath: $coverPath, ')
          ..write('fileSize: $fileSize, ')
          ..write('wordCount: $wordCount, ')
          ..write('sentenceCount: $sentenceCount, ')
          ..write('currentSentence: $currentSentence, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    format,
    filePath,
    coverPath,
    fileSize,
    wordCount,
    sentenceCount,
    currentSentence,
    status,
    addedAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.format == this.format &&
          other.filePath == this.filePath &&
          other.coverPath == this.coverPath &&
          other.fileSize == this.fileSize &&
          other.wordCount == this.wordCount &&
          other.sentenceCount == this.sentenceCount &&
          other.currentSentence == this.currentSentence &&
          other.status == this.status &&
          other.addedAt == this.addedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<BookFormat> format;
  final Value<String> filePath;
  final Value<String?> coverPath;
  final Value<int> fileSize;
  final Value<int> wordCount;
  final Value<int> sentenceCount;
  final Value<int> currentSentence;
  final Value<ImportStatus> status;
  final Value<DateTime> addedAt;
  final Value<DateTime?> lastOpenedAt;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.format = const Value.absent(),
    this.filePath = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.sentenceCount = const Value.absent(),
    this.currentSentence = const Value.absent(),
    this.status = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.author = const Value.absent(),
    required BookFormat format,
    required String filePath,
    this.coverPath = const Value.absent(),
    required int fileSize,
    this.wordCount = const Value.absent(),
    this.sentenceCount = const Value.absent(),
    this.currentSentence = const Value.absent(),
    this.status = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  }) : title = Value(title),
       format = Value(format),
       filePath = Value(filePath),
       fileSize = Value(fileSize);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? format,
    Expression<String>? filePath,
    Expression<String>? coverPath,
    Expression<int>? fileSize,
    Expression<int>? wordCount,
    Expression<int>? sentenceCount,
    Expression<int>? currentSentence,
    Expression<String>? status,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (format != null) 'format': format,
      if (filePath != null) 'file_path': filePath,
      if (coverPath != null) 'cover_path': coverPath,
      if (fileSize != null) 'file_size': fileSize,
      if (wordCount != null) 'word_count': wordCount,
      if (sentenceCount != null) 'sentence_count': sentenceCount,
      if (currentSentence != null) 'current_sentence': currentSentence,
      if (status != null) 'status': status,
      if (addedAt != null) 'added_at': addedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? author,
    Value<BookFormat>? format,
    Value<String>? filePath,
    Value<String?>? coverPath,
    Value<int>? fileSize,
    Value<int>? wordCount,
    Value<int>? sentenceCount,
    Value<int>? currentSentence,
    Value<ImportStatus>? status,
    Value<DateTime>? addedAt,
    Value<DateTime?>? lastOpenedAt,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      format: format ?? this.format,
      filePath: filePath ?? this.filePath,
      coverPath: coverPath ?? this.coverPath,
      fileSize: fileSize ?? this.fileSize,
      wordCount: wordCount ?? this.wordCount,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      currentSentence: currentSentence ?? this.currentSentence,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
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
    if (format.present) {
      map['format'] = Variable<String>(
        $BooksTable.$converterformat.toSql(format.value),
      );
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (sentenceCount.present) {
      map['sentence_count'] = Variable<int>(sentenceCount.value);
    }
    if (currentSentence.present) {
      map['current_sentence'] = Variable<int>(currentSentence.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $BooksTable.$converterstatus.toSql(status.value),
      );
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('format: $format, ')
          ..write('filePath: $filePath, ')
          ..write('coverPath: $coverPath, ')
          ..write('fileSize: $fileSize, ')
          ..write('wordCount: $wordCount, ')
          ..write('sentenceCount: $sentenceCount, ')
          ..write('currentSentence: $currentSentence, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idxMeta = const VerificationMeta('idx');
  @override
  late final GeneratedColumn<int> idx = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _firstSentenceMeta = const VerificationMeta(
    'firstSentence',
  );
  @override
  late final GeneratedColumn<int> firstSentence = GeneratedColumn<int>(
    'first_sentence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceCountMeta = const VerificationMeta(
    'sentenceCount',
  );
  @override
  late final GeneratedColumn<int> sentenceCount = GeneratedColumn<int>(
    'sentence_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    idx,
    title,
    firstSentence,
    sentenceCount,
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
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _idxMeta,
        idx.isAcceptableOrUnknown(data['idx']!, _idxMeta),
      );
    } else if (isInserting) {
      context.missing(_idxMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('first_sentence')) {
      context.handle(
        _firstSentenceMeta,
        firstSentence.isAcceptableOrUnknown(
          data['first_sentence']!,
          _firstSentenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSentenceMeta);
    }
    if (data.containsKey('sentence_count')) {
      context.handle(
        _sentenceCountMeta,
        sentenceCount.isAcceptableOrUnknown(
          data['sentence_count']!,
          _sentenceCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sentenceCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId, idx};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      idx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      firstSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_sentence'],
      )!,
      sentenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sentence_count'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final int bookId;
  final int idx;
  final String title;

  /// Global index of the chapter's first sentence.
  final int firstSentence;
  final int sentenceCount;
  const Chapter({
    required this.bookId,
    required this.idx,
    required this.title,
    required this.firstSentence,
    required this.sentenceCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<int>(bookId);
    map['idx'] = Variable<int>(idx);
    map['title'] = Variable<String>(title);
    map['first_sentence'] = Variable<int>(firstSentence);
    map['sentence_count'] = Variable<int>(sentenceCount);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      bookId: Value(bookId),
      idx: Value(idx),
      title: Value(title),
      firstSentence: Value(firstSentence),
      sentenceCount: Value(sentenceCount),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      bookId: serializer.fromJson<int>(json['bookId']),
      idx: serializer.fromJson<int>(json['idx']),
      title: serializer.fromJson<String>(json['title']),
      firstSentence: serializer.fromJson<int>(json['firstSentence']),
      sentenceCount: serializer.fromJson<int>(json['sentenceCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<int>(bookId),
      'idx': serializer.toJson<int>(idx),
      'title': serializer.toJson<String>(title),
      'firstSentence': serializer.toJson<int>(firstSentence),
      'sentenceCount': serializer.toJson<int>(sentenceCount),
    };
  }

  Chapter copyWith({
    int? bookId,
    int? idx,
    String? title,
    int? firstSentence,
    int? sentenceCount,
  }) => Chapter(
    bookId: bookId ?? this.bookId,
    idx: idx ?? this.idx,
    title: title ?? this.title,
    firstSentence: firstSentence ?? this.firstSentence,
    sentenceCount: sentenceCount ?? this.sentenceCount,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      idx: data.idx.present ? data.idx.value : this.idx,
      title: data.title.present ? data.title.value : this.title,
      firstSentence: data.firstSentence.present
          ? data.firstSentence.value
          : this.firstSentence,
      sentenceCount: data.sentenceCount.present
          ? data.sentenceCount.value
          : this.sentenceCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('bookId: $bookId, ')
          ..write('idx: $idx, ')
          ..write('title: $title, ')
          ..write('firstSentence: $firstSentence, ')
          ..write('sentenceCount: $sentenceCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(bookId, idx, title, firstSentence, sentenceCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.bookId == this.bookId &&
          other.idx == this.idx &&
          other.title == this.title &&
          other.firstSentence == this.firstSentence &&
          other.sentenceCount == this.sentenceCount);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<int> bookId;
  final Value<int> idx;
  final Value<String> title;
  final Value<int> firstSentence;
  final Value<int> sentenceCount;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.bookId = const Value.absent(),
    this.idx = const Value.absent(),
    this.title = const Value.absent(),
    this.firstSentence = const Value.absent(),
    this.sentenceCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required int bookId,
    required int idx,
    required String title,
    required int firstSentence,
    required int sentenceCount,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       idx = Value(idx),
       title = Value(title),
       firstSentence = Value(firstSentence),
       sentenceCount = Value(sentenceCount);
  static Insertable<Chapter> custom({
    Expression<int>? bookId,
    Expression<int>? idx,
    Expression<String>? title,
    Expression<int>? firstSentence,
    Expression<int>? sentenceCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (idx != null) 'idx': idx,
      if (title != null) 'title': title,
      if (firstSentence != null) 'first_sentence': firstSentence,
      if (sentenceCount != null) 'sentence_count': sentenceCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<int>? bookId,
    Value<int>? idx,
    Value<String>? title,
    Value<int>? firstSentence,
    Value<int>? sentenceCount,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      bookId: bookId ?? this.bookId,
      idx: idx ?? this.idx,
      title: title ?? this.title,
      firstSentence: firstSentence ?? this.firstSentence,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (idx.present) {
      map['idx'] = Variable<int>(idx.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (firstSentence.present) {
      map['first_sentence'] = Variable<int>(firstSentence.value);
    }
    if (sentenceCount.present) {
      map['sentence_count'] = Variable<int>(sentenceCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('bookId: $bookId, ')
          ..write('idx: $idx, ')
          ..write('title: $title, ')
          ..write('firstSentence: $firstSentence, ')
          ..write('sentenceCount: $sentenceCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParagraphsTable extends Paragraphs
    with TableInfo<$ParagraphsTable, Paragraph> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParagraphsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idxMeta = const VerificationMeta('idx');
  @override
  late final GeneratedColumn<int> idx = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdxMeta = const VerificationMeta(
    'chapterIdx',
  );
  @override
  late final GeneratedColumn<int> chapterIdx = GeneratedColumn<int>(
    'chapter_idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHeadingMeta = const VerificationMeta(
    'isHeading',
  );
  @override
  late final GeneratedColumn<bool> isHeading = GeneratedColumn<bool>(
    'is_heading',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_heading" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _firstSentenceMeta = const VerificationMeta(
    'firstSentence',
  );
  @override
  late final GeneratedColumn<int> firstSentence = GeneratedColumn<int>(
    'first_sentence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceCountMeta = const VerificationMeta(
    'sentenceCount',
  );
  @override
  late final GeneratedColumn<int> sentenceCount = GeneratedColumn<int>(
    'sentence_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    idx,
    chapterIdx,
    isHeading,
    firstSentence,
    sentenceCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paragraphs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Paragraph> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _idxMeta,
        idx.isAcceptableOrUnknown(data['idx']!, _idxMeta),
      );
    } else if (isInserting) {
      context.missing(_idxMeta);
    }
    if (data.containsKey('chapter_idx')) {
      context.handle(
        _chapterIdxMeta,
        chapterIdx.isAcceptableOrUnknown(data['chapter_idx']!, _chapterIdxMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdxMeta);
    }
    if (data.containsKey('is_heading')) {
      context.handle(
        _isHeadingMeta,
        isHeading.isAcceptableOrUnknown(data['is_heading']!, _isHeadingMeta),
      );
    }
    if (data.containsKey('first_sentence')) {
      context.handle(
        _firstSentenceMeta,
        firstSentence.isAcceptableOrUnknown(
          data['first_sentence']!,
          _firstSentenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSentenceMeta);
    }
    if (data.containsKey('sentence_count')) {
      context.handle(
        _sentenceCountMeta,
        sentenceCount.isAcceptableOrUnknown(
          data['sentence_count']!,
          _sentenceCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sentenceCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId, idx};
  @override
  Paragraph map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paragraph(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      idx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      chapterIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_idx'],
      )!,
      isHeading: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_heading'],
      )!,
      firstSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_sentence'],
      )!,
      sentenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sentence_count'],
      )!,
    );
  }

  @override
  $ParagraphsTable createAlias(String alias) {
    return $ParagraphsTable(attachedDatabase, alias);
  }
}

class Paragraph extends DataClass implements Insertable<Paragraph> {
  final int bookId;
  final int idx;
  final int chapterIdx;
  final bool isHeading;
  final int firstSentence;
  final int sentenceCount;
  const Paragraph({
    required this.bookId,
    required this.idx,
    required this.chapterIdx,
    required this.isHeading,
    required this.firstSentence,
    required this.sentenceCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<int>(bookId);
    map['idx'] = Variable<int>(idx);
    map['chapter_idx'] = Variable<int>(chapterIdx);
    map['is_heading'] = Variable<bool>(isHeading);
    map['first_sentence'] = Variable<int>(firstSentence);
    map['sentence_count'] = Variable<int>(sentenceCount);
    return map;
  }

  ParagraphsCompanion toCompanion(bool nullToAbsent) {
    return ParagraphsCompanion(
      bookId: Value(bookId),
      idx: Value(idx),
      chapterIdx: Value(chapterIdx),
      isHeading: Value(isHeading),
      firstSentence: Value(firstSentence),
      sentenceCount: Value(sentenceCount),
    );
  }

  factory Paragraph.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paragraph(
      bookId: serializer.fromJson<int>(json['bookId']),
      idx: serializer.fromJson<int>(json['idx']),
      chapterIdx: serializer.fromJson<int>(json['chapterIdx']),
      isHeading: serializer.fromJson<bool>(json['isHeading']),
      firstSentence: serializer.fromJson<int>(json['firstSentence']),
      sentenceCount: serializer.fromJson<int>(json['sentenceCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<int>(bookId),
      'idx': serializer.toJson<int>(idx),
      'chapterIdx': serializer.toJson<int>(chapterIdx),
      'isHeading': serializer.toJson<bool>(isHeading),
      'firstSentence': serializer.toJson<int>(firstSentence),
      'sentenceCount': serializer.toJson<int>(sentenceCount),
    };
  }

  Paragraph copyWith({
    int? bookId,
    int? idx,
    int? chapterIdx,
    bool? isHeading,
    int? firstSentence,
    int? sentenceCount,
  }) => Paragraph(
    bookId: bookId ?? this.bookId,
    idx: idx ?? this.idx,
    chapterIdx: chapterIdx ?? this.chapterIdx,
    isHeading: isHeading ?? this.isHeading,
    firstSentence: firstSentence ?? this.firstSentence,
    sentenceCount: sentenceCount ?? this.sentenceCount,
  );
  Paragraph copyWithCompanion(ParagraphsCompanion data) {
    return Paragraph(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      idx: data.idx.present ? data.idx.value : this.idx,
      chapterIdx: data.chapterIdx.present
          ? data.chapterIdx.value
          : this.chapterIdx,
      isHeading: data.isHeading.present ? data.isHeading.value : this.isHeading,
      firstSentence: data.firstSentence.present
          ? data.firstSentence.value
          : this.firstSentence,
      sentenceCount: data.sentenceCount.present
          ? data.sentenceCount.value
          : this.sentenceCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paragraph(')
          ..write('bookId: $bookId, ')
          ..write('idx: $idx, ')
          ..write('chapterIdx: $chapterIdx, ')
          ..write('isHeading: $isHeading, ')
          ..write('firstSentence: $firstSentence, ')
          ..write('sentenceCount: $sentenceCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bookId,
    idx,
    chapterIdx,
    isHeading,
    firstSentence,
    sentenceCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paragraph &&
          other.bookId == this.bookId &&
          other.idx == this.idx &&
          other.chapterIdx == this.chapterIdx &&
          other.isHeading == this.isHeading &&
          other.firstSentence == this.firstSentence &&
          other.sentenceCount == this.sentenceCount);
}

class ParagraphsCompanion extends UpdateCompanion<Paragraph> {
  final Value<int> bookId;
  final Value<int> idx;
  final Value<int> chapterIdx;
  final Value<bool> isHeading;
  final Value<int> firstSentence;
  final Value<int> sentenceCount;
  final Value<int> rowid;
  const ParagraphsCompanion({
    this.bookId = const Value.absent(),
    this.idx = const Value.absent(),
    this.chapterIdx = const Value.absent(),
    this.isHeading = const Value.absent(),
    this.firstSentence = const Value.absent(),
    this.sentenceCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParagraphsCompanion.insert({
    required int bookId,
    required int idx,
    required int chapterIdx,
    this.isHeading = const Value.absent(),
    required int firstSentence,
    required int sentenceCount,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       idx = Value(idx),
       chapterIdx = Value(chapterIdx),
       firstSentence = Value(firstSentence),
       sentenceCount = Value(sentenceCount);
  static Insertable<Paragraph> custom({
    Expression<int>? bookId,
    Expression<int>? idx,
    Expression<int>? chapterIdx,
    Expression<bool>? isHeading,
    Expression<int>? firstSentence,
    Expression<int>? sentenceCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (idx != null) 'idx': idx,
      if (chapterIdx != null) 'chapter_idx': chapterIdx,
      if (isHeading != null) 'is_heading': isHeading,
      if (firstSentence != null) 'first_sentence': firstSentence,
      if (sentenceCount != null) 'sentence_count': sentenceCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParagraphsCompanion copyWith({
    Value<int>? bookId,
    Value<int>? idx,
    Value<int>? chapterIdx,
    Value<bool>? isHeading,
    Value<int>? firstSentence,
    Value<int>? sentenceCount,
    Value<int>? rowid,
  }) {
    return ParagraphsCompanion(
      bookId: bookId ?? this.bookId,
      idx: idx ?? this.idx,
      chapterIdx: chapterIdx ?? this.chapterIdx,
      isHeading: isHeading ?? this.isHeading,
      firstSentence: firstSentence ?? this.firstSentence,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (idx.present) {
      map['idx'] = Variable<int>(idx.value);
    }
    if (chapterIdx.present) {
      map['chapter_idx'] = Variable<int>(chapterIdx.value);
    }
    if (isHeading.present) {
      map['is_heading'] = Variable<bool>(isHeading.value);
    }
    if (firstSentence.present) {
      map['first_sentence'] = Variable<int>(firstSentence.value);
    }
    if (sentenceCount.present) {
      map['sentence_count'] = Variable<int>(sentenceCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParagraphsCompanion(')
          ..write('bookId: $bookId, ')
          ..write('idx: $idx, ')
          ..write('chapterIdx: $chapterIdx, ')
          ..write('isHeading: $isHeading, ')
          ..write('firstSentence: $firstSentence, ')
          ..write('sentenceCount: $sentenceCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SentencesTable extends Sentences
    with TableInfo<$SentencesTable, Sentence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SentencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idxMeta = const VerificationMeta('idx');
  @override
  late final GeneratedColumn<int> idx = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdxMeta = const VerificationMeta(
    'chapterIdx',
  );
  @override
  late final GeneratedColumn<int> chapterIdx = GeneratedColumn<int>(
    'chapter_idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paragraphIdxMeta = const VerificationMeta(
    'paragraphIdx',
  );
  @override
  late final GeneratedColumn<int> paragraphIdx = GeneratedColumn<int>(
    'paragraph_idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    idx,
    chapterIdx,
    paragraphIdx,
    content,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sentences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sentence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _idxMeta,
        idx.isAcceptableOrUnknown(data['idx']!, _idxMeta),
      );
    } else if (isInserting) {
      context.missing(_idxMeta);
    }
    if (data.containsKey('chapter_idx')) {
      context.handle(
        _chapterIdxMeta,
        chapterIdx.isAcceptableOrUnknown(data['chapter_idx']!, _chapterIdxMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdxMeta);
    }
    if (data.containsKey('paragraph_idx')) {
      context.handle(
        _paragraphIdxMeta,
        paragraphIdx.isAcceptableOrUnknown(
          data['paragraph_idx']!,
          _paragraphIdxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paragraphIdxMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId, idx};
  @override
  Sentence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sentence(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      idx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      chapterIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_idx'],
      )!,
      paragraphIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paragraph_idx'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  $SentencesTable createAlias(String alias) {
    return $SentencesTable(attachedDatabase, alias);
  }
}

class Sentence extends DataClass implements Insertable<Sentence> {
  final int bookId;

  /// Global, 0-based, in reading order.
  final int idx;
  final int chapterIdx;
  final int paragraphIdx;
  final String content;
  const Sentence({
    required this.bookId,
    required this.idx,
    required this.chapterIdx,
    required this.paragraphIdx,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<int>(bookId);
    map['idx'] = Variable<int>(idx);
    map['chapter_idx'] = Variable<int>(chapterIdx);
    map['paragraph_idx'] = Variable<int>(paragraphIdx);
    map['content'] = Variable<String>(content);
    return map;
  }

  SentencesCompanion toCompanion(bool nullToAbsent) {
    return SentencesCompanion(
      bookId: Value(bookId),
      idx: Value(idx),
      chapterIdx: Value(chapterIdx),
      paragraphIdx: Value(paragraphIdx),
      content: Value(content),
    );
  }

  factory Sentence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sentence(
      bookId: serializer.fromJson<int>(json['bookId']),
      idx: serializer.fromJson<int>(json['idx']),
      chapterIdx: serializer.fromJson<int>(json['chapterIdx']),
      paragraphIdx: serializer.fromJson<int>(json['paragraphIdx']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<int>(bookId),
      'idx': serializer.toJson<int>(idx),
      'chapterIdx': serializer.toJson<int>(chapterIdx),
      'paragraphIdx': serializer.toJson<int>(paragraphIdx),
      'content': serializer.toJson<String>(content),
    };
  }

  Sentence copyWith({
    int? bookId,
    int? idx,
    int? chapterIdx,
    int? paragraphIdx,
    String? content,
  }) => Sentence(
    bookId: bookId ?? this.bookId,
    idx: idx ?? this.idx,
    chapterIdx: chapterIdx ?? this.chapterIdx,
    paragraphIdx: paragraphIdx ?? this.paragraphIdx,
    content: content ?? this.content,
  );
  Sentence copyWithCompanion(SentencesCompanion data) {
    return Sentence(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      idx: data.idx.present ? data.idx.value : this.idx,
      chapterIdx: data.chapterIdx.present
          ? data.chapterIdx.value
          : this.chapterIdx,
      paragraphIdx: data.paragraphIdx.present
          ? data.paragraphIdx.value
          : this.paragraphIdx,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sentence(')
          ..write('bookId: $bookId, ')
          ..write('idx: $idx, ')
          ..write('chapterIdx: $chapterIdx, ')
          ..write('paragraphIdx: $paragraphIdx, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(bookId, idx, chapterIdx, paragraphIdx, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sentence &&
          other.bookId == this.bookId &&
          other.idx == this.idx &&
          other.chapterIdx == this.chapterIdx &&
          other.paragraphIdx == this.paragraphIdx &&
          other.content == this.content);
}

class SentencesCompanion extends UpdateCompanion<Sentence> {
  final Value<int> bookId;
  final Value<int> idx;
  final Value<int> chapterIdx;
  final Value<int> paragraphIdx;
  final Value<String> content;
  final Value<int> rowid;
  const SentencesCompanion({
    this.bookId = const Value.absent(),
    this.idx = const Value.absent(),
    this.chapterIdx = const Value.absent(),
    this.paragraphIdx = const Value.absent(),
    this.content = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SentencesCompanion.insert({
    required int bookId,
    required int idx,
    required int chapterIdx,
    required int paragraphIdx,
    required String content,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       idx = Value(idx),
       chapterIdx = Value(chapterIdx),
       paragraphIdx = Value(paragraphIdx),
       content = Value(content);
  static Insertable<Sentence> custom({
    Expression<int>? bookId,
    Expression<int>? idx,
    Expression<int>? chapterIdx,
    Expression<int>? paragraphIdx,
    Expression<String>? content,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (idx != null) 'idx': idx,
      if (chapterIdx != null) 'chapter_idx': chapterIdx,
      if (paragraphIdx != null) 'paragraph_idx': paragraphIdx,
      if (content != null) 'content': content,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SentencesCompanion copyWith({
    Value<int>? bookId,
    Value<int>? idx,
    Value<int>? chapterIdx,
    Value<int>? paragraphIdx,
    Value<String>? content,
    Value<int>? rowid,
  }) {
    return SentencesCompanion(
      bookId: bookId ?? this.bookId,
      idx: idx ?? this.idx,
      chapterIdx: chapterIdx ?? this.chapterIdx,
      paragraphIdx: paragraphIdx ?? this.paragraphIdx,
      content: content ?? this.content,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (idx.present) {
      map['idx'] = Variable<int>(idx.value);
    }
    if (chapterIdx.present) {
      map['chapter_idx'] = Variable<int>(chapterIdx.value);
    }
    if (paragraphIdx.present) {
      map['paragraph_idx'] = Variable<int>(paragraphIdx.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentencesCompanion(')
          ..write('bookId: $bookId, ')
          ..write('idx: $idx, ')
          ..write('chapterIdx: $chapterIdx, ')
          ..write('paragraphIdx: $paragraphIdx, ')
          ..write('content: $content, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $ParagraphsTable paragraphs = $ParagraphsTable(this);
  late final $SentencesTable sentences = $SentencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    chapters,
    paragraphs,
    sentences,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chapters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('paragraphs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sentences', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> author,
      required BookFormat format,
      required String filePath,
      Value<String?> coverPath,
      required int fileSize,
      Value<int> wordCount,
      Value<int> sentenceCount,
      Value<int> currentSentence,
      Value<ImportStatus> status,
      Value<DateTime> addedAt,
      Value<DateTime?> lastOpenedAt,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> author,
      Value<BookFormat> format,
      Value<String> filePath,
      Value<String?> coverPath,
      Value<int> fileSize,
      Value<int> wordCount,
      Value<int> sentenceCount,
      Value<int> currentSentence,
      Value<ImportStatus> status,
      Value<DateTime> addedAt,
      Value<DateTime?> lastOpenedAt,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, Book> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: 'books__id__chapters__book_id',
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ParagraphsTable, List<Paragraph>>
  _paragraphsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paragraphs,
    aliasName: 'books__id__paragraphs__book_id',
  );

  $$ParagraphsTableProcessedTableManager get paragraphsRefs {
    final manager = $$ParagraphsTableTableManager(
      $_db,
      $_db.paragraphs,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paragraphsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SentencesTable, List<Sentence>>
  _sentencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sentences,
    aliasName: 'books__id__sentences__book_id',
  );

  $$SentencesTableProcessedTableManager get sentencesRefs {
    final manager = $$SentencesTableTableManager(
      $_db,
      $_db.sentences,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sentencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
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

  ColumnWithTypeConverterFilters<BookFormat, BookFormat, String> get format =>
      $composableBuilder(
        column: $table.format,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentSentence => $composableBuilder(
    column: $table.currentSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ImportStatus, ImportStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.bookId,
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

  Expression<bool> paragraphsRefs(
    Expression<bool> Function($$ParagraphsTableFilterComposer f) f,
  ) {
    final $$ParagraphsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paragraphs,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParagraphsTableFilterComposer(
            $db: $db,
            $table: $db.paragraphs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sentencesRefs(
    Expression<bool> Function($$SentencesTableFilterComposer f) f,
  ) {
    final $$SentencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SentencesTableFilterComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
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

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentSentence => $composableBuilder(
    column: $table.currentSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<BookFormat, String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentSentence => $composableBuilder(
    column: $table.currentSentence,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ImportStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.bookId,
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

  Expression<T> paragraphsRefs<T extends Object>(
    Expression<T> Function($$ParagraphsTableAnnotationComposer a) f,
  ) {
    final $$ParagraphsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paragraphs,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParagraphsTableAnnotationComposer(
            $db: $db,
            $table: $db.paragraphs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sentencesRefs<T extends Object>(
    Expression<T> Function($$SentencesTableAnnotationComposer a) f,
  ) {
    final $$SentencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SentencesTableAnnotationComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, $$BooksTableReferences),
          Book,
          PrefetchHooks Function({
            bool chaptersRefs,
            bool paragraphsRefs,
            bool sentencesRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<BookFormat> format = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<int> sentenceCount = const Value.absent(),
                Value<int> currentSentence = const Value.absent(),
                Value<ImportStatus> status = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                title: title,
                author: author,
                format: format,
                filePath: filePath,
                coverPath: coverPath,
                fileSize: fileSize,
                wordCount: wordCount,
                sentenceCount: sentenceCount,
                currentSentence: currentSentence,
                status: status,
                addedAt: addedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> author = const Value.absent(),
                required BookFormat format,
                required String filePath,
                Value<String?> coverPath = const Value.absent(),
                required int fileSize,
                Value<int> wordCount = const Value.absent(),
                Value<int> sentenceCount = const Value.absent(),
                Value<int> currentSentence = const Value.absent(),
                Value<ImportStatus> status = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                title: title,
                author: author,
                format: format,
                filePath: filePath,
                coverPath: coverPath,
                fileSize: fileSize,
                wordCount: wordCount,
                sentenceCount: sentenceCount,
                currentSentence: currentSentence,
                status: status,
                addedAt: addedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BooksTable, Book>(table),
                  $$BooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersRefs = false,
                paragraphsRefs = false,
                sentencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (paragraphsRefs) db.paragraphs,
                    if (sentencesRefs) db.sentences,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          $BooksTable,
                          Chapter,
                          $ChaptersTable
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._chaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                      if (paragraphsRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          $BooksTable,
                          Paragraph,
                          $ParagraphsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._paragraphsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).paragraphsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                      if (sentencesRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          $BooksTable,
                          Sentence,
                          $SentencesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._sentencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).sentencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, $$BooksTableReferences),
      Book,
      PrefetchHooks Function({
        bool chaptersRefs,
        bool paragraphsRefs,
        bool sentencesRefs,
      })
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      required int bookId,
      required int idx,
      required String title,
      required int firstSentence,
      required int sentenceCount,
      Value<int> rowid,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<int> bookId,
      Value<int> idx,
      Value<String> title,
      Value<int> firstSentence,
      Value<int> sentenceCount,
      Value<int> rowid,
    });

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('chapters__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
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
  ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstSentence => $composableBuilder(
    column: $table.firstSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
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
  ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstSentence => $composableBuilder(
    column: $table.firstSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
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
  GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get firstSentence => $composableBuilder(
    column: $table.firstSentence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => column,
  );

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
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
          PrefetchHooks Function({bool bookId})
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
                Value<int> bookId = const Value.absent(),
                Value<int> idx = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> firstSentence = const Value.absent(),
                Value<int> sentenceCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                bookId: bookId,
                idx: idx,
                title: title,
                firstSentence: firstSentence,
                sentenceCount: sentenceCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int bookId,
                required int idx,
                required String title,
                required int firstSentence,
                required int sentenceCount,
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                bookId: bookId,
                idx: idx,
                title: title,
                firstSentence: firstSentence,
                sentenceCount: sentenceCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChaptersTable, Chapter>(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
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
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$ChaptersTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$ChaptersTableReferences
                                    ._bookIdTable(db)
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
      PrefetchHooks Function({bool bookId})
    >;
typedef $$ParagraphsTableCreateCompanionBuilder =
    ParagraphsCompanion Function({
      required int bookId,
      required int idx,
      required int chapterIdx,
      Value<bool> isHeading,
      required int firstSentence,
      required int sentenceCount,
      Value<int> rowid,
    });
typedef $$ParagraphsTableUpdateCompanionBuilder =
    ParagraphsCompanion Function({
      Value<int> bookId,
      Value<int> idx,
      Value<int> chapterIdx,
      Value<bool> isHeading,
      Value<int> firstSentence,
      Value<int> sentenceCount,
      Value<int> rowid,
    });

final class $$ParagraphsTableReferences
    extends BaseReferences<_$AppDatabase, $ParagraphsTable, Paragraph> {
  $$ParagraphsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('paragraphs__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ParagraphsTableFilterComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterIdx => $composableBuilder(
    column: $table.chapterIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHeading => $composableBuilder(
    column: $table.isHeading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstSentence => $composableBuilder(
    column: $table.firstSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParagraphsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterIdx => $composableBuilder(
    column: $table.chapterIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHeading => $composableBuilder(
    column: $table.isHeading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstSentence => $composableBuilder(
    column: $table.firstSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParagraphsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  GeneratedColumn<int> get chapterIdx => $composableBuilder(
    column: $table.chapterIdx,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHeading =>
      $composableBuilder(column: $table.isHeading, builder: (column) => column);

  GeneratedColumn<int> get firstSentence => $composableBuilder(
    column: $table.firstSentence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sentenceCount => $composableBuilder(
    column: $table.sentenceCount,
    builder: (column) => column,
  );

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParagraphsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParagraphsTable,
          Paragraph,
          $$ParagraphsTableFilterComposer,
          $$ParagraphsTableOrderingComposer,
          $$ParagraphsTableAnnotationComposer,
          $$ParagraphsTableCreateCompanionBuilder,
          $$ParagraphsTableUpdateCompanionBuilder,
          (Paragraph, $$ParagraphsTableReferences),
          Paragraph,
          PrefetchHooks Function({bool bookId})
        > {
  $$ParagraphsTableTableManager(_$AppDatabase db, $ParagraphsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParagraphsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParagraphsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParagraphsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> bookId = const Value.absent(),
                Value<int> idx = const Value.absent(),
                Value<int> chapterIdx = const Value.absent(),
                Value<bool> isHeading = const Value.absent(),
                Value<int> firstSentence = const Value.absent(),
                Value<int> sentenceCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParagraphsCompanion(
                bookId: bookId,
                idx: idx,
                chapterIdx: chapterIdx,
                isHeading: isHeading,
                firstSentence: firstSentence,
                sentenceCount: sentenceCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int bookId,
                required int idx,
                required int chapterIdx,
                Value<bool> isHeading = const Value.absent(),
                required int firstSentence,
                required int sentenceCount,
                Value<int> rowid = const Value.absent(),
              }) => ParagraphsCompanion.insert(
                bookId: bookId,
                idx: idx,
                chapterIdx: chapterIdx,
                isHeading: isHeading,
                firstSentence: firstSentence,
                sentenceCount: sentenceCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ParagraphsTable, Paragraph>(table),
                  $$ParagraphsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
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
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$ParagraphsTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$ParagraphsTableReferences
                                    ._bookIdTable(db)
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

typedef $$ParagraphsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParagraphsTable,
      Paragraph,
      $$ParagraphsTableFilterComposer,
      $$ParagraphsTableOrderingComposer,
      $$ParagraphsTableAnnotationComposer,
      $$ParagraphsTableCreateCompanionBuilder,
      $$ParagraphsTableUpdateCompanionBuilder,
      (Paragraph, $$ParagraphsTableReferences),
      Paragraph,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$SentencesTableCreateCompanionBuilder =
    SentencesCompanion Function({
      required int bookId,
      required int idx,
      required int chapterIdx,
      required int paragraphIdx,
      required String content,
      Value<int> rowid,
    });
typedef $$SentencesTableUpdateCompanionBuilder =
    SentencesCompanion Function({
      Value<int> bookId,
      Value<int> idx,
      Value<int> chapterIdx,
      Value<int> paragraphIdx,
      Value<String> content,
      Value<int> rowid,
    });

final class $$SentencesTableReferences
    extends BaseReferences<_$AppDatabase, $SentencesTable, Sentence> {
  $$SentencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('sentences__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SentencesTableFilterComposer
    extends Composer<_$AppDatabase, $SentencesTable> {
  $$SentencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterIdx => $composableBuilder(
    column: $table.chapterIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paragraphIdx => $composableBuilder(
    column: $table.paragraphIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SentencesTableOrderingComposer
    extends Composer<_$AppDatabase, $SentencesTable> {
  $$SentencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterIdx => $composableBuilder(
    column: $table.chapterIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paragraphIdx => $composableBuilder(
    column: $table.paragraphIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SentencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SentencesTable> {
  $$SentencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  GeneratedColumn<int> get chapterIdx => $composableBuilder(
    column: $table.chapterIdx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paragraphIdx => $composableBuilder(
    column: $table.paragraphIdx,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SentencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SentencesTable,
          Sentence,
          $$SentencesTableFilterComposer,
          $$SentencesTableOrderingComposer,
          $$SentencesTableAnnotationComposer,
          $$SentencesTableCreateCompanionBuilder,
          $$SentencesTableUpdateCompanionBuilder,
          (Sentence, $$SentencesTableReferences),
          Sentence,
          PrefetchHooks Function({bool bookId})
        > {
  $$SentencesTableTableManager(_$AppDatabase db, $SentencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SentencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SentencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SentencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> bookId = const Value.absent(),
                Value<int> idx = const Value.absent(),
                Value<int> chapterIdx = const Value.absent(),
                Value<int> paragraphIdx = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SentencesCompanion(
                bookId: bookId,
                idx: idx,
                chapterIdx: chapterIdx,
                paragraphIdx: paragraphIdx,
                content: content,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int bookId,
                required int idx,
                required int chapterIdx,
                required int paragraphIdx,
                required String content,
                Value<int> rowid = const Value.absent(),
              }) => SentencesCompanion.insert(
                bookId: bookId,
                idx: idx,
                chapterIdx: chapterIdx,
                paragraphIdx: paragraphIdx,
                content: content,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SentencesTable, Sentence>(table),
                  $$SentencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
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
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$SentencesTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$SentencesTableReferences
                                    ._bookIdTable(db)
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

typedef $$SentencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SentencesTable,
      Sentence,
      $$SentencesTableFilterComposer,
      $$SentencesTableOrderingComposer,
      $$SentencesTableAnnotationComposer,
      $$SentencesTableCreateCompanionBuilder,
      $$SentencesTableUpdateCompanionBuilder,
      (Sentence, $$SentencesTableReferences),
      Sentence,
      PrefetchHooks Function({bool bookId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$ParagraphsTableTableManager get paragraphs =>
      $$ParagraphsTableTableManager(_db, _db.paragraphs);
  $$SentencesTableTableManager get sentences =>
      $$SentencesTableTableManager(_db, _db.sentences);
}
