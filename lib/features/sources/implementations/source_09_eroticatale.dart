import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class EroticaTaleSource implements BaseStorySource {
  @override
  String get id => 'eroticatale';

  @override
  String get name => 'EroticaTale';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://eroticatale.com';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // REST API acceleration with HTML fallback
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
      SourceCategory(name: 'Cheating Stories', slug: 'cheating-sex-stories'),
      SourceCategory(name: 'Maid & Household', slug: 'maid-servant-sex-stories'),
      SourceCategory(name: 'Romance & Affairs', slug: 'anal-sex-stories'),
      SourceCategory(name: 'Fetish & Special', slug: 'fetish-sex-stories'),
      SourceCategory(name: 'Taboo Stories', slug: 'taboo-sex-stories'),
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
      SourceTag(name: 'Wife', slug: 'wife'),
      SourceTag(name: 'Cheating', slug: 'cheating'),
      SourceTag(name: 'Affair', slug: 'affair'),
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

    final title = doc.querySelector('h1.entry-title')?.text.trim() ?? 'Erotica Tale';
    final author = doc.querySelector('.author a, .byline a')?.text.trim();
    final cover = doc.querySelector('.featured-image img, .post-thumbnail img')?.attributes['src'];

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
      coverUrl: cover,
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

    contentEl.querySelectorAll('.sharedaddy, script, style, noscript, .post-navigation')
        .forEach((el) => el.remove());

    final paragraphs = contentEl.querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.post');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector('h2.entry-title a');
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final author = article.querySelector('.author a, .byline a')?.text.trim();
      final date = article.querySelector('time.entry-date, .posted-on')?.text.trim();
      final summary = article.querySelector('.entry-summary p, .entry-content p')?.text.trim();

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            author: author,
            date: date,
            summary: summary,
            sourceId: id,
          ),
        );
      }
    }

    return result;
  }
}
