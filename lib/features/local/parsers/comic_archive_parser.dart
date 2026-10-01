import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ParsedComicPage {
  final int pageIndex;
  final String filePath;

  ParsedComicPage({
    required this.pageIndex,
    required this.filePath,
  });
}

class ParsedComicNovel {
  final String title;
  final String? coverPath;
  final List<ParsedComicPage> pages;

  ParsedComicNovel({
    required this.title,
    this.coverPath,
    required this.pages,
  });
}

class ComicArchiveParser {
  static final validImageExtensions = {'.jpg', '.jpeg', '.png', '.webp', '.bmp', '.gif'};

  /// Extracts comic archive (CBZ/ZIP) into local storage directory
  static Future<ParsedComicNovel> parseFile(File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final novelTitle = p.basenameWithoutExtension(file.path);

    final appDir = await getApplicationDocumentsDirectory();
    final comicDir = Directory(p.join(appDir.path, 'comics', '${DateTime.now().millisecondsSinceEpoch}'));
    if (!await comicDir.exists()) {
      await comicDir.create(recursive: true);
    }

    final List<ParsedComicPage> pages = [];
    String? coverPath;

    // Filter image entries and sort by filename
    final imageFiles = archive.files.where((entry) {
      if (!entry.isFile) return false;
      final ext = p.extension(entry.name).toLowerCase();
      return validImageExtensions.contains(ext);
    }).toList();

    // Sort naturally (01.jpg, 02.jpg, 10.jpg)
    imageFiles.sort((a, b) => a.name.compareTo(b.name));

    int index = 1;
    for (final entry in imageFiles) {
      final ext = p.extension(entry.name);
      final destFile = File(p.join(comicDir.path, 'page_${index.toString().padLeft(4, '0')}$ext'));
      await destFile.writeAsBytes(entry.content as List<int>);

      coverPath ??= destFile.path;

      pages.add(ParsedComicPage(pageIndex: index, filePath: destFile.path));
      index++;
    }

    return ParsedComicNovel(
      title: novelTitle,
      coverPath: coverPath,
      pages: pages,
    );
  }
}
