import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class DesiTales2Source implements BaseStorySource {
  @override
  String get id => 'desitales2';

  @override
  String get name => 'Desi Tales';

  @override
  String get lang => 'hi';

  @override
  String get baseUrl => 'https://www.desitales2.com';

  @override
  String? get iconUrl =>
      'https://www.desitales2.com/wp-content/uploads/2017/06/Favicon.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Attempt REST API first for high performance
    try {
      final apiUrl =
          '$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=100&_embed=1';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        final items = _parseJsonListings(res.data as List);
        if (items.isNotEmpty) return items;
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
      SourceCategory(name: 'Couple', slug: 'couple', count: '1,978'),
      SourceCategory(name: 'Desi', slug: 'desi', count: '1,347'),
      SourceCategory(name: 'Incest', slug: 'incest', count: '1,080'),
      SourceCategory(name: 'Group Sex', slug: 'group-sex', count: '466'),
      SourceCategory(name: 'Office/Teacher', slug: 'office-teacher', count: '464'),
      SourceCategory(name: 'Virgin', slug: 'virgin', count: '387'),
      SourceCategory(name: 'Maid Servant', slug: 'maid-servant', count: '317'),
      SourceCategory(name: 'Rishton Mein Chudai', slug: 'rishton-mein-chudai', count: '295'),
      SourceCategory(name: 'Gay Male', slug: 'gay-male', count: '220'),
      SourceCategory(name: 'Girlfriend', slug: 'girlfriend', count: '130'),
      SourceCategory(name: 'Lesbian', slug: 'lesbian', count: '126'),
      SourceCategory(name: 'Foreign', slug: 'foreign', count: '112'),
      SourceCategory(name: 'Audio Sex Stories', slug: 'audio-sex-stories', count: '77'),
      SourceCategory(name: 'Samuhik Chudai', slug: 'samuhik-chudai', count: '64'),
      SourceCategory(name: 'Naukrani', slug: 'naukrani', count: '28'),
      SourceCategory(name: 'Teacher Ke Saath', slug: 'teacher-ke-saath', count: '23'),
      SourceCategory(name: 'Poetry/Jokes', slug: 'poetry-jokes', count: '15'),
      SourceCategory(name: 'Indian Sex Novels', slug: 'series', count: '356'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
    final url = cleanSlug == 'series'
        ? (page == 1 ? '$baseUrl/series/' : '$baseUrl/series/page/$page/')
        : (page == 1
            ? '$baseUrl/category/$cleanSlug/'
            : '$baseUrl/category/$cleanSlug/page/$page/');
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
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Blowjob', slug: 'blowjob'),
      SourceTag(name: 'Horny', slug: 'horny'),
      SourceTag(name: 'Wet Pussy', slug: 'wet-pussy'),
      SourceTag(name: 'Lund Chusai', slug: 'lund-chusai'),
      SourceTag(name: 'Big Boobs', slug: 'big-boobs'),
      SourceTag(name: 'Kissing', slug: 'kissing'),
      SourceTag(name: 'Chudai', slug: 'chudai'),
      SourceTag(name: 'Boobs Sucking', slug: 'boobs-sucking'),
      SourceTag(name: 'Lund', slug: 'lund'),
      SourceTag(name: 'Lust', slug: 'lust'),
      SourceTag(name: 'Kamukta', slug: 'kamukta'),
      SourceTag(name: 'Pussy Licking', slug: 'pussy-licking'),
      SourceTag(name: 'Handjob', slug: 'handjob'),
      SourceTag(name: 'Aunty', slug: 'aunty'),
      SourceTag(name: 'Doggy Style', slug: 'doggy-style'),
      SourceTag(name: 'Erotica', slug: 'erotica'),
      SourceTag(name: 'Bade Boobs', slug: 'bade-boobs'),
      SourceTag(name: 'Boobs Chusai', slug: 'boobs-chusai'),
      SourceTag(name: 'Girlfriend', slug: 'girlfriend-2'),
      SourceTag(name: 'Cum in Mouth', slug: 'cum-in-mouth'),
      SourceTag(name: 'Orgasm', slug: 'orgasm'),
      SourceTag(name: 'Chut', slug: 'chut'),
      SourceTag(name: 'Threesome', slug: 'threesome'),
      SourceTag(name: 'Big Ass', slug: 'big-ass'),
      SourceTag(name: 'Finger Fuck', slug: 'finger-fuck'),
      SourceTag(name: 'Milf', slug: 'milf'),
      SourceTag(name: 'Cum Inside', slug: 'cum-inside'),
      SourceTag(name: 'Married Woman', slug: 'married-woman'),
      SourceTag(name: 'Colleague', slug: 'colleague'),
      SourceTag(name: 'Chut Chusai', slug: 'chut-chusai'),
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
    final encoded = Uri.encodeComponent(query);
    // Attempt REST API first
    try {
      final apiUrl =
          '$baseUrl/wp-json/wp/v2/posts?search=$encoded&page=$page&per_page=100&_embed=1';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        final items = _parseJsonListings(res.data as List);
        if (items.isNotEmpty) return items;
      }
    } catch (_) {}

    // HTML search fallback
    try {
      final url = page == 1
          ? '$baseUrl/?s=$encoded'
          : '$baseUrl/page/$page/?s=$encoded';
      final res = await ScraperClient.dio.get(url);
      return _parseHtmlListings(res.data.toString());
    } catch (_) {
      return [];
    }
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final rawTitle = doc
            .querySelector('h1.entry-title, h1.page-title, h1')
            ?.text
            .trim() ??
        'Desi Story';
    final title = rawTitle
        .replaceFirst(RegExp(r'^Series:\s*', caseSensitive: false), '')
        .trim();

    final authorEl = doc.querySelector(
      '.entry-meta .author-name, .entry-meta .author a, .byline a',
    );
    String? author = authorEl?.text.trim();
    if (author != null && author.toLowerCase().startsWith('by')) {
      author = author.substring(2).trim();
    }

    final date = doc.querySelector('.entry-date, time, .posted-on')?.text.trim();
    final description = doc
            .querySelector('meta[property="og:description"]')
            ?.attributes['content']
            ?.trim() ??
        doc
            .querySelector('meta[name="description"]')
            ?.attributes['content']
            ?.trim() ??
        doc.querySelector('.entry-content p:not([class])')?.text.trim();

    final genres = <String>{};
    for (final el in doc.querySelectorAll(
      'footer.entry-footer .cat-links a, footer.entry-footer .tags-links a, .entry-meta .cat-links a, a[rel*="category"], a[rel*="tag"]',
    )) {
      final text = el.text.trim();
      if (text.isNotEmpty) {
        genres.add(text);
      }
    }

    List<SourceChapter> chapters = [];

    // Case 1: Direct Series overview URL (e.g. /series/savita-bhabhi-returns/)
    if (url.contains('/series/')) {
      final articles =
          doc.querySelectorAll('article.post, article.type-post, article');
      if (articles.isNotEmpty) {
        final reversed = articles.reversed.toList();
        for (int i = 0; i < reversed.length; i++) {
          final aEl = reversed[i].querySelector(
            'h2.entry-title a, .entry-title a, a',
          );
          final cTitle = aEl?.text.trim() ?? 'Part ${i + 1}';
          final rawHref = aEl?.attributes['href'] ?? '';
          final cDate =
              reversed[i].querySelector('.entry-date, time')?.text.trim();
          if (rawHref.isNotEmpty) {
            chapters.add(
              SourceChapter(
                index: (i + 1).toDouble(),
                title: cTitle,
                url: _resolveUrl(rawHref),
                releaseDate: cDate,
              ),
            );
          }
        }
      }
    } else {
      // Case 2: Post belongs to a multi-part novel series
      final seriesHref = doc
          .querySelector(
            '#story-parts header h3 a, #story-parts a[href*="/series/"]',
          )
          ?.attributes['href'];
      if (seriesHref != null && seriesHref.isNotEmpty) {
        try {
          final sRes = await ScraperClient.dio.get(_resolveUrl(seriesHref));
          final sDoc = html_parser.parse(sRes.data.toString());
          final sArticles =
              sDoc.querySelectorAll('article.post, article.type-post, article');
          if (sArticles.isNotEmpty) {
            final reversed = sArticles.reversed.toList();
            for (int i = 0; i < reversed.length; i++) {
              final aEl = reversed[i].querySelector(
                'h2.entry-title a, .entry-title a, a',
              );
              final cTitle = aEl?.text.trim() ?? 'Part ${i + 1}';
              final rawHref = aEl?.attributes['href'] ?? '';
              final cDate =
                  reversed[i].querySelector('.entry-date, time')?.text.trim();
              if (rawHref.isNotEmpty) {
                chapters.add(
                  SourceChapter(
                    index: (i + 1).toDouble(),
                    title: cTitle,
                    url: _resolveUrl(rawHref),
                    releaseDate: cDate,
                  ),
                );
              }
            }
          }
        } catch (_) {}
      }
    }

    // Case 3: Default standalone single story
    if (chapters.isEmpty) {
      chapters = [
        SourceChapter(
          index: 1.0,
          title: title.isNotEmpty ? title : 'Full Story',
          url: url,
          releaseDate: date,
        ),
      ];
    }

    return SourceNovelDetails(
      title: title.isNotEmpty ? title : 'Desi Story',
      url: url,
      author: author,
      coverUrl: iconUrl,
      description: description,
      status: 'Completed',
      genres: genres.toList(),
      chapters: chapters,
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final res = await ScraperClient.dio.get(chapterUrl);
    final doc = html_parser.parse(res.data.toString());

    final contentEl = doc.querySelector('div.entry-content');
    if (contentEl == null) return '';

    // Strip noise: interactive reporting modal, series boxes, revive banner ads, scripts, nav
    contentEl
        .querySelectorAll(
          '.story-report-container, .story-report-modal, #story-report-modal, '
          '#story-parts, iframe, script, style, noscript, '
          '.code-block, [class*="ad-"], [id*="ad-"], .yarpp-related, '
          'nav.post-navigation, .navigation, .post-navigation',
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

  List<SourceListingItem> _parseJsonListings(List posts) {
    return posts.map<SourceListingItem>((post) {
      final titleRaw = post['title']?['rendered']?.toString() ?? '';
      final title = html_parser.parse(titleRaw).body?.text.trim() ?? '';
      final url = post['link']?.toString() ?? '';
      final excerptRaw = post['excerpt']?['rendered']?.toString() ?? '';
      final summary = html_parser.parse(excerptRaw).body?.text.trim();
      final date = post['date']?.toString().split('T').first;

      return SourceListingItem(
        title: title.isNotEmpty ? title : 'Untitled Story',
        url: url,
        coverUrl: iconUrl,
        date: date,
        summary: summary != null && summary.isNotEmpty ? summary : null,
        sourceId: id,
      );
    }).where((item) => item.url.isNotEmpty).toList();
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll(
      'article.post, article.type-post, article[id^="post-"]',
    );
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector(
        'h2.entry-title a, header .entry-title a, .entry-title a',
      );
      final title = titleEl?.text.trim() ?? '';
      final rawHref = titleEl?.attributes['href'] ?? '';
      if (title.isEmpty || rawHref.isEmpty) continue;

      final url = _resolveUrl(rawHref);

      final dateEl = article.querySelector('.entry-date, time, .posted-on');
      final date = dateEl?.text.trim();

      final authorEl = article.querySelector(
        '.author-name, .entry-meta .author a, .byline a',
      );
      String? author = authorEl?.text.trim();
      if (author != null && author.toLowerCase().startsWith('by')) {
        author = author.substring(2).trim();
      }

      final summaryEl =
          article.querySelector('.entry-summary p, .entry-content p');
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
