import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

final localNovelsStreamProvider = StreamProvider<List<Novel>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.novels)
        ..where((t) => t.isLocal.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final selectedFormatFilterProvider = StateProvider<String?>((ref) => null);
