import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

final lastReadNovelStreamProvider = StreamProvider<({Novel novel, Chapter? chapter})?>((ref) {
  final db = ref.watch(databaseProvider);

  // Watch the most recently read novel
  return (db.select(db.novels)
        ..where((t) => t.lastReadAt.isNotNull())
        ..orderBy([(t) => OrderingTerm.desc(t.lastReadAt)])
        ..limit(1))
      .watchSingleOrNull()
      .asyncMap((novel) async {
    if (novel == null) return null;

    Chapter? chapter;
    if (novel.lastReadChapterId != null) {
      chapter = await (db.select(db.chapters)
            ..where((t) => t.id.equals(novel.lastReadChapterId!)))
          .getSingleOrNull();
    }
    return (novel: novel, chapter: chapter);
  });
});
