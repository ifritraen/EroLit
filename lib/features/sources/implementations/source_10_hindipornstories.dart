import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class HindiPornStoriesSource implements BaseStorySource {
  @override
  String get id => 'hindipornstories';

  @override
  String get name => 'Hindi Porn Stories';

  @override
  String get lang => 'hi';

  @override
  String get baseUrl => 'https://hindipornstories.org';

  @override
  String? get iconUrl => 'https://hindipornstories.org/favicon.ico';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(
        name: 'देसी पोर्न कहानियाँ',
        slug: 'desi-porn-kahani',
        count: '174',
      ),
      SourceCategory(name: 'अन्तर्वासना', slug: 'antarvasna', count: '126'),
      SourceCategory(
        name: 'फ्री सेक्स कहानी',
        slug: 'free-sex-kahani',
        count: '233',
      ),
      SourceCategory(
        name: 'अन्तर्वासना चुदाई की फोटो',
        slug: 'antarvasna-pics',
        count: '101',
      ),
      SourceCategory(
        name: 'एक्सएक्सएक्स कहानी',
        slug: 'xxx-kahani',
        count: '88',
      ),
      SourceCategory(name: 'Choti Stories', slug: 'choti-stories', count: '84'),
      SourceCategory(name: 'कोई मिल गया', slug: 'cheating-wife', count: '83'),
      SourceCategory(
        name: 'रिश्तों में चुदाई',
        slug: 'incest-sex-stories',
        count: '66',
      ),
      SourceCategory(name: 'Sex stories', slug: 'sex-stories', count: '63'),
      SourceCategory(
        name: 'लड़कियों की गांड चुदाई',
        slug: 'anal-sex-stories-female',
        count: '62',
      ),
      SourceCategory(
        name: 'भाभी की चुदाई',
        slug: 'bhabhi-ki-chudai',
        count: '55',
      ),
      SourceCategory(name: 'Desi Kahani', slug: 'desi-kahani', count: '48'),
      SourceCategory(
        name: 'इंडियन बीवी की चुदाई',
        slug: 'desi-wife-sex-stories',
        count: '44',
      ),
      SourceCategory(name: 'माँ की चुदाई', slug: 'maa-ki-chudai', count: '41'),
      SourceCategory(
        name: 'ग्रुप सेक्स स्टोरी',
        slug: 'group-sex-stories',
        count: '39',
      ),
      SourceCategory(name: 'मेरी चुदाई', slug: 'meri-chudai', count: '39'),
      SourceCategory(
        name: 'हिंदी सेक्स स्टोरीज',
        slug: 'hindi-sex-stories',
        count: '34',
      ),
      SourceCategory(
        name: 'पहली बार की चुदाई',
        slug: 'first-time-sex',
        count: '33',
      ),
      SourceCategory(
        name: 'Hindi Sex Kahaniya',
        slug: 'hindi-sex-kahaniya',
        count: '29',
      ),
      SourceCategory(
        name: 'पड़ोसन / पडोसी से चुदाई',
        slug: 'padosi',
        count: '22',
      ),
      SourceCategory(
        name: 'चाची की चुदाई',
        slug: 'chachi-ki-chudai',
        count: '20',
      ),
      SourceCategory(name: 'जीजा - साली', slug: 'jija-sali', count: '12'),
      SourceCategory(
        name: 'कोई देख रहा है',
        slug: 'voyeur-sex-stories',
        count: '16',
      ),
      SourceCategory(
        name: 'नौकर-नौकरानी',
        slug: 'desi-maid-servant-sex-stories',
        count: '13',
      ),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final cleanSlug = categorySlug
        .replaceAll(RegExp(r'^/+'), '')
        .replaceAll(RegExp(r'/+$'), '')
        .replaceFirst('category/', '');
    final url = page == 1
        ? '$baseUrl/$cleanSlug/'
        : '$baseUrl/$cleanSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    try {
      final fallbackUrl = page == 1
          ? '$baseUrl/category/$cleanSlug/'
          : '$baseUrl/category/$cleanSlug/page/$page/';
      final res = await ScraperClient.dio.get(fallbackUrl);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    try {
      final searchItems = await search(cleanSlug.replaceAll('-', ' '), page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'देसी भाभी सेक्स', slug: 'desi-bhabhi-sex'),
      SourceTag(name: 'गांड की चुदाई', slug: 'gand-ki-chudai'),
      SourceTag(name: 'आंटी', slug: 'aunty'),
      SourceTag(name: 'चुदाई की कहानी', slug: 'chudai-ki-kahani'),
      SourceTag(name: 'मस्तराम सेक्स स्टोरी', slug: 'mastram-sex-story'),
      SourceTag(name: 'गर्म कहानी', slug: 'garam-kahani'),
      SourceTag(name: 'कामवासना', slug: 'kamvasna'),
      SourceTag(name: 'बुर', slug: 'bur'),
      SourceTag(name: 'चूत', slug: 'chut'),
      SourceTag(name: 'लंड', slug: 'lund'),
      SourceTag(name: 'कॉलेज गर्ल', slug: 'college-girl'),
      SourceTag(name: 'ओरल सेक्स', slug: 'oral-sex'),
      SourceTag(name: 'नंगी लड़की', slug: 'nangi-ladki'),
      SourceTag(name: 'रियल सेक्स स्टोरी', slug: 'real-sex-story'),
      SourceTag(name: 'देसी माँ', slug: 'desi-maa'),
      SourceTag(name: 'देसी आंटी सेक्स', slug: 'desi-aunty-sex'),
      SourceTag(name: 'पॉर्न स्टोरी इन हिंदी', slug: 'porn-story-in-hindi'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    final cleanSlug = tagSlug
        .replaceAll(RegExp(r'^/+'), '')
        .replaceAll(RegExp(r'/+$'), '')
        .replaceFirst('tag/', '');
    final url = page == 1
        ? '$baseUrl/tag/$cleanSlug/'
        : '$baseUrl/tag/$cleanSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    try {
      final searchItems = await search(cleanSlug.replaceAll('-', ' '), page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final cleanQuery = Uri.encodeComponent(query.trim());
    try {
      final url = page == 1
          ? '$baseUrl/search/$cleanQuery/'
          : '$baseUrl/search/$cleanQuery/page/$page/';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    final fallbackUrl = page == 1
        ? '$baseUrl/?s=$cleanQuery'
        : '$baseUrl/page/$page/?s=$cleanQuery';
    final res = await ScraperClient.dio.get(fallbackUrl);
    return _parseHtmlListings(res.data.toString());
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final title =
        doc.querySelector('h1.entry-title, h1')?.text.trim() ?? 'Hindi Story';
    final coverUrl = doc
        .querySelector('meta[property="og:image"]')
        ?.attributes['content'];
    final description = doc
        .querySelector(
          'meta[name="description"], meta[property="og:description"]',
        )
        ?.attributes['content']
        ?.trim();
    final releaseDate =
        doc
            .querySelector('meta[property="article:published_time"]')
            ?.attributes['content'] ??
        doc.querySelector('time.entry-date, time')?.text.trim();

    String? author = doc
        .querySelector('.entry-meta .author a, .byline a, meta[name="author"]')
        ?.text
        .trim();
    if (author == null || author.isEmpty) {
      for (final script in doc.querySelectorAll(
        'script[type="application/ld+json"]',
      )) {
        final text = script.text;
        final match = RegExp(
          r'"author"\s*:\s*(?:\{[^}]*"name"\s*:\s*"([^"]+)"|"([^"]+)")',
        ).firstMatch(text);
        if (match != null) {
          author = match.group(1) ?? match.group(2);
          break;
        }
      }
    }
    author ??= 'Antarvasna';

    final genres = <String>{};
    for (final el in doc.querySelectorAll('.cat-links a, .tags-links a')) {
      final text = el.text.trim();
      if (text.isNotEmpty) {
        genres.add(text);
      }
    }

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
      coverUrl: coverUrl,
      description: description,
      status: 'Completed',
      genres: genres.toList(),
      chapters: [
        SourceChapter(
          index: 1.0,
          title: 'सम्पूर्ण कहानी (Full Story)',
          url: url,
          releaseDate: releaseDate,
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

    // Remove YARPP related widgets, ad blocks, scripts, and navigation
    contentEl
        .querySelectorAll(
          '.yarpp-related, .yarpp, [class*="yarpp"], script, style, noscript, iframe, [class*="banner"], [class*="advertisement"], [id*="ad-"], nav.post-navigation, .post-navigation, .sharedaddy',
        )
        .forEach((el) => el.remove());

    final paragraphs = contentEl
        .querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    if (paragraphs.isNotEmpty) {
      return paragraphs.join('\n\n');
    }

    return contentEl.text.trim();
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll(
      'article.post, article[id^="post-"], article',
    );
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector(
        'h2.entry-title a, h2 a, .entry-title a',
      );
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final summaryEl = article.querySelector(
        '.entry-summary p, .entry-content p, .entry-summary, .entry-content',
      );
      final summary = summaryEl?.text.trim();

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
