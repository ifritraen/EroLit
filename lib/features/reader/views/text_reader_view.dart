import 'package:flutter/material.dart';
import '../models/reader_settings.dart';

class TextReaderView extends StatefulWidget {
  final String chapterTitle;
  final List<String> paragraphs;
  final ReaderSettings settings;
  final VoidCallback onToggleControls;
  final VoidCallback onNextChapter;
  final VoidCallback onPreviousChapter;
  final ValueChanged<double> onProgressChanged;

  const TextReaderView({
    super.key,
    required this.chapterTitle,
    required this.paragraphs,
    required this.settings,
    required this.onToggleControls,
    required this.onNextChapter,
    required this.onPreviousChapter,
    required this.onProgressChanged,
  });

  @override
  State<TextReaderView> createState() => _TextReaderViewState();
}

class _TextReaderViewState extends State<TextReaderView> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll > 0) {
      final progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      widget.onProgressChanged(progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themePreset = widget.settings.themePreset;
    final textStyle = TextStyle(
      fontSize: widget.settings.fontSize,
      height: widget.settings.lineHeight,
      fontFamily: widget.settings.fontFamily,
      color: themePreset.textColor,
      letterSpacing: 0.2,
    );

    return Container(
      color: themePreset.backgroundColor,
      child: Stack(
        children: [
          // Reader Content
          widget.settings.readingMode == ReadingMode.continuousScroll
              ? _buildScrollView(textStyle)
              : _buildPagedView(textStyle),

          // 3x3 Tap Zones Overlay for Paged / Gesture Mode
          Positioned.fill(
            child: Row(
              children: [
                // Left 25% tap: previous page or scroll up
                Expanded(
                  flex: 25,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (widget.settings.readingMode == ReadingMode.paged) {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        } else {
                          widget.onPreviousChapter();
                        }
                      } else {
                        // Scroll up by 400px
                        _scrollController.animateTo(
                          (_scrollController.offset - 400).clamp(0, _scrollController.position.maxScrollExtent),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  ),
                ),

                // Center 50% tap: toggle menu/controls
                Expanded(
                  flex: 50,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.onToggleControls,
                  ),
                ),

                // Right 25% tap: next page or scroll down
                Expanded(
                  flex: 25,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (widget.settings.readingMode == ReadingMode.paged) {
                        final totalPages = widget.paragraphs.length;
                        if (_currentPage + 1 < totalPages) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        } else {
                          widget.onNextChapter();
                        }
                      } else {
                        // Scroll down by 400px
                        _scrollController.animateTo(
                          (_scrollController.offset + 400).clamp(0, _scrollController.position.maxScrollExtent),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollView(TextStyle textStyle) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: widget.settings.horizontalMargin,
        vertical: 40.0,
      ),
      itemCount: widget.paragraphs.length + 2, // Header + paragraphs + Chapter End
      itemBuilder: (context, index) {
        if (index == 0) {
          // Chapter Header
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
            child: Text(
              widget.chapterTitle,
              style: textStyle.copyWith(
                fontSize: widget.settings.fontSize * 1.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        if (index == widget.paragraphs.length + 1) {
          // Chapter Footer / Next Chapter trigger
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48.0),
            child: Column(
              children: [
                Divider(color: widget.settings.themePreset.textColor.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: widget.onNextChapter,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Chapter'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }

        final paragraph = widget.paragraphs[index - 1];
        return Padding(
          padding: EdgeInsets.only(bottom: widget.settings.paragraphSpacing),
          child: Text(
            paragraph,
            style: textStyle,
          ),
        );
      },
    );
  }

  Widget _buildPagedView(TextStyle textStyle) {
    // In paged mode, each page shows a paragraph or combined text block
    final pages = widget.paragraphs;

    return PageView.builder(
      controller: _pageController,
      itemCount: pages.length,
      onPageChanged: (idx) {
        setState(() {
          _currentPage = idx;
        });
        widget.onProgressChanged((idx + 1) / pages.length);
      },
      itemBuilder: (context, idx) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.settings.horizontalMargin,
            vertical: 48.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (idx == 0) ...[
                Text(
                  widget.chapterTitle,
                  style: textStyle.copyWith(
                    fontSize: widget.settings.fontSize * 1.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    pages[idx],
                    style: textStyle,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${idx + 1} / ${pages.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.settings.themePreset.textColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
