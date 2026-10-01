import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/database/database.dart';

class ComicReaderView extends StatefulWidget {
  final List<Chapter> pages;
  final VoidCallback onToggleControls;
  final ValueChanged<double> onProgressChanged;

  const ComicReaderView({
    super.key,
    required this.pages,
    required this.onToggleControls,
    required this.onProgressChanged,
  });

  @override
  State<ComicReaderView> createState() => _ComicReaderViewState();
}

class _ComicReaderViewState extends State<ComicReaderView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pages.isEmpty) {
      return const Center(child: Text('No comic pages found'));
    }

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.pages.length,
            onPageChanged: (idx) {
              setState(() {
                _currentPage = idx;
              });
              widget.onProgressChanged((idx + 1) / widget.pages.length);
            },
            itemBuilder: (context, idx) {
              final page = widget.pages[idx];
              if (page.localFilePath == null) {
                return const Center(child: Icon(Icons.broken_image, color: Colors.white54));
              }

              final file = File(page.localFilePath!);
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.5,
                child: Center(
                  child: Image.file(
                    file,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, color: Colors.white54)),
                  ),
                ),
              );
            },
          ),

          // Tap Zones Overlay
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  flex: 25,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.onToggleControls,
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_currentPage + 1 < widget.pages.length) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
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
}
