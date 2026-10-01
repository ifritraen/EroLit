import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../models/reader_settings.dart';

class ReaderState {
  final Novel? novel;
  final List<Chapter> chapters;
  final Chapter? currentChapter;
  final int currentChapterIdx;
  final bool showControls;
  final ReaderSettings settings;
  final bool isLoading;
  final List<String> paragraphs;

  const ReaderState({
    this.novel,
    this.chapters = const [],
    this.currentChapter,
    this.currentChapterIdx = 0,
    this.showControls = false,
    this.settings = const ReaderSettings(),
    this.isLoading = true,
    this.paragraphs = const [],
  });

  ReaderState copyWith({
    Novel? novel,
    List<Chapter>? chapters,
    Chapter? currentChapter,
    int? currentChapterIdx,
    bool? showControls,
    ReaderSettings? settings,
    bool? isLoading,
    List<String>? paragraphs,
  }) {
    return ReaderState(
      novel: novel ?? this.novel,
      chapters: chapters ?? this.chapters,
      currentChapter: currentChapter ?? this.currentChapter,
      currentChapterIdx: currentChapterIdx ?? this.currentChapterIdx,
      showControls: showControls ?? this.showControls,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      paragraphs: paragraphs ?? this.paragraphs,
    );
  }
}

class ReaderController extends StateNotifier<ReaderState> {
  final AppDatabase db;
  final int novelId;
  final int? initialChapterId;

  ReaderController(this.db, {required this.novelId, this.initialChapterId})
      : super(const ReaderState()) {
    _loadNovelAndChapters();
  }

  Future<void> _loadNovelAndChapters() async {
    state = state.copyWith(isLoading: true);

    final novel = await db.getNovelById(novelId);
    final chapters = await db.getChaptersForNovel(novelId);

    if (chapters.isEmpty) {
      state = state.copyWith(novel: novel, chapters: [], isLoading: false);
      return;
    }

    int activeIdx = 0;
    if (initialChapterId != null) {
      final found = chapters.indexWhere((c) => c.id == initialChapterId);
      if (found != -1) activeIdx = found;
    } else if (novel?.lastReadChapterId != null) {
      final found = chapters.indexWhere((c) => c.id == novel!.lastReadChapterId);
      if (found != -1) activeIdx = found;
    }

    final activeChapter = chapters[activeIdx];
    final paragraphs = _splitIntoParagraphs(activeChapter.content ?? '');

    state = state.copyWith(
      novel: novel,
      chapters: chapters,
      currentChapter: activeChapter,
      currentChapterIdx: activeIdx,
      paragraphs: paragraphs,
      isLoading: false,
    );

    _markChapterRead(activeChapter.id);
  }

  List<String> _splitIntoParagraphs(String content) {
    if (content.isEmpty) return [];
    return content
        .split(RegExp(r'\r?\n\s*\r?\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  void toggleControls() {
    state = state.copyWith(showControls: !state.showControls);
  }

  void hideControls() {
    if (state.showControls) {
      state = state.copyWith(showControls: false);
    }
  }

  void updateSettings(ReaderSettings newSettings) {
    state = state.copyWith(settings: newSettings);
  }

  Future<void> jumpToChapter(int chapterIndex) async {
    if (chapterIndex < 0 || chapterIndex >= state.chapters.length) return;

    final targetChapter = state.chapters[chapterIndex];
    final paragraphs = _splitIntoParagraphs(targetChapter.content ?? '');

    state = state.copyWith(
      currentChapter: targetChapter,
      currentChapterIdx: chapterIndex,
      paragraphs: paragraphs,
    );

    _markChapterRead(targetChapter.id);
  }

  Future<void> nextChapter() async {
    if (state.currentChapterIdx + 1 < state.chapters.length) {
      await jumpToChapter(state.currentChapterIdx + 1);
    }
  }

  Future<void> previousChapter() async {
    if (state.currentChapterIdx > 0) {
      await jumpToChapter(state.currentChapterIdx - 1);
    }
  }

  Future<void> updateReadingProgress(double progress) async {
    final chapter = state.currentChapter;
    if (chapter == null) return;

    // Update in Drift DB
    await (db.update(db.chapters)..where((t) => t.id.equals(chapter.id))).write(
      ChaptersCompanion(
        readProgress: Value(progress),
        isRead: Value(progress >= 0.95),
      ),
    );
  }

  Future<void> _markChapterRead(int chapterId) async {
    await (db.update(db.novels)..where((t) => t.id.equals(novelId))).write(
      NovelsCompanion(
        lastReadChapterId: Value(chapterId),
        lastReadAt: Value(DateTime.now()),
      ),
    );
  }
}

final readerControllerProvider = StateNotifierProvider.autoDispose
    .family<ReaderController, ReaderState, ({int novelId, int? chapterId})>(
  (ref, params) {
    final db = ref.watch(databaseProvider);
    return ReaderController(
      db,
      novelId: params.novelId,
      initialChapterId: params.chapterId,
    );
  },
);
