import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class MyChotiSource implements BaseStorySource {
  @override
  String get id => 'mychoti';

  @override
  String get name => 'My Choti';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://mychoti.com';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
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

    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'নতুন চটি গল্প', slug: 'notun-choti-golpo'),
      SourceCategory(name: 'প্রিয়তমা মামী', slug: 'priyotoma-mami'),
      SourceCategory(name: 'ভাই বোন চটি গল্প', slug: 'bhai-bon-choti-golpo'),
      SourceCategory(name: 'শাশুড়ি রঙ্গিন মিলন', slug: 'shashuri-rongin-milon'),
      SourceCategory(name: 'রঙ্গিলা চাচি', slug: 'rongila-chachi'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    try {
      final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final url = page == 1
          ? '$baseUrl/$cleanSlug/'
          : '$baseUrl/$cleanSlug/page/$page/';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(categorySlug.replaceAll('-', ' '), page: page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'নতুন চটি গল্প', slug: 'notun-choti-golpo'),
      SourceTag(name: 'প্রিয়তমা মামী', slug: 'priyotoma-mami'),
      SourceTag(name: 'ভাই বোন চটি গল্প', slug: 'bhai-bon-choti-golpo'),
      SourceTag(name: 'চটি গল্প', slug: 'choti'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    try {
      final cleanSlug = tagSlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final url = page == 1
          ? '$baseUrl/$cleanSlug/'
          : '$baseUrl/$cleanSlug/page/$page/';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(tagSlug.replaceAll('-', ' '), page: page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?search=${Uri.encodeComponent(query)}&page=$page&_embed';
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

    final title = doc.querySelector('h1.page-title, h1.entry-title')?.text.trim() ?? 'Bangla Story';
    final author = doc.querySelector('.meta-author a')?.text.trim() ?? 'mychoti';

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
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

    // div.entry-content is naturally clean on mychoti, but strip any remaining scripts
    contentEl.querySelectorAll('script, style, noscript').forEach((el) => el.remove());

    final paragraphs = contentEl.querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.entry-card, .entries article');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector('h2.entry-title a');
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final summary = article.querySelector('.entry-excerpt p')?.text.trim();

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            summary: summary,
            sourceId: id,
          ),
        );
      }
    }

    return result;
  }
}
