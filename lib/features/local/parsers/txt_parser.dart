import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';

class ParsedTxtChapter {
  final double index;
  final String title;
  final String content;

  ParsedTxtChapter({
    required this.index,
    required this.title,
    required this.content,
  });
}

class ParsedTxtNovel {
  final String title;
  final List<ParsedTxtChapter> chapters;

  ParsedTxtNovel({
    required this.title,
    required this.chapters,
  });
}

class TxtParser {
  // Regex patterns to detect chapters across Western, Chinese, Japanese, and numbered styles
  static final List<RegExp> chapterRegexes = [
    // Chinese / Japanese style: 第1章, 第一千二百章, 第1回, 第一节, 第一卷
    RegExp(
      r'^[ \t]*(?:第\s*[0-9零一二三四五六七八九十百千万两]+\s*[章回节卷篇部])([^\n\r]*)',
      multiLine: true,
    ),
    // Western style: Chapter 1: Introduction, CHAPTER I, Section 2
    RegExp(
      r'^[ \t]*(?:CHAPTER|Chapter|SECTION|Section|BOOK|Book|PART|Part)\s+([0-9IVXLCDM]+)[\s:.-]*([^\n\r]*)',
      multiLine: true,
      caseSensitive: false,
    ),
    // Numbered title: 1. Introduction, 01 - The Beginning
    RegExp(
      r'^[ \t]*([0-9]{1,4})[\s:.-]+([^\n\r]{2,50})',
      multiLine: true,
    ),
  ];

  /// Reads a text file, attempting UTF-8 first, then falling back to popular legacy encodings (GBK, Shift-JIS, Windows-1252)
  static Future<String> readTextFileWithAutoEncoding(File file) async {
    final Uint8List bytes = await file.readAsBytes();

    // 1. Try UTF-8 first
    try {
      return utf8.decode(bytes);
    } catch (_) {}

    // 2. Try GBK / GB2312 (common for Chinese web novels)
    try {
      final decoded = await CharsetConverter.decode('gbk', bytes);
      if (decoded.isNotEmpty) return decoded;
    } catch (_) {}

    // 3. Try Shift-JIS (common for Japanese web novels)
    try {
      final decoded = await CharsetConverter.decode('shift_jis', bytes);
      if (decoded.isNotEmpty) return decoded;
    } catch (_) {}

    // 4. Try Latin1 / Windows-1252 fallback
    try {
      return latin1.decode(bytes);
    } catch (_) {}

    // Ultimate fallback: lossy UTF-8
    return utf8.decode(bytes, allowMalformed: true);
  }

  /// Parses a text file into a structured novel with chapters
  static Future<ParsedTxtNovel> parseFile(File file) async {
    final rawText = await readTextFileWithAutoEncoding(file);
    final fileName = file.uri.pathSegments.last;
    final novelTitle = fileName.replaceAll(RegExp(r'\.txt$', caseSensitive: false), '');

    final chapters = splitIntoChapters(rawText, novelTitle);
    return ParsedTxtNovel(title: novelTitle, chapters: chapters);
  }

  /// Splits raw text into chapters using regex detection
  static List<ParsedTxtChapter> splitIntoChapters(String text, String defaultTitle) {
    // Find matching regex
    RegExp? matchedRegex;
    List<RegExpMatch> bestMatches = [];

    for (final regex in chapterRegexes) {
      final matches = regex.allMatches(text).toList();
      if (matches.length > bestMatches.length && matches.length >= 2) {
        bestMatches = matches;
        matchedRegex = regex;
      }
    }

    // If no chapter headers were reliably found, treat the whole document as 1 chapter
    // or chunk every ~50,000 characters if very large
    if (matchedRegex == null || bestMatches.isEmpty) {
      return [
        ParsedTxtChapter(
          index: 1.0,
          title: defaultTitle,
          content: text.trim(),
        ),
      ];
    }

    final List<ParsedTxtChapter> result = [];
    double chapterIndex = 1.0;

    // Check if there is preface/prologue text before the first chapter header
    if (bestMatches.first.start > 0) {
      final prologue = text.substring(0, bestMatches.first.start).trim();
      if (prologue.isNotEmpty) {
        result.add(
          ParsedTxtChapter(
            index: 0.0,
            title: 'Prologue / Preface',
            content: prologue,
          ),
        );
      }
    }

    for (int i = 0; i < bestMatches.length; i++) {
      final currentMatch = bestMatches[i];
      final chapterTitle = currentMatch.group(0)?.trim() ?? 'Chapter $chapterIndex';

      final contentStart = currentMatch.end;
      final contentEnd = (i + 1 < bestMatches.length)
          ? bestMatches[i + 1].start
          : text.length;

      final chapterContent = text.substring(contentStart, contentEnd).trim();

      result.add(
        ParsedTxtChapter(
          index: chapterIndex,
          title: chapterTitle,
          content: chapterContent,
        ),
      );
      chapterIndex += 1.0;
    }

    return result;
  }
}
