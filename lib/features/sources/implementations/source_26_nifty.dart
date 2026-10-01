import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class NiftySource implements BaseStorySource {
  @override
  String get id => 'nifty';

  @override
  String get name => 'Nifty Archive';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://www.nifty.org';

  @override
  String? get iconUrl => 'https://www.nifty.org/favicon.ico';

  static const String _searchBaseUrl = 'https://search.niftyarchives.org';

  static const Set<String> _topSections = {
    'gay',
    'bisexual',
    'lesbian',
    'transgender',
    'bestiality',
  };

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // 1. Primary: Search appliance paginated global feed
    try {
      final url = page == 1
          ? '$_searchBaseUrl/'
          : '$_searchBaseUrl/?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseSearchResults(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // 2. Secondary: Fallback to new.html
    try {
      final res = await ScraperClient.dio.get('$baseUrl/nifty/new.html');
      final allItems = _parseNewHtmlListings(res.data.toString());
      if (allItems.isNotEmpty) {
        final startIndex = (page - 1) * 20;
        if (startIndex < allItems.length) {
          final endIndex = (startIndex + 20 < allItems.length)
              ? startIndex + 20
              : allItems.length;
          return allItems.sublist(startIndex, endIndex);
        }
      }
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Gay Male', slug: 'gay', count: '71,800+'),
      SourceCategory(name: 'Bisexual', slug: 'bisexual', count: '7,500+'),
      SourceCategory(name: 'Lesbian', slug: 'lesbian', count: '6,900+'),
      SourceCategory(name: 'Transgender', slug: 'transgender', count: '5,200+'),
      SourceCategory(name: 'Bestiality', slug: 'bestiality', count: '1,000+'),
      SourceCategory(name: 'College', slug: 'college', count: '4,790+'),
      SourceCategory(
        name: 'Adult Youth',
        slug: 'adult-youth',
        count: '13,980+',
      ),
      SourceCategory(
        name: 'Adult Friends',
        slug: 'adult-friends',
        count: '6,060+',
      ),
      SourceCategory(name: 'High School', slug: 'highschool', count: '8,610+'),
      SourceCategory(name: 'Encounters', slug: 'encounters', count: '7,780+'),
      SourceCategory(name: 'Beginnings', slug: 'beginnings', count: '5,230+'),
      SourceCategory(name: 'Incest', slug: 'incest', count: '12,070+'),
      SourceCategory(
        name: 'Sci-Fi & Fantasy',
        slug: 'sf-fantasy',
        count: '3,310+',
      ),
      SourceCategory(name: 'Romance', slug: 'romance', count: '180+'),
      SourceCategory(name: 'Athletics', slug: 'athletics', count: '1,970+'),
      SourceCategory(
        name: 'Authoritarian',
        slug: 'authoritarian',
        count: '9,130+',
      ),
      SourceCategory(name: 'Celebrity', slug: 'celebrity', count: '6,950+'),
      SourceCategory(name: 'Military', slug: 'military', count: '960+'),
      SourceCategory(
        name: 'Relationships',
        slug: 'relationships',
        count: '1,300+',
      ),
      SourceCategory(
        name: 'Young Friends',
        slug: 'young-friends',
        count: '5,510+',
      ),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    // 1. Primary: Search appliance with categories[] or subcategories[]
    try {
      final isTop = _topSections.contains(categorySlug.toLowerCase());
      final paramName = isTop ? 'categories[]' : 'subcategories[]';
      final url =
          '$_searchBaseUrl/?$paramName=${Uri.encodeComponent(categorySlug)}&page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseSearchResults(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // 2. Secondary: Fallback to directory scraping on origin
    try {
      final isTop = _topSections.contains(categorySlug.toLowerCase());
      final dirUrl = isTop
          ? '$baseUrl/nifty/$categorySlug/'
          : '$baseUrl/nifty/gay/$categorySlug/';
      final res = await ScraperClient.dio.get(dirUrl);
      final items = _parseDirectoryStories(res.data.toString(), dirUrl);
      if (items.isNotEmpty) {
        final startIndex = (page - 1) * 20;
        if (startIndex < items.length) {
          final endIndex = (startIndex + 20 < items.length)
              ? startIndex + 20
              : items.length;
          return items.sublist(startIndex, endIndex);
        }
      }
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'College', slug: 'college'),
      SourceTag(name: 'Adult-Youth', slug: 'adult-youth'),
      SourceTag(name: 'High School', slug: 'highschool'),
      SourceTag(name: 'Encounters', slug: 'encounters'),
      SourceTag(name: 'Beginnings', slug: 'beginnings'),
      SourceTag(name: 'Incest', slug: 'incest'),
      SourceTag(name: 'Adult-Friends', slug: 'adult-friends'),
      SourceTag(name: 'Sci-Fi & Fantasy', slug: 'sf-fantasy'),
      SourceTag(name: 'Romance', slug: 'romance'),
      SourceTag(name: 'Athletics', slug: 'athletics'),
      SourceTag(name: 'Camping', slug: 'camping'),
      SourceTag(name: 'Celebrity', slug: 'celebrity'),
      SourceTag(name: 'Military', slug: 'military'),
      SourceTag(name: 'Masturbation', slug: 'masturbation'),
      SourceTag(name: 'Interracial', slug: 'interracial'),
      SourceTag(name: 'Relationships', slug: 'relationships'),
      SourceTag(name: 'Rural', slug: 'rural'),
      SourceTag(name: 'Historical', slug: 'historical'),
      SourceTag(name: 'TV / Crossdressing', slug: 'tv'),
      SourceTag(name: 'She-Male', slug: 'she-male'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    // 1. Primary: Query subcategories on search appliance
    try {
      final url =
          '$_searchBaseUrl/?subcategories[]=${Uri.encodeComponent(tagSlug)}&page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseSearchResults(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // 2. Secondary: Keyword search fallback
    return search(tagSlug, page: page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    // 1. Primary: Search appliance
    try {
      final encoded = Uri.encodeComponent(query);
      final url = '$_searchBaseUrl/?keywords=$encoded&page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseSearchResults(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // 2. Secondary: Fallback to filtering new.html
    try {
      final res = await ScraperClient.dio.get('$baseUrl/nifty/new.html');
      final allItems = _parseNewHtmlListings(res.data.toString());
      final qLower = query.toLowerCase();
      final filtered = allItems
          .where((item) => item.title.toLowerCase().contains(qLower))
          .toList();
      if (filtered.isNotEmpty) {
        final startIndex = (page - 1) * 20;
        if (startIndex < filtered.length) {
          final endIndex = (startIndex + 20 < filtered.length)
              ? startIndex + 20
              : filtered.length;
          return filtered.sublist(startIndex, endIndex);
        }
      }
    } catch (_) {}

    return [];
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/$url';
    final fallbackTitle = _titleFromSlug(cleanUrl);

    try {
      final res = await ScraperClient.dio.get(
        cleanUrl,
        options: Options(responseType: ResponseType.plain),
      );
      final content = res.data.toString();

      // Check if this is a directory index (Multi-part saga)
      final isDirectory =
          cleanUrl.endsWith('/') ||
          content.contains('class="table') ||
          content.contains('class="ftr"') ||
          content.contains('Filename');

      if (isDirectory) {
        return _parseDirectoryNovelDetails(content, cleanUrl, fallbackTitle);
      } else {
        return _parseStandaloneNovelDetails(content, cleanUrl, fallbackTitle);
      }
    } catch (_) {
      // Fallback guarantees no unhandled exception
      return SourceNovelDetails(
        title: fallbackTitle,
        url: cleanUrl,
        status: 'Completed',
        chapters: [
          SourceChapter(index: 1.0, title: fallbackTitle, url: cleanUrl),
        ],
      );
    }
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http')
        ? chapterUrl
        : '$baseUrl/$chapterUrl';

    try {
      final res = await ScraperClient.dio.get(
        cleanUrl,
        options: Options(responseType: ResponseType.plain),
      );
      final raw = res.data.toString();
      if (raw.trim().isEmpty) return 'Story content is empty.';

      // Case 1: HTML formatted chapter
      if (raw.contains('<html') ||
          raw.contains('<!DOCTYPE') ||
          raw.contains('<p') ||
          raw.contains('<pre')) {
        final doc = html_parser.parse(raw);
        for (final el in doc.querySelectorAll(
          'script, style, iframe, header, nav, footer, .navbar',
        )) {
          el.remove();
        }

        // Check for <pre> tag first
        final preEl = doc.querySelector('pre');
        if (preEl != null && preEl.text.trim().length > 50) {
          return _cleanPlainText(preEl.text);
        }

        // Check for <p> tags
        final paragraphs = <String>[];
        for (final p in doc.querySelectorAll('p')) {
          final text = p.text.trim();
          if (text.isNotEmpty &&
              !text.toLowerCase().contains('donate to nifty') &&
              !text.toLowerCase().contains('free service available')) {
            paragraphs.add(text);
          }
        }

        if (paragraphs.isNotEmpty) {
          return paragraphs.join('\n\n');
        }

        // Fallback to body text
        final bodyText = doc.body?.text.trim() ?? '';
        if (bodyText.isNotEmpty) {
          return _cleanPlainText(bodyText);
        }
      }

      // Case 2: Plaintext / Usenet RFC-822 formatted chapter
      return _cleanPlainText(raw);
    } catch (_) {
      return 'Story content could not be loaded.';
    }
  }

  // --- Private Parsing Helpers ---

  List<SourceListingItem> _parseSearchResults(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};

    final rows = doc.querySelectorAll('table.results tbody tr');
    for (final row in rows) {
      final mainLink =
          row.querySelector('td a[style*="font-weight: bold"]') ??
          row.querySelector('td:first-child a');
      if (mainLink == null) continue;

      var href = mainLink.attributes['href'] ?? '';
      if (href.isEmpty ||
          href.contains('categories[]=') ||
          href.contains('subcategories[]=')) {
        continue;
      }
      if (!href.startsWith('http')) {
        href = '$baseUrl$href';
      }

      if (seenUrls.contains(href)) continue;
      seenUrls.add(href);

      final title = _titleFromSlug(
        mainLink.text.trim().isNotEmpty ? mainLink.text.trim() : href,
      );
      final dateEl = row.querySelector('td:last-child');
      final date = dateEl?.text.trim();

      // Extract subcategory/tag badge if present
      final badgeEl =
          row.querySelector('span.label-info') ??
          row.querySelector('span.label-success');
      final summary = badgeEl?.text.trim();

      items.add(
        SourceListingItem(
          title: title,
          url: href,
          date: date,
          summary: summary,
          sourceId: id,
        ),
      );
    }

    return items;
  }

  List<SourceListingItem> _parseNewHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};

    for (final row in doc.querySelectorAll('tr')) {
      final link = row.querySelector('a');
      if (link == null) continue;

      var href = link.attributes['href'] ?? '';
      if (href.isEmpty || href.startsWith('#') || href.startsWith('http')) {
        continue;
      }

      final fullUrl = '$baseUrl/nifty/$href';
      if (seenUrls.contains(fullUrl)) continue;
      seenUrls.add(fullUrl);

      final title = _titleFromSlug(
        link.text.trim().isNotEmpty ? link.text.trim() : href,
      );
      final tds = row.querySelectorAll('td');
      final size = tds.isNotEmpty ? tds[0].text.trim() : null;
      final date = tds.length > 1 ? tds[1].text.trim() : null;

      items.add(
        SourceListingItem(
          title: title,
          url: fullUrl,
          date: date,
          summary: size != null && size.isNotEmpty ? 'Size: $size' : null,
          sourceId: id,
        ),
      );
    }

    return items;
  }

  List<SourceListingItem> _parseDirectoryStories(String html, String dirUrl) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};

    final baseUri = Uri.parse(dirUrl);
    final links = doc.querySelectorAll('a');

    for (final a in links) {
      final href = a.attributes['href'] ?? '';
      if (href.isEmpty ||
          href.startsWith('/') ||
          href.startsWith('http') ||
          href.startsWith('#') ||
          href.startsWith('?') ||
          href.contains('authors') ||
          href.contains('submission')) {
        continue;
      }

      final resolvedUrl = baseUri.resolve(href).toString();
      if (seenUrls.contains(resolvedUrl)) continue;
      seenUrls.add(resolvedUrl);

      final text = a.text.trim();
      final title = _titleFromSlug(text.isNotEmpty ? text : href);

      items.add(
        SourceListingItem(title: title, url: resolvedUrl, sourceId: id),
      );
    }

    return items;
  }

  SourceNovelDetails _parseDirectoryNovelDetails(
    String html,
    String cleanUrl,
    String fallbackTitle,
  ) {
    final doc = html_parser.parse(html);
    final baseUri = Uri.parse(cleanUrl.endsWith('/') ? cleanUrl : '$cleanUrl/');

    // Extract title from breadcrumb or page header
    String title = fallbackTitle;
    final breadcrumbLast = doc.querySelector('.breadcrumb li:last-child');
    if (breadcrumbLast != null && breadcrumbLast.text.trim().isNotEmpty) {
      title = _titleFromSlug(breadcrumbLast.text.trim());
    } else {
      final h1 = doc.querySelector('h1');
      if (h1 != null && h1.text.trim().isNotEmpty) {
        title = _titleFromSlug(h1.text.trim());
      }
    }

    final chapterLinks = <String, String>{};
    for (final a in doc.querySelectorAll('table a, .ftr a, a')) {
      final href = a.attributes['href'] ?? '';
      if (href.isEmpty ||
          href.startsWith('/') ||
          href.startsWith('http') ||
          href.startsWith('#') ||
          href.startsWith('?') ||
          href.endsWith('/') ||
          href.contains('nifty.org') ||
          href.contains('donate') ||
          href.contains('authors')) {
        continue;
      }

      final resolvedUrl = baseUri.resolve(href).toString();
      final chapterName = a.text.trim().isNotEmpty ? a.text.trim() : href;
      chapterLinks[resolvedUrl] = chapterName;
    }

    final chapters = <SourceChapter>[];
    if (chapterLinks.isNotEmpty) {
      // Sort chapters in natural ascending order
      final sortedEntries = chapterLinks.entries.toList();
      sortedEntries.sort((a, b) => _naturalCompare(a.key, b.key));

      var idx = 1.0;
      for (final entry in sortedEntries) {
        chapters.add(
          SourceChapter(
            index: idx++,
            title: _formatChapterTitle(entry.value, idx - 1),
            url: entry.key,
          ),
        );
      }
    } else {
      chapters.add(SourceChapter(index: 1.0, title: title, url: cleanUrl));
    }

    return SourceNovelDetails(
      title: title,
      url: cleanUrl,
      status: 'Completed',
      chapters: chapters,
    );
  }

  SourceNovelDetails _parseStandaloneNovelDetails(
    String content,
    String cleanUrl,
    String fallbackTitle,
  ) {
    String title = fallbackTitle;
    String? author;

    // Check for Usenet RFC-822 headers
    final fromMatch = RegExp(
      r'^From:\s*(.*)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(content);
    final subjectMatch = RegExp(
      r'^Subject:\s*(.*)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(content);

    if (subjectMatch != null) {
      final s = subjectMatch.group(1)?.trim();
      if (s != null && s.isNotEmpty) {
        title = s.replaceAll(RegExp(r'\([^\)]+\)$'), '').trim();
      }
    }

    if (fromMatch != null) {
      final f = fromMatch.group(1)?.trim();
      if (f != null && f.isNotEmpty) {
        author = f.replaceAll(RegExp(r'<[^>]+>'), '').trim();
      }
    }

    // If HTML title exists and no RFC header matched
    if (subjectMatch == null &&
        (content.contains('<html') || content.contains('<title'))) {
      final doc = html_parser.parse(content);
      final t = doc.querySelector('title')?.text.trim();
      if (t != null && t.isNotEmpty) {
        title = t
            .replaceAll(RegExp(r'^Nifty Archive:\s*', caseSensitive: false), '')
            .trim();
      }
      final h1 = doc.querySelector('h1')?.text.trim();
      if (h1 != null &&
          h1.isNotEmpty &&
          (title.isEmpty || title == fallbackTitle)) {
        title = h1;
      }
    }

    return SourceNovelDetails(
      title: title.isNotEmpty ? title : fallbackTitle,
      url: cleanUrl,
      author: author,
      status: 'Completed',
      chapters: [
        SourceChapter(
          index: 1.0,
          title: title.isNotEmpty ? title : fallbackTitle,
          url: cleanUrl,
        ),
      ],
    );
  }

  String _cleanPlainText(String text) {
    var s = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    if (s.startsWith('\ufeff')) {
      s = s.substring(1);
    }

    // Strip RFC-822 headers if present at the beginning
    if (RegExp(
      r'^(?:date|from|subject|newsgroups|path):',
      caseSensitive: false,
    ).hasMatch(s)) {
      final headerEnd = s.indexOf('\n\n');
      if (headerEnd != -1) {
        s = s.substring(headerEnd + 2);
      }
    }

    // Split paragraphs by blank lines
    final rawParas = s.split(RegExp(r'\n\s*\n'));
    final paragraphs = <String>[];

    for (final p in rawParas) {
      final trimmed = p.trim();
      if (trimmed.isEmpty) continue;

      // Filter out donation/legal notices at top/bottom
      if (trimmed.toLowerCase().contains('please donate to nifty') ||
          trimmed.toLowerCase().contains(
            'support the platforms you read my stories on',
          ) ||
          trimmed.toLowerCase().contains(
            'to keep this free service available',
          )) {
        continue;
      }

      paragraphs.add(trimmed);
    }

    return paragraphs.isNotEmpty ? paragraphs.join('\n\n') : s.trim();
  }

  String _titleFromSlug(String slug) {
    var s = slug.replaceAll(RegExp(r'https?://[^/]+/'), '');
    if (s.endsWith('/')) s = s.substring(0, s.length - 1);
    if (s.contains('/')) s = s.substring(s.lastIndexOf('/') + 1);
    s = s.replaceAll(RegExp(r'\.(html|txt)$'), '');
    s = s.replaceAll(RegExp(r'[-_]+'), ' ').trim();
    if (s.isEmpty) return 'Nifty Story';

    // Title-case
    return s
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  String _formatChapterTitle(String raw, double chapterIndex) {
    var s = raw.replaceAll(RegExp(r'\.(html|txt)$'), '');
    s = s.replaceAll(RegExp(r'[-_]+'), ' ').trim();
    if (s.isEmpty) return 'Part ${chapterIndex.toInt()}';
    return s[0].toUpperCase() + s.substring(1);
  }

  int _naturalCompare(String a, String b) {
    final numA = _extractNumber(a);
    final numB = _extractNumber(b);
    if (numA != null && numB != null) {
      final cmp = numA.compareTo(numB);
      if (cmp != 0) return cmp;
    }
    return a.compareTo(b);
  }

  int? _extractNumber(String s) {
    final match = RegExp(r'(\d+)').allMatches(s).toList();
    if (match.isNotEmpty) {
      return int.tryParse(match.last.group(1)!);
    }
    return null;
  }
}
