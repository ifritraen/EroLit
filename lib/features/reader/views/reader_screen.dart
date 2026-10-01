import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/reader_controller.dart';
import '../models/reader_settings.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/reader_toc_sheet.dart';
import 'comic_reader_view.dart';
import 'pdf_reader_view.dart';
import 'text_reader_view.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int novelId;
  final int? chapterId;

  const ReaderScreen({
    super.key,
    required this.novelId,
    this.chapterId,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  @override
  void initState() {
    super.initState();
    // Enter immersive sticky mode for novel reading
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore system UI on exit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _showSettings(BuildContext context, ReaderController controller, ReaderState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReaderSettingsSheet(
        settings: state.settings,
        onSettingsChanged: (newSettings) {
          controller.updateSettings(newSettings);
        },
      ),
    );
  }

  void _showToc(BuildContext context, ReaderController controller, ReaderState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReaderTocSheet(
        chapters: state.chapters,
        currentChapterIdx: state.currentChapterIdx,
        onChapterSelected: (idx) {
          controller.jumpToChapter(idx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final readerParams = (novelId: widget.novelId, chapterId: widget.chapterId);
    final state = ref.watch(readerControllerProvider(readerParams));
    final controller = ref.read(readerControllerProvider(readerParams).notifier);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.novel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Novel not found in library.'),
        ),
      );
    }

    final format = state.novel?.localFormat?.toLowerCase();

    return Scaffold(
      backgroundColor: state.settings.themePreset.backgroundColor,
      body: Stack(
        children: [
          // Active Format Reader View
          Positioned.fill(
            child: _buildReaderContent(format, state, controller),
          ),

          // Top Controls Bar Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: state.showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 8,
                left: 8,
                right: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.novel?.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (state.currentChapter != null)
                          Text(
                            state.currentChapter!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls Bar Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: state.showControls ? 0 : -120,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 8,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chapter Previous / Progress Slider / Next
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white),
                        tooltip: 'Previous Chapter',
                        onPressed: state.currentChapterIdx > 0
                            ? () => controller.previousChapter()
                            : null,
                      ),
                      Expanded(
                        child: Text(
                          '${state.currentChapterIdx + 1} / ${state.chapters.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white),
                        tooltip: 'Next Chapter',
                        onPressed: state.currentChapterIdx + 1 < state.chapters.length
                            ? () => controller.nextChapter()
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Bottom Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showToc(context, controller, state),
                        icon: const Icon(Icons.list, color: Colors.white),
                        label: const Text('Chapters', style: TextStyle(color: Colors.white)),
                      ),
                      TextButton.icon(
                        onPressed: () => _showSettings(context, controller, state),
                        icon: const Icon(Icons.tune, color: Colors.white),
                        label: const Text('Display', style: TextStyle(color: Colors.white)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Quick toggle between scroll and paged
                          final nextMode = state.settings.readingMode == ReadingMode.paged
                              ? ReadingMode.continuousScroll
                              : ReadingMode.paged;
                          controller.updateSettings(
                            state.settings.copyWith(readingMode: nextMode),
                          );
                        },
                        icon: Icon(
                          state.settings.readingMode == ReadingMode.paged
                              ? Icons.swap_vert
                              : Icons.menu_book,
                          color: Colors.white,
                        ),
                        label: Text(
                          state.settings.readingMode == ReadingMode.paged ? 'Scroll' : 'Paged',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReaderContent(String? format, ReaderState state, ReaderController controller) {
    if (format == 'pdf' && state.currentChapter?.localFilePath != null) {
      return PdfReaderView(
        filePath: state.currentChapter!.localFilePath!,
        onToggleControls: controller.toggleControls,
      );
    }

    if (format == 'cbz') {
      return ComicReaderView(
        pages: state.chapters,
        onToggleControls: controller.toggleControls,
        onProgressChanged: controller.updateReadingProgress,
      );
    }

    // Default text reader for EPUB, TXT, and online novel content
    return TextReaderView(
      chapterTitle: state.currentChapter?.title ?? '',
      paragraphs: state.paragraphs,
      settings: state.settings,
      onToggleControls: controller.toggleControls,
      onNextChapter: controller.nextChapter,
      onPreviousChapter: controller.previousChapter,
      onProgressChanged: controller.updateReadingProgress,
    );
  }
}
