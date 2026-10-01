import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class ChotiGolpoBDSource implements BaseStorySource {
  @override
  String get id => 'chotigolpobd';

  @override
  String get name => 'Choti Golpo BD';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://www.chotigolpobd.com';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Attempt REST API first for speed, fallback to HTML scraping
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=100&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map<SourceListingItem>((post) {
          String? cover;
          try {
            cover = post['_embedded']?['wp:featuredmedia']?[0]?['source_url'];
          } catch (_) {}

          return SourceListingItem(
            title: html_parser.parse(post['title']['rendered']).body?.text.trim() ?? '',
            url: post['link'] ?? '',
            coverUrl: cover,
            summary: html_parser.parse(post['excerpt']?['rendered'] ?? '').body?.text.trim(),
            sourceId: id,
          );
        }).toList();
      }
    } catch (_) {}

    // HTML fallback
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'বাংলা চটি গল্প', slug: 'bangla-choti-golpo'),
      SourceCategory(name: 'বউদি চটি', slug: 'boudi-choti'),
      SourceCategory(name: 'আন্টি চটি', slug: 'aunty-choti'),
      SourceCategory(name: 'ভাবি চটি', slug: 'bhabi-choti'),
      SourceCategory(name: 'নতুন চটি', slug: 'new-choti'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    final url = page == 1
        ? '$baseUrl/category/$categorySlug/'
        : '$baseUrl/category/$categorySlug/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Choti BD', slug: 'choti-bd'),
      SourceTag(name: 'Bangla Golpo', slug: 'bangla-golpo'),
      SourceTag(name: 'Real Story', slug: 'real-story'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    final url = page == 1
        ? '$baseUrl/tag/$tagSlug/'
        : '$baseUrl/tag/$tagSlug/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?search=${Uri.encodeComponent(query)}&page=$page&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map<SourceListingItem>((post) {
          String? cover;
          try {
            cover = post['_embedded']?['wp:featuredmedia']?[0]?['source_url'];
          } catch (_) {}

          return SourceListingItem(
            title: html_parser.parse(post['title']['rendered']).body?.text.trim() ?? '',
            url: post['link'] ?? '',
            coverUrl: cover,
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

    final title = doc.querySelector('h1.entry-title')?.text.trim() ?? 'Bangla Story';
    final cover = doc.querySelector('.post-thumb img')?.attributes['data-src'] ??
        doc.querySelector('.post-thumb img')?.attributes['src'];

    return SourceNovelDetails(
      title: title,
      url: url,
      coverUrl: cover,
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
    final contentEl = doc.querySelector('div.entry-content');
    if (contentEl == null) return '';

    // Strip ads, latest posts widget, scripts
    contentEl.querySelectorAll('.code-block, ul.wp-block-latest-posts, script, style, #wpcp-error-message')
        .forEach((el) => el.remove());

    final paragraphs = contentEl.querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.ast-article-post, article[id^="post-"]');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector('h2.entry-title a');
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final cover = article.querySelector('.post-thumb img')?.attributes['data-src'] ??
          article.querySelector('.post-thumb img')?.attributes['src'];

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            coverUrl: cover,
            sourceId: id,
          ),
        );
      }
    }

    return result;
  }
}
