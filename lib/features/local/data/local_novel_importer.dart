import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../parsers/comic_archive_parser.dart';
import '../parsers/epub_parser.dart';
import '../parsers/txt_parser.dart';

final localNovelImporterProvider = Provider<LocalNovelImporter>((ref) {
  final db = ref.watch(databaseProvider);
  return LocalNovelImporter(db);
});

class LocalNovelImporter {
  final AppDatabase db;

  LocalNovelImporter(this.db);

  /// Opens the system file picker to select supported story/novel files
  Future<List<int>> pickAndImportFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['epub', 'txt', 'pdf', 'cbz', 'cbr', 'zip'],
    );

    if (result == null || result.files.isEmpty) {
      return [];
    }

    final List<int> importedNovelIds = [];

    for (final platformFile in result.files) {
      if (platformFile.path == null) continue;
      final file = File(platformFile.path!);
      if (!await file.exists()) continue;

      final novelId = await importFile(file);
      if (novelId != null) {
        importedNovelIds.add(novelId);
      }
    }

    return importedNovelIds;
  }

  /// Imports a single file into the Drift database based on its format
  Future<int?> importFile(File file) async {
    final ext = p.extension(file.path).toLowerCase();

    if (ext == '.txt') {
      return _importTxt(file);
    } else if (ext == '.epub') {
      return _importEpub(file);
    } else if (ext == '.pdf') {
      return _importPdf(file);
    } else if (ext == '.cbz' || ext == '.zip') {
      return _importComic(file);
    }

    return null;
  }

  Future<int> _importTxt(File file) async {
    final parsed = await TxtParser.parseFile(file);

    final novelId = await db.into(db.novels).insert(
      NovelsCompanion(
        title: Value(parsed.title),
        isLocal: const Value(true),
        localPath: Value(file.path),
        localFormat: const Value('txt'),
        isFavorite: const Value(true),
        createdAt: Value(DateTime.now()),
      ),
    );

    for (final ch in parsed.chapters) {
      await db.into(db.chapters).insert(
        ChaptersCompanion(
          novelId: Value(novelId),
          chapterIndex: Value(ch.index),
          title: Value(ch.title),
          content: Value(ch.content),
          isDownloaded: const Value(true),
        ),
      );
    }

    return novelId;
  }

  Future<int> _importEpub(File file) async {
    final parsed = await EpubNovelParser.parseFile(file);

    final novelId = await db.into(db.novels).insert(
      NovelsCompanion(
        title: Value(parsed.title),
        author: Value(parsed.author),
        coverUrl: Value(parsed.coverPath),
        isLocal: const Value(true),
        localPath: Value(file.path),
        localFormat: const Value('epub'),
        isFavorite: const Value(true),
        createdAt: Value(DateTime.now()),
      ),
    );

    for (final ch in parsed.chapters) {
      await db.into(db.chapters).insert(
        ChaptersCompanion(
          novelId: Value(novelId),
          chapterIndex: Value(ch.index),
          title: Value(ch.title),
          content: Value(ch.content),
          isDownloaded: const Value(true),
        ),
      );
    }

    return novelId;
  }

  Future<int> _importPdf(File file) async {
    final title = p.basenameWithoutExtension(file.path);

    final novelId = await db.into(db.novels).insert(
      NovelsCompanion(
        title: Value(title),
        isLocal: const Value(true),
        localPath: Value(file.path),
        localFormat: const Value('pdf'),
        isFavorite: const Value(true),
        createdAt: Value(DateTime.now()),
      ),
    );

    // Single document chapter for PDF
    await db.into(db.chapters).insert(
      ChaptersCompanion(
        novelId: Value(novelId),
        chapterIndex: const Value(1.0),
        title: Value(title),
        localFilePath: Value(file.path),
        isDownloaded: const Value(true),
      ),
    );

    return novelId;
  }

  Future<int> _importComic(File file) async {
    final parsed = await ComicArchiveParser.parseFile(file);

    final novelId = await db.into(db.novels).insert(
      NovelsCompanion(
        title: Value(parsed.title),
        coverUrl: Value(parsed.coverPath),
        isLocal: const Value(true),
        localPath: Value(file.path),
        localFormat: const Value('cbz'),
        isFavorite: const Value(true),
        createdAt: Value(DateTime.now()),
      ),
    );

    // Save comic pages as individual chapters/page entries
    for (final page in parsed.pages) {
      await db.into(db.chapters).insert(
        ChaptersCompanion(
          novelId: Value(novelId),
          chapterIndex: Value(page.pageIndex.toDouble()),
          title: Value('Page ${page.pageIndex}'),
          localFilePath: Value(page.filePath),
          isDownloaded: const Value(true),
        ),
      );
    }

    return novelId;
  }
}
