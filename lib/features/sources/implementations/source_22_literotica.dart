import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class LiteroticaSource implements BaseStorySource {
  @override
  String get id => 'literotica';

  @override
  String get name => 'Literotica';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://www.literotica.com';

  @override
  String? get iconUrl => 'https://speedy.literotica.com/so/assets/favicon-C0wgbqSh.ico';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    return getCategoryStories('erotic-couplings', page: page);
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Erotic Couplings', slug: 'erotic-couplings'),
      SourceCategory(name: 'Anal Sex Stories', slug: 'anal-sex-stories'),
      SourceCategory(name: 'Audio Sex Stories', slug: 'audio-sex-stories'),
      SourceCategory(name: 'BDSM Stories', slug: 'bdsm-stories'),
      SourceCategory(name: 'Chain Stories', slug: 'chain-stories'),
      SourceCategory(name: 'Crossdressing', slug: 'crossdressing'),
      SourceCategory(name: 'Erotic Horror', slug: 'erotic-horror'),
      SourceCategory(name: 'Fetish Stories', slug: 'fetish-stories'),
      SourceCategory(name: 'Group Sex Stories', slug: 'group-sex-stories'),
      SourceCategory(name: 'Interracial Stories', slug: 'interracial-erotic-stories'),
      SourceCategory(name: 'Lesbian Sex Stories', slug: 'lesbian-sex-stories'),
      SourceCategory(name: 'Mature Erotica', slug: 'mature-erotica'),
      SourceCategory(name: 'First Time Sex', slug: 'first-time-sex-stories'),
      SourceCategory(name: 'Romance Stories', slug: 'romance-stories'),
      SourceCategory(name: 'Sci-Fi & Fantasy', slug: 'science-fiction-fantasy'),
      SourceCategory(name: 'Transgender', slug: 'transgender-crossdressers'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/c/$categorySlug'
        : '$baseUrl/c/$categorySlug?page=$page';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseLiteroticaListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Couplings', slug: 'erotic-couplings'),
      SourceTag(name: 'Anal', slug: 'anal-sex-stories'),
      SourceTag(name: 'BDSM', slug: 'bdsm-stories'),
      SourceTag(name: 'Romance', slug: 'romance-stories'),
      SourceTag(name: 'Fetish', slug: 'fetish-stories'),
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
    final encoded = Uri.encodeComponent(query);
    final url = '$baseUrl/search?q=$encoded&page=$page';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseLiteroticaListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/$url';
    final res = await ScraperClient.dio.get(cleanUrl);
    final doc = html_parser.parse(res.data.toString());

    final titleEl = doc.querySelector('h1') ?? doc.querySelector('title');
    final title = titleEl?.text.replaceFirst(RegExp(r"\s*-\s*Literotica\.com.*", caseSensitive: false), '').trim() ?? 'Literotica Story';

    final authorEl = doc.querySelector('a[href*="/authors/"]') ??
        doc.querySelector('a[href*="memberpage"]');
    final author = authorEl?.text.trim();

    return SourceNovelDetails(
      title: title,
      url: cleanUrl,
      author: author,
      status: 'Completed',
      chapters: [
        SourceChapter(
          index: 1.0,
          title: title,
          url: cleanUrl,
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http') ? chapterUrl : '$baseUrl/$chapterUrl';
    final res = await ScraperClient.dio.get(cleanUrl);
    final doc = html_parser.parse(res.data.toString());

    final contentEl = doc.querySelector('div[class*="_text_"]') ??
        doc.querySelector('.aa_ht') ??
        doc.querySelector('.b-story-body-x') ??
        doc.querySelector('.panel');
    if (contentEl == null) return 'Content could not be loaded.';

    for (final el in contentEl.querySelectorAll(
      'script, style, iframe, a[href*="litcares.com"], a[href*="literoti.com"], button',
    )) {
      el.remove();
    }

    final paragraphs = <String>[];
    for (final node in contentEl.querySelectorAll('p')) {
      final text = node.text.trim();
      if (text.length > 10) {
        paragraphs.add(text);
      }
    }

    if (paragraphs.isEmpty) {
      final text = contentEl.text.trim();
      return text.isNotEmpty ? text : 'Content is empty.';
    }

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseLiteroticaListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];

    final links = doc.querySelectorAll('a[href*="/s/"]');
    final seenUrls = <String>{};

    for (final a in links) {
      final title = a.text.trim();
      var href = a.attributes['href'] ?? '';
      if (title.isEmpty || href.isEmpty || title.length < 3) continue;

      if (!href.startsWith('http')) {
        href = '$baseUrl$href';
      }

      if (seenUrls.contains(href)) continue;
      seenUrls.add(href);

      items.add(
        SourceListingItem(
          title: title,
          url: href,
          sourceId: id,
        ),
      );
    }

    return items;
  }
}
