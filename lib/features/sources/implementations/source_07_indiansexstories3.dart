import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class IndianSexStories3Source implements BaseStorySource {
  @override
  String get id => 'indiansexstories3';

  @override
  String get name => 'Indian Sex Stories';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://www.indiansexstories3.com';

  @override
  String? get iconUrl =>
      'https://www.indiansexstories3.com/wp-content/uploads/2019/03/favicon.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Best Indian Sex Stories', slug: 'best-indian-sex-stories'),
      SourceCategory(name: 'Couple', slug: 'couple'),
      SourceCategory(name: 'Desi Stories', slug: 'desi'),
      SourceCategory(name: 'Hindi Sex Stories', slug: 'hindi-sex-stories'),
      SourceCategory(name: 'Incest', slug: 'incest'),
      SourceCategory(name: 'Group', slug: 'group'),
      SourceCategory(name: 'Lesbian', slug: 'lesbian'),
      SourceCategory(name: 'Gay Sex Stories', slug: 'gay-sex-stories'),
      SourceCategory(name: 'Maid Servant', slug: 'maid-servant'),
      SourceCategory(name: 'Naukrani', slug: 'naukrani'),
      SourceCategory(name: 'Office / Teacher', slug: 'office-teacher'),
      SourceCategory(name: 'Poetry / Jokes', slug: 'poetry-jokes'),
      SourceCategory(name: 'Rishton Mein Chudai', slug: 'rishton-mein-chudai'),
      SourceCategory(name: 'Samuhik Chudai', slug: 'samuhik-chudai'),
      SourceCategory(name: 'Teacher Ke Saath', slug: 'teacher-ke-saath'),
      SourceCategory(name: 'Virgin', slug: 'virgin'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
    final url = page == 1
        ? '$baseUrl/category/$cleanSlug/'
        : '$baseUrl/category/$cleanSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
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
      SourceTag(name: 'Cheating Wife', slug: 'cheating-wife'),
      SourceTag(name: 'Desi Kahani', slug: 'desi-kahani'),
      SourceTag(name: "Editor's Picks", slug: 'editors-picks'),
      SourceTag(name: 'Audio Sex Stories', slug: 'audio'),
      SourceTag(name: 'BDSM', slug: 'bdsm'),
      SourceTag(name: 'Big Boobs', slug: 'big-boobs'),
      SourceTag(name: 'Blowjob', slug: 'blowjob'),
      SourceTag(name: 'Cum Inside', slug: 'cum-inside'),
      SourceTag(name: 'Cum On Face', slug: 'cum-on-face'),
      SourceTag(name: 'Erotic', slug: 'erotic'),
      SourceTag(name: 'Handjob', slug: 'handjob'),
      SourceTag(name: 'Horny', slug: 'horny'),
      SourceTag(name: 'Kissing', slug: 'kissing'),
      SourceTag(name: 'Lust', slug: 'lust'),
      SourceTag(name: 'Mom & Son', slug: 'mom-and-son'),
      SourceTag(name: 'Savita Bhabhi', slug: 'savita-bhabhi'),
      SourceTag(name: 'Tamil Sex Stories', slug: 'tamil'),
      SourceTag(name: 'TMKOC Sex Stories', slug: 'tmkoc-sex-stories'),
      SourceTag(name: 'Velamma', slug: 'velamma-comics'),
      SourceTag(name: 'Gujarati', slug: 'gujarati'),
      SourceTag(name: 'Marathi', slug: 'marathi'),
      SourceTag(name: 'Malayalam', slug: 'malayalam-sex-story'),
      SourceTag(name: 'Armpit Fetish', slug: 'armpit-fetish'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    final cleanSlug = tagSlug.trim().replaceAll(RegExp(r'^/|/$'), '');
    final url = page == 1
        ? '$baseUrl/tag/$cleanSlug/'
        : '$baseUrl/tag/$cleanSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
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
    try {
      final encoded = Uri.encodeComponent(query);
      final url = page == 1
          ? '$baseUrl/?s=$encoded'
          : '$baseUrl/page/$page/?s=$encoded';
      final res = await ScraperClient.dio.get(url);
      return _parseListings(res.data.toString());
    } catch (_) {
      return [];
    }
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final title = doc
            .querySelector('h1.post-title, h1.entry-title, h1')
            ?.text
            .trim() ??
        'Indian Sex Story';
    final author = doc
        .querySelector('.meta-author a, .meta-author, .author a, .author')
        ?.text
        .trim();

    final genres = <String>{};
    for (final el in doc.querySelectorAll(
      '.meta-category a, .meta-tags a, footer .read-more a, a[rel*="category"], a[rel*="tag"]',
    )) {
      final g = el.text.trim();
      if (g.isNotEmpty) {
        genres.add(g);
      }
    }

    final summary = doc.querySelector('section.story-content p, .entry p')?.text.trim();

    // Multi-part series auto-resolution
    List<SourceChapter> chapters = [];
    final seriesHref = doc.querySelector('#story-parts a[href*="/series/"]')?.attributes['href'];
    if (seriesHref != null && seriesHref.isNotEmpty) {
      try {
        final seriesUrl = _resolveUrl(seriesHref);
        final sRes = await ScraperClient.dio.get(seriesUrl);
        final sDoc = html_parser.parse(sRes.data.toString());
        final sArticles = sDoc.querySelectorAll('article.post, article[id^="post-"]');
        if (sArticles.isNotEmpty) {
          // Series articles are published from newest to oldest; reverse to chronological order
          final reversed = sArticles.reversed.toList();
          for (int i = 0; i < reversed.length; i++) {
            final aEl = reversed[i].querySelector('h2.post-title a, h2 a, a');
            final cTitle = aEl?.text.trim() ?? 'Part ${i + 1}';
            final rawHref = aEl?.attributes['href'] ?? '';
            if (rawHref.isNotEmpty) {
              chapters.add(
                SourceChapter(
                  index: (i + 1).toDouble(),
                  title: cTitle,
                  url: _resolveUrl(rawHref),
                ),
              );
            }
          }
        }
      } catch (_) {}
    }

    // Default to standalone single chapter if not part of a series
    if (chapters.isEmpty) {
      chapters = [
        SourceChapter(
          index: 1.0,
          title: 'Full Story',
          url: url,
        ),
      ];
    }

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
      coverUrl: iconUrl,
      description: summary,
      status: 'Completed',
      genres: genres.toList(),
      chapters: chapters,
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final res = await ScraperClient.dio.get(chapterUrl);
    final doc = html_parser.parse(res.data.toString());

    final contentEl = doc.querySelector('section.story-content:not(.eos)') ??
        doc.querySelector('section.story-content') ??
        doc.querySelector('article.post') ??
        doc.querySelector('div.entry-content');
    if (contentEl == null) return '';

    // Remove unwanted widgets, ratings, scripts, and comments
    contentEl
        .querySelectorAll(
          'script, style, noscript, iframe, .eos, footer, section#comments, #disqus_thread, [class*="ad"], [id*="ad"]',
        )
        .forEach((el) => el.remove());

    final paragraphs = contentEl
        .querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty);

    return paragraphs.join('\n\n');
  }

  String _resolveUrl(String href) {
    if (href.startsWith('http://') || href.startsWith('https://')) {
      return href;
    }
    if (href.startsWith('/')) {
      return '$baseUrl$href';
    }
    return '$baseUrl/$href';
  }

  List<SourceListingItem> _parseListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.post, article[id^="post-"]');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector('h2.post-title a, h2 a, header a');
      final title = titleEl?.text.trim() ?? '';
      final rawHref = titleEl?.attributes['href'] ?? '';

      if (title.isEmpty || rawHref.isEmpty) continue;

      final url = _resolveUrl(rawHref);

      final dateEl = article.querySelector('span.meta-date');
      String? date = dateEl?.text
          .replaceFirst(RegExp(r'^On\s*', caseSensitive: false), '')
          .trim();
      if (date != null && date.isEmpty) date = null;

      final authorEl =
          article.querySelector('span.meta-author a, span.meta-author');
      final author = authorEl?.text.trim();

      final summaryEl =
          article.querySelector('p.exceprt, p.excerpt, .entry p');
      final summary = summaryEl?.text.trim();

      result.add(
        SourceListingItem(
          title: title,
          url: url,
          coverUrl: iconUrl,
          author: author,
          date: date,
          summary: summary,
          sourceId: id,
        ),
      );
    }

    return result;
  }
}
