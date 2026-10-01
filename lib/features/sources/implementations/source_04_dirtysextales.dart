import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class DirtySexTalesSource implements BaseStorySource {
  @override
  String get id => 'dirtysextales';

  @override
  String get name => 'Dirty Sex Tales';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://dirtysextales.com';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // REST API path with HTML fallback
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=100';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map<SourceListingItem>((post) {
          return SourceListingItem(
            title: html_parser.parse(post['title']['rendered']).body?.text.trim() ?? '',
            url: post['link'] ?? '',
            summary: html_parser.parse(post['excerpt']?['rendered'] ?? '').body?.text.trim(),
            sourceId: id,
          );
        }).toList();
      }
    } catch (_) {}

    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'English Stories', slug: 'english-sex-stories'),
      SourceCategory(name: 'Erotic Novels', slug: 'english-sex-stories/erotic-novels'),
      SourceCategory(name: 'Hindi Stories', slug: 'hindi-sex-stories'),
      SourceCategory(name: 'Bengali Stories', slug: 'bengali-sex-stories'),
      SourceCategory(name: 'Romance & Affairs', slug: 'cheating-stories'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    try {
      final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final url = page == 1
          ? '$baseUrl/category/$cleanSlug/'
          : '$baseUrl/category/$cleanSlug/page/$page/';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(categorySlug.replaceAll('-', ' '), page: page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Affair', slug: 'affair'),
      SourceTag(name: 'First Time', slug: 'first-time'),
      SourceTag(name: 'Wife', slug: 'wife'),
      SourceTag(name: 'Romance', slug: 'romance'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    try {
      final cleanSlug = tagSlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final url = page == 1
          ? '$baseUrl/tag/$cleanSlug/'
          : '$baseUrl/tag/$cleanSlug/page/$page/';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(tagSlug.replaceAll('-', ' '), page: page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?search=${Uri.encodeComponent(query)}&page=$page';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map<SourceListingItem>((post) {
          return SourceListingItem(
            title: html_parser.parse(post['title']['rendered']).body?.text.trim() ?? '',
            url: post['link'] ?? '',
            sourceId: id,
          );
        }).toList();
      }
    } catch (_) {}

    final url = page == 1
        ? '$baseUrl/?s=${Uri.encodeComponent(query)}'
        : '$baseUrl/page/$page/?s=${Uri.encodeComponent(query)}';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final title = doc.querySelector('h1.entry-title')?.text.trim() ?? 'Story';
    final author = doc.querySelector('.entry-meta .entry-author a')?.text.trim();

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
      status: 'Completed',
      chapters: [
        SourceChapter(
          index: 1.0,
          title: 'Full Story',
          url: url,
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final res = await ScraperClient.dio.get(chapterUrl);
    final doc = html_parser.parse(res.data.toString());
    final contentEl = doc.querySelector('div.entry-content');
    if (contentEl == null) return '';

    // Remove banner ads, social sharing, and related post blocks
    contentEl.querySelectorAll(
      '[class*="idblog-banner"], .idblog-social-share, .idblog-related-post, nav.post-navigation, script, style',
    ).forEach((el) => el.remove());

    final paragraphs = contentEl.querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.gmr-smallthumb, article.post');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector('h2.entry-title a');
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final author = article.querySelector('.entry-author a')?.text.trim();
      final date = article.querySelector('time.entry-date')?.text.trim();

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            author: author,
            date: date,
            sourceId: id,
          ),
        );
      }
    }

    return result;
  }
}
