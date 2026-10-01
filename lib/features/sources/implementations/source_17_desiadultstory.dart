import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class DesiAdultStorySource implements BaseStorySource {
  @override
  String get id => 'desiadultstory';

  @override
  String get name => 'Desi Adult Story';

  @override
  String get lang => 'hi';

  @override
  String get baseUrl => 'https://www.desiadultstory.com';

  @override
  String? get iconUrl => 'https://www.desiadultstory.com/favicon.ico?v=2';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/?page=$page';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseHtmlListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'वर्जिन सेक्स स्टोरी', slug: 'virgin-sex-story'),
      SourceCategory(name: 'फर्स्ट टाइम सेक्स स्टोरीज', slug: 'first-time-sex-stories'),
      SourceCategory(name: 'अन्तर्वासना स्टोरीज', slug: 'real-antarvasn-stories'),
      SourceCategory(name: 'रंडी की चुदाई', slug: 'randi-ki-chudai'),
      SourceCategory(name: 'बीवी की चुदाई', slug: 'biwi-ki-chudai'),
      SourceCategory(name: 'ट्रेवल सेक्स स्टोरीज', slug: 'travel-sex-stories'),
      SourceCategory(name: 'कजिन के साथ सेक्स स्टोरीज', slug: 'cousin-ke-sath-sex-stories'),
      SourceCategory(name: 'बॉस के साथ सेक्स स्टोरीज', slug: 'boss-ke-sath-sex-stories'),
      SourceCategory(name: 'देसी सेक्स स्टोरीज', slug: 'desi-sex-kahani'),
      SourceCategory(name: 'गे सेक्स स्टोरीज', slug: 'gay-sex-stories'),
      SourceCategory(name: 'हिंदी सेक्स स्टोरीज', slug: 'hindi-sex-stories'),
      SourceCategory(name: 'ग्रुप सेक्स स्टोरीज', slug: 'group-sex-stories'),
      SourceCategory(name: 'आंटी सेक्स स्टोरीज', slug: 'aunty-sex-stories'),
      SourceCategory(name: 'साली सेक्स स्टोरीज', slug: 'sali-sex-stories'),
      SourceCategory(name: 'टीनएज गर्ल सेक्स स्टोरीज', slug: 'teenage-girl-sex-stories'),
      SourceCategory(name: 'टीचर सेक्स स्टोरीज', slug: 'teacher-sex-stories'),
      SourceCategory(name: 'XXX कहानी', slug: 'xxx-kahani'),
      SourceCategory(name: 'चुदाई की कहानी', slug: 'chudai-ki-kahani'),
      SourceCategory(name: 'भाभी सेक्स स्टोरीज', slug: 'bhabhi-sex-stories'),
      SourceCategory(name: 'फॅमिली सेक्स स्टोरीज', slug: 'family-sex-stories'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/$categorySlug/'
        : '$baseUrl/$categorySlug/?page=$page';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseHtmlListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'वर्जिन', slug: 'virgin-sex-story'),
      SourceTag(name: 'भाभी', slug: 'bhabhi-sex-stories'),
      SourceTag(name: 'फॅमिली', slug: 'family-sex-stories'),
      SourceTag(name: 'ग्रुप सेक्स', slug: 'group-sex-stories'),
      SourceTag(name: 'आंटी', slug: 'aunty-sex-stories'),
      SourceTag(name: 'साली', slug: 'sali-sex-stories'),
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
    final url = page == 1
        ? '$baseUrl/search.php?s=$encoded'
        : '$baseUrl/search.php?s=$encoded&page=$page';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseHtmlListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/${url.replaceFirst(RegExp(r"^/+"), "")}';
    final res = await ScraperClient.dio.get(cleanUrl);
    final doc = html_parser.parse(res.data.toString());

    final titleEl = doc.querySelector('h1');
    final title = titleEl?.text.trim() ?? 'Hindi Story';

    final categoryEl = doc.querySelector('.meta-category a') ?? doc.querySelector('a[href*="-sex-"]');
    final genres = <String>[];
    if (categoryEl != null && categoryEl.text.trim().isNotEmpty) {
      genres.add(categoryEl.text.trim());
    }

    final dateEl = doc.querySelector('.meta-date');
    final date = dateEl?.text.replaceFirst(RegExp(r"^On\s*", caseSensitive: false), '').trim();

    final firstP = doc.querySelector('div.clss4 p, .container.box_shadow p');
    final description = firstP?.text.trim();

    return SourceNovelDetails(
      title: title,
      url: cleanUrl,
      description: description,
      status: 'Completed',
      genres: genres,
      chapters: [
        SourceChapter(
          index: 1.0,
          title: title,
          url: cleanUrl,
          releaseDate: date,
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http')
        ? chapterUrl
        : '$baseUrl/${chapterUrl.replaceFirst(RegExp(r"^/+"), "")}';
    final res = await ScraperClient.dio.get(cleanUrl);
    final doc = html_parser.parse(res.data.toString());

    final container = doc.querySelector('div.clss4') ??
        doc.querySelector('.container.box_shadow') ??
        doc.body;
    if (container == null) return 'Content could not be loaded.';

    // Clean headers, navigation, footers, APK links, and YouTube embeds
    for (final el in container.querySelectorAll(
      'header, nav, script, style, iframe, .header, .navbar, .logo, a[href*="app-release.apk"]',
    )) {
      el.remove();
    }

    final paragraphs = <String>[];
    for (final p in container.querySelectorAll('p')) {
      final text = p.text.trim();
      if (text.isEmpty) continue;
      // Skip disclaimer
      if (text.contains('गोपनीय रहेगी') || text.contains('साझा नहीं की जायेगी')) {
        continue;
      }
      paragraphs.add(text);
    }

    if (paragraphs.isEmpty) {
      final text = container.text.trim();
      return text.isNotEmpty ? text : 'Content is empty.';
    }

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];

    final cards = doc.querySelectorAll('.proj_block');
    for (final card in cards) {
      final linkEl = card.querySelector('h3 a.clss1') ?? card.querySelector('h3 a');
      if (linkEl == null) continue;

      final title = linkEl.text.trim();
      var rawHref = linkEl.attributes['href'] ?? '';
      if (title.isEmpty || rawHref.isEmpty) continue;

      if (!rawHref.startsWith('http')) {
        rawHref = '$baseUrl/${rawHref.replaceFirst(RegExp(r"^/+"), "")}';
      }

      final dateEl = card.querySelector('.meta-date');
      final date = dateEl?.text.replaceFirst(RegExp(r"^On\s*", caseSensitive: false), '').trim();

      final summaryEl = card.querySelector('p.txts') ?? card.querySelector('p');

      items.add(
        SourceListingItem(
          title: title,
          url: rawHref,
          sourceId: id,
          date: date,
          summary: summaryEl?.text.trim(),
        ),
      );
    }

    return items;
  }
}
