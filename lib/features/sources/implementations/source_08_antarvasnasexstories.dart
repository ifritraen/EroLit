import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

/// Source implementation for AntarvasnaSexStories (https://antarvasnasexstories.com/)
///
/// Features:
/// - Fast HTTP parsing via ScraperClient.dio with Chrome UA emulation
/// - Dual-mode parsing: dynamic article extraction with single-page template fallback
/// - Clean content sanitization stripping ads, scripts, and navigation chrome
/// - Resilient null safety across all endpoints
class AntarvasnaSexStoriesSource implements BaseStorySource {
  @override
  String get id => 'antarvasnasexstories';

  @override
  String get name => 'Antarvasna Sex Stories';

  @override
  String get lang => 'tr';

  @override
  String get baseUrl => 'https://antarvasnasexstories.com';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    try {
      final url = page == 1 ? '$baseUrl/' : '$baseUrl/stories.html?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());

      // If on page > 1 and the response is just the static fallback template,
      // return empty list to avoid infinite pagination loops.
      if (page > 1 && items.length <= 1) {
        return [];
      }
      return items;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Hikayeler (Stories)', slug: 'stories.html'),
      SourceCategory(name: 'Gecenin Hikayeleri', slug: 'gecenin-hikayeleri'),
      SourceCategory(name: 'Popüler Hikayeler', slug: 'populer'),
      SourceCategory(name: 'Yeni Eklenenler', slug: 'yeni'),
      SourceCategory(name: 'Romantik & Tutku', slug: 'romantik-tutku'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    try {
      final path = categorySlug.endsWith('.html') ? categorySlug : '$categorySlug/';
      final url = page == 1 ? '$baseUrl/$path' : '$baseUrl/$path?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (page > 1 && items.length <= 1) {
        return [];
      }
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Hikaye', slug: 'hikaye'),
      SourceTag(name: 'Tutku', slug: 'tutku'),
      SourceTag(name: 'Arzu', slug: 'arzu'),
      SourceTag(name: 'Antarvasna', slug: 'antarvasna'),
      SourceTag(name: '18+', slug: '18-plus'),
      SourceTag(name: 'Romantik', slug: 'romantik'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    try {
      final url = page == 1
          ? '$baseUrl/tag/$tagSlug/'
          : '$baseUrl/tag/$tagSlug/?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (page > 1 && items.length <= 1) {
        return [];
      }
      return items;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = page == 1
          ? '$baseUrl/?s=$encodedQuery'
          : '$baseUrl/?s=$encodedQuery&page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());

      final lowerQuery = query.toLowerCase();
      final filtered = items.where((item) {
        return item.title.toLowerCase().contains(lowerQuery) ||
            (item.summary?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();

      return filtered.isNotEmpty ? filtered : items;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    try {
      final res = await ScraperClient.dio.get(url);
      final doc = html_parser.parse(res.data.toString());

      // Attempt to extract title from heading or page-title
      var title = doc.querySelector('h1, h2.entry-title, h1.page-title')?.text.trim();

      // Check news-box or hero-box for specific story title if generic
      if (title == null || title.isEmpty || title.contains('Hoş Geldiniz')) {
        final newsText = doc.querySelector('.news-box p')?.text.trim() ?? '';
        final quoteMatch = RegExp(r'[“"]([^”"]+)[”"]').firstMatch(newsText);
        if (quoteMatch != null && quoteMatch.group(1) != null) {
          title = quoteMatch.group(1)!.trim();
        } else {
          title = 'Gecenin Sırrı';
        }
      }

      final summary = doc.querySelector('.hero-box p')?.text.trim() ??
          doc.querySelector('meta[name="description"]')?.attributes['content']?.trim() ??
          'AntarvasnaSexStories – tutku, arzu ve derin duyguların işlendiği özel hikaye koleksiyonu.';

      return SourceNovelDetails(
        title: title,
        url: url,
        author: 'Antarvasna',
        coverUrl: null,
        description: summary,
        status: 'Completed',
        genres: const ['Hikaye', 'Tutku', 'Romantik', '18+'],
        chapters: [
          SourceChapter(
            index: 1.0,
            title: title,
            url: url,
            releaseDate: '2026',
          ),
        ],
      );
    } catch (_) {
      return SourceNovelDetails(
        title: 'Antarvasna Story',
        url: url,
        author: 'Antarvasna',
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
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    try {
      final res = await ScraperClient.dio.get(chapterUrl);
      final doc = html_parser.parse(res.data.toString());

      // Remove non-content elements
      doc.querySelectorAll('script, style, noscript, header, footer, nav').forEach((el) => el.remove());

      // 1. Check for dedicated article content container
      final contentEl = doc.querySelector('div.entry-content, article .content, .story-body');
      if (contentEl != null) {
        final paragraphs = contentEl
            .querySelectorAll('p')
            .map((p) => p.text.trim())
            .where((t) => t.isNotEmpty);
        if (paragraphs.isNotEmpty) {
          return paragraphs.join('\n\n');
        }
      }

      // 2. Fallback to extracting textual blocks from page containers
      final pageContainer = doc.querySelector('section.page .container') ?? doc.body;
      if (pageContainer != null) {
        final paragraphs = pageContainer
            .querySelectorAll('.hero-box p, .news-box p, p')
            .map((p) => p.text.trim())
            .where((t) => t.isNotEmpty && !t.contains('©') && !t.contains('Tüm hakları'));
        if (paragraphs.isNotEmpty) {
          return paragraphs.toSet().join('\n\n');
        }
      }

      return '';
    } catch (_) {
      return '';
    }
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final List<SourceListingItem> results = [];

    // 1. Dynamic article cards
    final articles = doc.querySelectorAll('article, .entry-card, .story-card, .post');
    for (final article in articles) {
      final linkEl = article.querySelector('h2 a, h3 a, a.entry-title');
      final title = linkEl?.text.trim() ?? '';
      var itemUrl = linkEl?.attributes['href'] ?? '';
      if (itemUrl.isNotEmpty && !itemUrl.startsWith('http')) {
        itemUrl = '$baseUrl/${itemUrl.replaceFirst(RegExp(r"^/"), "")}';
      }

      final summary = article.querySelector('.excerpt, p, .entry-summary')?.text.trim();
      final cover = article.querySelector('img')?.attributes['src'];

      if (title.isNotEmpty && itemUrl.isNotEmpty) {
        results.add(
          SourceListingItem(
            title: title,
            url: itemUrl,
            coverUrl: cover,
            summary: summary,
            sourceId: id,
          ),
        );
      }
    }

    // 2. Template fallback mode if dynamic article cards are not present
    if (results.isEmpty) {
      final heroSummary = doc.querySelector('.hero-box p')?.text.trim() ??
          'AntarvasnaSexStories – tutku, arzu ve derin duyguların işlendiği özel hikaye koleksiyonu.';

      // Extract current release from news box
      final newsBox = doc.querySelector('.news-box p')?.text.trim() ?? '';
      final quoteMatch = RegExp(r'[“"]([^”"]+)[”"]').firstMatch(newsBox);
      final featuredTitle = quoteMatch?.group(1)?.trim() ?? 'Gecenin Sırrı';

      results.add(
        SourceListingItem(
          title: featuredTitle,
          url: '$baseUrl/stories.html#gecenin-sirri',
          summary: heroSummary,
          author: 'Antarvasna',
          date: '2026',
          sourceId: id,
        ),
      );

      // Extract additional stories/sections from navigation
      final navLinks = doc.querySelectorAll('nav ul li a');
      for (final link in navLinks) {
        final href = link.attributes['href'] ?? '';
        final text = link.text.trim();
        if (href.isNotEmpty && href.contains('stories') && !results.any((r) => r.url.contains(href))) {
          results.add(
            SourceListingItem(
              title: text.isNotEmpty ? text : 'Hikayeler Koleksiyonu',
              url: '$baseUrl/${href.replaceFirst(RegExp(r"^/"), "")}',
              summary: heroSummary,
              author: 'Antarvasna',
              date: '2026',
              sourceId: id,
            ),
          );
        }
      }
    }

    return results;
  }
}
