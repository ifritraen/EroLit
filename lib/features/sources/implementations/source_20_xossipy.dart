import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class XossipySource implements BaseStorySource {
  @override
  String get id => 'xossipy';

  @override
  String get name => 'Xossipy Forum';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://xossipy.com';

  @override
  String? get iconUrl => 'https://xossipy.com/apple-touch-icon.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1
        ? '$baseUrl/forum-21.html'
        : '$baseUrl/forum-21-page-$page.html';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseThreadListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Bengali Sex Stories', slug: 'forum-21'),
      SourceCategory(name: 'Hindi Sex Stories', slug: 'forum-18'),
      SourceCategory(name: 'English Sex Stories', slug: 'forum-17'),
      SourceCategory(name: 'Tamil Sex Stories', slug: 'forum-19'),
      SourceCategory(name: 'Telugu Sex Stories', slug: 'forum-15'),
      SourceCategory(name: 'Punjabi Sex Stories', slug: 'forum-22'),
      SourceCategory(name: 'Malayalam Sex Stories', slug: 'forum-42'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/$categorySlug.html'
        : '$baseUrl/$categorySlug-page-$page.html';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseThreadListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'বাংলা চটি', slug: 'forum-21'),
      SourceTag(name: 'হিন্দি কাহানি', slug: 'forum-18'),
      SourceTag(name: 'English Stories', slug: 'forum-17'),
      SourceTag(name: 'Tamil Stories', slug: 'forum-19'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    return getCategoryStories(tagSlug, page: page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    return [];
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/$url';
    final res = await ScraperClient.dio.get(cleanUrl);
    final doc = html_parser.parse(res.data.toString());

    final titleEl = doc.querySelector('h1') ??
        doc.querySelector('.navigation li.active') ??
        doc.querySelector('title');
    final title = titleEl?.text.replaceFirst(RegExp(r"^Xossipy\s*-\s*", caseSensitive: false), '').trim() ?? 'Forum Serial';

    final authorEl = doc.querySelector('.post_author .largetext a') ??
        doc.querySelector('.postbit .author a');
    final author = authorEl?.text.trim();

    // Check for multi-page thread chapters
    final chapters = <SourceChapter>[];
    chapters.add(
      SourceChapter(
        index: 1.0,
        title: '$title (Part 1)',
        url: cleanUrl,
      ),
    );

    // Extract pagination links for parts 2, 3, etc.
    final pageLinks = doc.querySelectorAll('.pagination a.pagination_page');
    final seenUrls = <String>{cleanUrl};
    for (final pl in pageLinks) {
      var pUrl = pl.attributes['href'] ?? '';
      if (pUrl.isEmpty) continue;
      if (!pUrl.startsWith('http')) pUrl = '$baseUrl/$pUrl';
      if (!seenUrls.contains(pUrl)) {
        seenUrls.add(pUrl);
        final pageNum = double.tryParse(pl.text.trim()) ?? (chapters.length + 1).toDouble();
        chapters.add(
          SourceChapter(
            index: pageNum,
            title: '$title (Part ${pl.text.trim()})',
            url: pUrl,
          ),
        );
      }
    }

    final firstPost = doc.querySelector('.post_body');
    final description = firstPost?.text.trim().split('\n').first;

    return SourceNovelDetails(
      title: title,
      url: cleanUrl,
      author: author,
      description: description,
      status: chapters.length > 1 ? 'Ongoing' : 'Completed',
      chapters: chapters,
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http') ? chapterUrl : '$baseUrl/$chapterUrl';
    final res = await ScraperClient.dio.get(cleanUrl);
    final doc = html_parser.parse(res.data.toString());

    // Forum postbodies
    final postBodies = doc.querySelectorAll('.post_body');
    if (postBodies.isEmpty) return 'Content could not be loaded.';

    final cleanedParagraphs = <String>[];
    // In a story thread, author's main narrative post
    for (final post in postBodies) {
      for (final el in post.querySelectorAll('blockquote, script, style, .mycode_quote, .signature')) {
        el.remove();
      }
      final text = post.text.trim();
      if (text.length > 50) {
        cleanedParagraphs.add(text);
      }
    }

    return cleanedParagraphs.isNotEmpty
        ? cleanedParagraphs.join('\n\n')
        : postBodies.first.text.trim();
  }

  List<SourceListingItem> _parseThreadListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];

    final rows = doc.querySelectorAll('tr.inline_row, tr');
    for (final row in rows) {
      final threadLinks = row.querySelectorAll('a[href*="thread-"]');
      for (final threadLink in threadLinks) {
        final title = threadLink.text.trim();
        var href = threadLink.attributes['href'] ?? '';
        if (title.isEmpty || href.isEmpty) continue;
        // Skip utility/unread/lastpost icon links and page numbers
        if (href.contains('-newpost') ||
            href.contains('-lastpost') ||
            title.length < 3 ||
            RegExp(r'^\d+$').hasMatch(title)) {
          continue;
        }

        if (!href.startsWith('http')) {
          href = '$baseUrl/$href';
        }

        final authorEl = row.querySelector('.author a, .author');
        final author = authorEl?.text.trim();

        items.add(
          SourceListingItem(
            title: title,
            url: href,
            sourceId: id,
            author: author,
          ),
        );
        break; // Only take the primary title link for this row
      }
    }

    return items;
  }
}
