import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/source_registry.dart';

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sources = ref.watch(allSourcesProvider);
    final activeLang = ref.watch(selectedSourceLanguageFilterProvider);

    final filteredSources = activeLang == null
        ? sources
        : sources.where((s) => s.lang.toLowerCase() == activeLang.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.travel_explore),
            tooltip: 'Global Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_link),
            tooltip: 'Add Repository',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // Filter chip bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Languages'),
                  selected: activeLang == null,
                  onSelected: (_) {
                    ref.read(selectedSourceLanguageFilterProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Bengali (BN)'),
                  selected: activeLang == 'bn',
                  onSelected: (_) {
                    ref.read(selectedSourceLanguageFilterProvider.notifier).state = 'bn';
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('English (EN)'),
                  selected: activeLang == 'en',
                  onSelected: (_) {
                    ref.read(selectedSourceLanguageFilterProvider.notifier).state = 'en';
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Hindi (HI)'),
                  selected: activeLang == 'hi',
                  onSelected: (_) {
                    ref.read(selectedSourceLanguageFilterProvider.notifier).state = 'hi';
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Repository Status Banner
          Card.outlined(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: const Icon(Icons.extension),
              ),
              title: const Text('Online Novel Sources'),
              subtitle: Text('${sources.length} active scrapers connected'),
              trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Installed Sources (${filteredSources.length})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ...filteredSources.map((source) {
            final isAudio = source.id.contains('audio');

            return Card(
              margin: const EdgeInsets.only(bottom: 10.0),
              elevation: 1,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isAudio
                      ? Colors.orange.withValues(alpha: 0.2)
                      : theme.colorScheme.primaryContainer,
                  child: Icon(
                    isAudio ? Icons.audiotrack : Icons.menu_book,
                    color: isAudio ? Colors.orange : theme.colorScheme.primary,
                  ),
                ),
                title: Text(
                  source.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  source.baseUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        source.lang.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
                onTap: () {
                  context.push('/sources/${source.id}');
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
