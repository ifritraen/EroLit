import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class BanglaChotiBoiSource implements BaseStorySource {
  @override
  String get id => 'banglachotiboi';

  @override
  String get name => 'Bangla Choti Boi';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://www.banglachotiboi.in';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'মা ছেলে চোদাচুদি', slug: 'ma-chele-chodachudi'),
      SourceCategory(name: 'অজাচার বাংলা চটি গল্প', slug: 'ajachar-bangla-choti-golpo'),
      SourceCategory(name: 'বৌদিকে চোদার গল্প', slug: 'boudi-ke-chodar-golpo'),
      SourceCategory(name: 'বাবা ও মেয়ের চটি গল্প', slug: 'baba-o-meyer-choti-golpo'),
      SourceCategory(name: 'ধারাবাহিক চটি উপন্যাস', slug: 'series'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    try {
      final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final url = cleanSlug == 'series'
          ? (page == 1 ? '$baseUrl/series/' : '$baseUrl/series/page/$page/')
          : (page == 1 ? '$baseUrl/category/$cleanSlug/' : '$baseUrl/category/$cleanSlug/page/$page/');
      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(categorySlug.replaceAll('-', ' '), page: page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Bengali Sex Story', slug: 'bengali-sex-story'),
      SourceTag(name: 'মা ছেলে চোদাচুদি', slug: 'ma-chele-chodachudi'),
      SourceTag(name: 'বৌদিকে চোদার গল্প', slug: 'boudi-ke-chodar-golpo'),
      SourceTag(name: 'ধারাবাহিক চটি', slug: 'series'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    try {
      final cleanSlug = tagSlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final url = cleanSlug == 'series'
          ? (page == 1 ? '$baseUrl/series/' : '$baseUrl/series/page/$page/')
          : (page == 1 ? '$baseUrl/tag/$cleanSlug/' : '$baseUrl/tag/$cleanSlug/page/$page/');
      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return search(tagSlug.replaceAll('-', ' '), page: page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final url = page == 1
        ? '$baseUrl/?s=${Uri.encodeComponent(query)}'
        : '$baseUrl/page/$page/?s=${Uri.encodeComponent(query)}';
    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final title = doc.querySelector('h1.entry-title')?.text.trim() ?? 'Bangla Story';
    final author = doc.querySelector('.entry-meta .author a')?.text.trim();
    final cover = doc.querySelector('.featured-image img, .page-header-image-single img')?.attributes['src'];

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
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

    // Strip ad containers and unwanted elements
    contentEl.querySelectorAll('.quads-location, [id^="quads-"], script, style, noscript, .post-navigation')
        .forEach((el) => el.remove());

    final paragraphs = contentEl.querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.post');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector('h2.entry-title a');
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final cover = article.querySelector('.post-image img, .featured-image img')?.attributes['src'];
      final author = article.querySelector('.author a')?.text.trim();
      final date = article.querySelector('time.published')?.text.trim();

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            coverUrl: cover,
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
