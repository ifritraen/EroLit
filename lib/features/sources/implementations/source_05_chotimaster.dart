import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class ChotiMasterSource implements BaseStorySource {
  @override
  String get id => 'chotimaster';

  @override
  String get name => 'Choti Master';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://chotimaster.com';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/?page=$page';
    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'নিষিদ্ধ অনুভূতি', slug: 'Forbidden_feelings'),
      SourceCategory(name: 'গোপন রাত', slug: 'Secret_night'),
      SourceCategory(name: 'প্রেমের চিঠি', slug: 'Love_letter'),
      SourceCategory(name: 'হৃদয়ের তৃষ্ণা', slug: 'Thirst_of_the_heart'),
      SourceCategory(name: 'গোপন প্রেম', slug: 'Secret_love'),
      SourceCategory(name: 'চটি গল্প', slug: 'choti_golpo'),
      SourceCategory(name: 'পন গল্প', slug: 'pano_golpo'),
      SourceCategory(name: 'রোমান্টিক গল্প', slug: 'Romantic_story'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    try {
      final url = page == 1
          ? '$baseUrl/category/$categorySlug'
          : '$baseUrl/category/$categorySlug?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(categorySlug.replaceAll('_', ' '), page: page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'নিষিদ্ধ অনুভূতি', slug: 'Forbidden_feelings'),
      SourceTag(name: 'গোপন রাত', slug: 'Secret_night'),
      SourceTag(name: 'প্রেমের চিঠি', slug: 'Love_letter'),
      SourceTag(name: 'চটি গল্প', slug: 'choti'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    final searchItems = await search(tagSlug.replaceAll('_', ' '), page: page);
    if (searchItems.isNotEmpty) return searchItems;
    return [];
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final url = page == 1
        ? '$baseUrl/search/?s=${Uri.encodeComponent(query)}'
        : '$baseUrl/search/?s=${Uri.encodeComponent(query)}&page=$page';
    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    var title = doc.querySelector('h1, h2.title, .article-title')?.text.trim() ?? '';
    if (title.isEmpty) {
      // Fallback: decode title from URL slug
      title = _decodeTitleFromUrl(url);
    }

    return SourceNovelDetails(
      title: title,
      url: url,
      status: 'Completed',
      chapters: [
        SourceChapter(
          index: 1.0,
          title: 'সম্পূর্ণ গল্প (Full Story)',
          url: url,
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final res = await ScraperClient.dio.get(chapterUrl);
    final doc = html_parser.parse(res.data.toString());
    final contentEl = doc.querySelector('div.printable-area, .story-content');
    if (contentEl == null) return '';

    // Strip ads, like buttons, and social share
    contentEl.querySelectorAll('.main-ad, .ad, .share_icon, .like-btn, script, style')
        .forEach((el) => el.remove());

    final paragraphs = contentEl.querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseListings(String html) {
    final doc = html_parser.parse(html);
    final cards = doc.querySelectorAll('.news-card, .author-page-news .col-sm-6, .card');
    final List<SourceListingItem> result = [];
    final seenUrls = <String>{};

    for (final card in cards) {
      final linkEl = card.querySelector('a[href*="/article/"]');
      if (linkEl == null) continue;

      var url = linkEl.attributes['href'] ?? '';
      if (url.startsWith('/')) url = '$baseUrl$url';

      var title = card.querySelector('h3.news-title, h4.title, .title')?.text.trim() ?? '';
      if (title.contains('..') || title.isEmpty) {
        title = linkEl.text.trim();
        if (title.isEmpty) title = _decodeTitleFromUrl(url);
      }

      if (title.isNotEmpty && url.isNotEmpty && !seenUrls.contains(url)) {
        seenUrls.add(url);
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            sourceId: id,
          ),
        );
      }
    }

    // Direct anchor fallback if card wrappers are different on category/search views
    if (result.isEmpty) {
      final allArticleLinks = doc.querySelectorAll('a[href*="/article/"]');
      for (final a in allArticleLinks) {
        var url = a.attributes['href'] ?? '';
        if (url.isEmpty) continue;
        if (url.startsWith('/')) url = '$baseUrl$url';
        var title = a.text.trim();
        if (title.isEmpty) title = _decodeTitleFromUrl(url);
        if (title.length > 2 && !seenUrls.contains(url)) {
          seenUrls.add(url);
          result.add(
            SourceListingItem(
              title: title,
              url: url,
              sourceId: id,
            ),
          );
        }
      }
    }

    return result;
  }

  String _decodeTitleFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.length >= 3) {
        final slug = uri.pathSegments[2];
        return Uri.decodeComponent(slug).replaceAll('-', ' ').trim();
      }
    } catch (_) {}
    return 'Bangla Story';
  }
}
