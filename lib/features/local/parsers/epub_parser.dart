import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ParsedEpubChapter {
  final double index;
  final String title;
  final String content;

  ParsedEpubChapter({
    required this.index,
    required this.title,
    required this.content,
  });
}

class ParsedEpubNovel {
  final String title;
  final String? author;
  final String? coverPath;
  final List<ParsedEpubChapter> chapters;

  ParsedEpubNovel({
    required this.title,
    this.author,
    this.coverPath,
    required this.chapters,
  });
}

class EpubNovelParser {
  /// Parses an EPUB file into structured chapters and extracts cover art
  static Future<ParsedEpubNovel> parseFile(File file) async {
    final bytes = await file.readAsBytes();
    final EpubBook book = await EpubReader.readBook(bytes);

    final novelTitle = book.Title?.trim().isNotEmpty == true
        ? book.Title!.trim()
        : p.basenameWithoutExtension(file.path);
    final novelAuthor = book.Author?.trim();

    // Extract cover image if present
    String? savedCoverPath;
    if (book.CoverImage != null) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final coversDir = Directory(p.join(appDir.path, 'covers'));
        if (!await coversDir.exists()) {
          await coversDir.create(recursive: true);
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_cover.jpg';
        final coverFile = File(p.join(coversDir.path, fileName));
        final encodedJpg = img.encodeJpg(book.CoverImage!);
        await coverFile.writeAsBytes(encodedJpg);
        savedCoverPath = coverFile.path;
      } catch (_) {}
    }

    // Extract chapters recursively
    final List<ParsedEpubChapter> chapters = [];
    double chapterIndex = 1.0;

    void processChapters(List<EpubChapter> epubChapters) {
      for (final ch in epubChapters) {
        final title = ch.Title?.trim().isNotEmpty == true
            ? ch.Title!.trim()
            : 'Chapter $chapterIndex';

        final cleanContent = _cleanHtmlContent(ch.HtmlContent ?? '');
        if (cleanContent.trim().isNotEmpty) {
          chapters.add(
            ParsedEpubChapter(
              index: chapterIndex,
              title: title,
              content: cleanContent,
            ),
          );
          chapterIndex += 1.0;
        }

        if (ch.SubChapters != null && ch.SubChapters!.isNotEmpty) {
          processChapters(ch.SubChapters!);
        }
      }
    }

    if (book.Chapters != null) {
      processChapters(book.Chapters!);
    }

    return ParsedEpubNovel(
      title: novelTitle,
      author: novelAuthor,
      coverPath: savedCoverPath,
      chapters: chapters,
    );
  }

  /// Cleans HTML content: converts breaks/paragraphs to clean line breaks and strips tags
  static String _cleanHtmlContent(String html) {
    if (html.isEmpty) return '';

    // Replace paragraph and break tags with newlines
    var text = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'</div>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</h1>|</h2>|</h3>|</h4>|</h5>|</h6>', caseSensitive: false), '\n\n');

    // Remove remaining HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // Unescape common HTML entities
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '…');

    // Normalize multiple excessive blank lines to max 2
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return text.trim();
  }
}
