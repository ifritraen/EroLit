import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Novels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get sourceNovelUrl => text().nullable()();
  TextColumn get status => text().nullable()();
  BoolColumn get isLocal => boolean().withDefault(const Constant(false))();
  TextColumn get localPath => text().nullable()();
  TextColumn get localFormat => text().nullable()(); // epub, txt, pdf, cbz
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get lastReadChapterId => integer().nullable()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Chapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get novelId => integer().references(Novels, #id, onDelete: KeyAction.cascade)();
  RealColumn get chapterIndex => real()();
  TextColumn get title => text()();
  TextColumn get url => text().nullable()();
  TextColumn get content => text().nullable()();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  RealColumn get readProgress => real().withDefault(const Constant(0.0))();
  DateTimeColumn get releaseDate => dateTime().nullable()();
  TextColumn get localFilePath => text().nullable()();
}

class Sources extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get lang => text().withDefault(const Constant('en'))();
  TextColumn get baseUrl => text()();
  TextColumn get iconUrl => text().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustomRepo => boolean().withDefault(const Constant(false))();
  TextColumn get repoUrl => text().nullable()();
  TextColumn get version => text().withDefault(const Constant('1.0.0'))();

  @override
  Set<Column> get primaryKey => {id};
}

class TranslationMemory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textHash => text()();
  TextColumn get sourceLang => text()();
  TextColumn get targetLang => text()();
  TextColumn get originalText => text()();
  TextColumn get translatedText => text()();
  TextColumn get modelUsed => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Novels, Chapters, Sources, TranslationMemory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'erolit_database');
  }

  // Novels queries
  Future<List<Novel>> getAllFavorites() =>
      (select(novels)..where((t) => t.isFavorite.equals(true))).get();

  Future<List<Novel>> getLocalNovels() =>
      (select(novels)..where((t) => t.isLocal.equals(true))).get();

  Future<Novel?> getNovelById(int id) =>
      (select(novels)..where((t) => t.id.equals(id))).getSingleOrNull();

  // Chapters queries
  Future<List<Chapter>> getChaptersForNovel(int novelId) =>
      (select(chapters)
            ..where((t) => t.novelId.equals(novelId))
            ..orderBy([(t) => OrderingTerm(expression: t.chapterIndex)]))
          .get();

  // Translation memory queries
  Future<String?> getCachedTranslation(String hash, String targetLang) async {
    final query = select(translationMemory)
      ..where((t) => t.textHash.equals(hash) & t.targetLang.equals(targetLang));
    final result = await query.getSingleOrNull();
    return result?.translatedText;
  }
}
