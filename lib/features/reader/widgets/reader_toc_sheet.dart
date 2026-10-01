import 'package:flutter/material.dart';
import '../../../core/database/database.dart';

class ReaderTocSheet extends StatefulWidget {
  final List<Chapter> chapters;
  final int currentChapterIdx;
  final ValueChanged<int> onChapterSelected;

  const ReaderTocSheet({
    super.key,
    required this.chapters,
    required this.currentChapterIdx,
    required this.onChapterSelected,
  });

  @override
  State<ReaderTocSheet> createState() => _ReaderTocSheetState();
}

class _ReaderTocSheetState extends State<ReaderTocSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredChapters = widget.chapters.asMap().entries.where((entry) {
      if (_searchQuery.isEmpty) return true;
      return entry.value.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Table of Contents (${widget.chapters.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${((widget.currentChapterIdx + 1) / (widget.chapters.isEmpty ? 1 : widget.chapters.length) * 100).toInt()}% Read',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search chapters...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChapters.length,
              itemBuilder: (context, idx) {
                final entry = filteredChapters[idx];
                final originalIdx = entry.key;
                final chapter = entry.value;
                final isCurrent = originalIdx == widget.currentChapterIdx;

                return ListTile(
                  dense: true,
                  selected: isCurrent,
                  selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                  leading: Text(
                    '${chapter.chapterIndex.toInt().toString().padLeft(2, '0')}.',
                    style: TextStyle(
                      color: isCurrent ? theme.colorScheme.primary : theme.colorScheme.outline,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  title: Text(
                    chapter.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? theme.colorScheme.primary : null,
                    ),
                  ),
                  trailing: chapter.isRead
                      ? Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    widget.onChapterSelected(originalIdx);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
