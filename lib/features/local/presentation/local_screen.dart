import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database_provider.dart';
import '../data/local_novel_importer.dart';
import 'local_novels_provider.dart';

class LocalScreen extends ConsumerWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final novelsAsync = ref.watch(localNovelsStreamProvider);
    final activeFilter = ref.watch(selectedFormatFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Shelf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(localNovelsStreamProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleImport(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Import Story'),
      ),
      body: Column(
        children: [
          // Format filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Formats'),
                    selected: activeFilter == null,
                    onSelected: (_) {
                      ref.read(selectedFormatFilterProvider.notifier).state = null;
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('EPUB'),
                    selected: activeFilter == 'epub',
                    onSelected: (_) {
                      ref.read(selectedFormatFilterProvider.notifier).state = 'epub';
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('TXT'),
                    selected: activeFilter == 'txt',
                    onSelected: (_) {
                      ref.read(selectedFormatFilterProvider.notifier).state = 'txt';
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('PDF'),
                    selected: activeFilter == 'pdf',
                    onSelected: (_) {
                      ref.read(selectedFormatFilterProvider.notifier).state = 'pdf';
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('CBZ / CBR'),
                    selected: activeFilter == 'cbz',
                    onSelected: (_) {
                      ref.read(selectedFormatFilterProvider.notifier).state = 'cbz';
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: novelsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading shelf: $err')),
              data: (allNovels) {
                final novels = activeFilter == null
                    ? allNovels
                    : allNovels
                        .where((n) => n.localFormat?.toLowerCase() == activeFilter)
                        .toList();

                if (novels.isEmpty) {
                  return _buildEmptyState(context, ref, theme);
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: novels.length,
                  itemBuilder: (context, index) {
                    final novel = novels[index];
                    return _NovelGridCard(novel: novel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final importer = ref.read(localNovelImporterProvider);
      final imported = await importer.pickAndImportFiles();
      if (imported.isNotEmpty) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully imported ${imported.length} stories!')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to import: $e')),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Your local shelf is empty',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Import EPUB, TXT, PDF, or Comic CBZ files to read offline',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _handleImport(context, ref),
              icon: const Icon(Icons.file_open_outlined),
              label: const Text('Select Files'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NovelGridCard extends ConsumerWidget {
  final dynamic novel;

  const _NovelGridCard({required this.novel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final format = (novel.localFormat ?? 'TXT').toString().toUpperCase();

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push('/reader/${novel.id}');
        },
        onLongPress: () {
          _confirmDelete(context, ref);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover / Thumbnail Area
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildCover(novel, theme),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        format,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Novel Info
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    novel.title ?? 'Untitled',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    novel.author?.isNotEmpty == true ? novel.author! : 'Local File',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(dynamic novel, ThemeData theme) {
    if (novel.coverUrl != null && File(novel.coverUrl!).existsSync()) {
      return Image.file(
        File(novel.coverUrl!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackCover(theme),
      );
    }
    return _buildFallbackCover(theme);
  }

  Widget _buildFallbackCover(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 40,
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Novel'),
        content: Text('Remove "${novel.title}" from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final db = ref.read(databaseProvider);
              await (db.delete(db.novels)..where((t) => t.id.equals(novel.id as int))).go();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
