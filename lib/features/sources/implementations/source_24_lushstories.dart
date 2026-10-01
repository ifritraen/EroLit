import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class LushStoriesSource implements BaseStorySource {
  @override
  String get id => 'lushstories';

  @override
  String get name => 'Lush Stories';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://www.lushstories.com';

  @override
  String? get iconUrl => 'https://www.lushstories.com/favicon.ico';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Tier 1: Standard stories feed
    try {
      final url = page == 1 ? '$baseUrl/stories' : '$baseUrl/stories?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseLushListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 2: API stories fallback
    try {
      final apiUrl = '$baseUrl/api/stories?page=$page';
      final res = await ScraperClient.dio.get(apiUrl);
      final items = _parseJsonListings(res.data);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 3: Home page listings fallback
    if (page == 1) {
      try {
        final res = await ScraperClient.dio.get('$baseUrl/');
        final items = _parseLushListings(res.data.toString());
        if (items.isNotEmpty) return items;
      } catch (_) {}
    }

    return [];
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Anal', slug: 'anal'),
      SourceCategory(name: 'Audio', slug: 'audio'),
      SourceCategory(name: 'BDSM', slug: 'bdsm'),
      SourceCategory(name: 'Bisexual', slug: 'bisexual'),
      SourceCategory(name: 'Cheating', slug: 'cheating'),
      SourceCategory(name: 'College Sex', slug: 'college-sex'),
      SourceCategory(name: 'Cross-dressing', slug: 'cross-dressing'),
      SourceCategory(name: 'Cuckold', slug: 'cuckold'),
      SourceCategory(name: 'Erotic Poems', slug: 'erotic-poems'),
      SourceCategory(name: 'Exhibitionism', slug: 'exhibitionism'),
      SourceCategory(name: 'Facesitting', slug: 'facesitting'),
      SourceCategory(name: 'Fantasy & Sci-Fi', slug: 'fantasy-sci-fi'),
      SourceCategory(name: 'Femdom', slug: 'femdom'),
      SourceCategory(name: 'Fetish', slug: 'fetish'),
      SourceCategory(name: 'First Time', slug: 'first-time'),
      SourceCategory(name: 'Flash Erotica', slug: 'flash-erotica'),
      SourceCategory(name: 'Gay Male', slug: 'gay-male'),
      SourceCategory(name: 'Group Sex', slug: 'group-sex'),
      SourceCategory(name: 'Hardcore', slug: 'hardcore'),
      SourceCategory(name: 'Historical', slug: 'historical'),
      SourceCategory(name: 'Horror', slug: 'horror'),
      SourceCategory(name: 'Humor', slug: 'humor'),
      SourceCategory(name: 'Incest Fantasy', slug: 'incest-fantasy'),
      SourceCategory(name: 'Interracial', slug: 'interracial'),
      SourceCategory(name: 'Lesbian', slug: 'lesbian'),
      SourceCategory(name: 'Love Poems', slug: 'love-poems'),
      SourceCategory(name: 'Love Stories', slug: 'love-stories'),
      SourceCategory(name: 'Masturbation', slug: 'masturbation'),
      SourceCategory(name: 'Mature', slug: 'mature'),
      SourceCategory(name: 'Medical', slug: 'medical'),
      SourceCategory(name: 'Microfiction', slug: 'microfiction'),
      SourceCategory(name: 'MILF', slug: 'milf'),
      SourceCategory(name: 'Mind Control', slug: 'mind-control'),
      SourceCategory(name: 'Money', slug: 'money'),
      SourceCategory(name: 'Monster Sex', slug: 'monster-sex'),
      SourceCategory(name: 'Novels', slug: 'novels'),
      SourceCategory(name: 'Occupations', slug: 'occupations'),
      SourceCategory(name: 'Office Sex', slug: 'office-sex'),
      SourceCategory(name: 'Oral Sex', slug: 'oral-sex'),
      SourceCategory(name: 'Outdoor', slug: 'outdoor'),
      SourceCategory(name: 'Quickie Sex', slug: 'quickie-sex'),
      SourceCategory(name: 'Reluctance', slug: 'reluctance'),
      SourceCategory(name: 'Seduction', slug: 'seduction'),
      SourceCategory(name: 'Spanking', slug: 'spanking'),
      SourceCategory(name: 'Steampunk', slug: 'steampunk'),
      SourceCategory(name: 'Straight Sex', slug: 'straight-sex'),
      SourceCategory(name: 'Strap-On Sex', slug: 'strap-on-sex'),
      SourceCategory(name: 'Supernatural', slug: 'supernatural'),
      SourceCategory(name: 'Swingers', slug: 'swingers'),
      SourceCategory(name: 'Taboo', slug: 'taboo'),
      SourceCategory(name: 'Teen', slug: 'teen'),
      SourceCategory(name: 'Threesomes', slug: 'threesomes'),
      SourceCategory(name: 'Toys', slug: 'toys'),
      SourceCategory(name: 'Trans', slug: 'trans'),
      SourceCategory(name: 'True', slug: 'true'),
      SourceCategory(name: 'Uniform', slug: 'uniform'),
      SourceCategory(name: 'Voyeur', slug: 'voyeur'),
      SourceCategory(name: 'Watersports', slug: 'watersports'),
      SourceCategory(name: 'Wife Lovers', slug: 'wife-lovers'),
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
        .replaceFirst('stories/', '');

    // Tier 1: Direct Category Route
    try {
      final url = page == 1
          ? '$baseUrl/stories/$cleanSlug'
          : '$baseUrl/stories/$cleanSlug?page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseLushListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 2: Search Fallback by category term
    try {
      final searchItems = await search(cleanSlug.replaceAll('-', ' '), page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Seduction', slug: 'seduction'),
      SourceTag(name: 'Cheating', slug: 'cheating'),
      SourceTag(name: 'Wife Lovers', slug: 'wife lovers'),
      SourceTag(name: 'Wife Sharing', slug: 'wife sharing'),
      SourceTag(name: 'Cuckold', slug: 'cuckold'),
      SourceTag(name: 'Femdom', slug: 'femdom'),
      SourceTag(name: 'MILF', slug: 'milf'),
      SourceTag(name: 'Oral Sex', slug: 'oral sex'),
      SourceTag(name: 'Anal', slug: 'anal'),
      SourceTag(name: 'BDSM', slug: 'bdsm'),
      SourceTag(name: 'Big Cock', slug: 'big cock'),
      SourceTag(name: 'Creampie', slug: 'creampie'),
      SourceTag(name: 'Group Sex', slug: 'group sex'),
      SourceTag(name: 'Threesome', slug: 'threesome'),
      SourceTag(name: 'Hotwife', slug: 'hotwife'),
      SourceTag(name: 'Masturbation', slug: 'masturbation'),
      SourceTag(name: 'First Time', slug: 'first time'),
      SourceTag(name: 'Taboo Sex', slug: 'taboo sex'),
      SourceTag(name: 'Outdoor Sex', slug: 'outdoor sex'),
      SourceTag(name: 'Mind Control', slug: 'mind control'),
      SourceTag(name: 'Cock Sucking', slug: 'cock sucking'),
      SourceTag(name: 'Double Penetration', slug: 'double penetration'),
      SourceTag(name: 'Exhibitionist', slug: 'exhibitionist'),
      SourceTag(name: 'Face Fucking', slug: 'face fucking'),
      SourceTag(name: 'Finger-Fucking', slug: 'finger-fucking'),
      SourceTag(name: 'Humiliation', slug: 'humiliation'),
      SourceTag(name: 'Mutual Seduction', slug: 'mutual seduction'),
      SourceTag(name: 'Romantic Sex', slug: 'romantic sex'),
      SourceTag(name: 'Rough', slug: 'rough'),
      SourceTag(name: 'Sex Slave', slug: 'sex slave'),
      SourceTag(name: 'Shower Sex', slug: 'shower sex'),
      SourceTag(name: 'Strap On', slug: 'strap on'),
      SourceTag(name: 'Submissive Husband', slug: 'submissive husband'),
      SourceTag(name: 'Swingers', slug: 'swingers'),
      SourceTag(name: 'Titfuck', slug: 'titfuck'),
      SourceTag(name: 'Voyeur', slug: 'voyeur'),
      SourceTag(name: 'Wet Sex', slug: 'wet sex'),
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
        .replaceFirst('tag=', '');

    // Tier 1: Tag query route
    try {
      final encoded = Uri.encodeComponent(cleanSlug);
      final url = page == 1
          ? '$baseUrl/stories?tag=$encoded'
          : '$baseUrl/stories?tag=$encoded&page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseLushListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 2: Search Fallback
    try {
      final searchItems = await search(cleanSlug, page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    final encoded = Uri.encodeComponent(trimmed);

    // Tier 1: HTML Search query on /stories?search=...
    try {
      final url = page == 1
          ? '$baseUrl/stories?search=$encoded'
          : '$baseUrl/stories?search=$encoded&page=$page';
      final res = await ScraperClient.dio.get(url);
      final items = _parseLushListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 2: REST API search on /api/stories?q=...
    try {
      final apiUrl = '$baseUrl/api/stories?q=$encoded&page=$page';
      final res = await ScraperClient.dio.get(apiUrl);
      final items = _parseJsonListings(res.data);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // Tier 3: Tag match fallback
    try {
      final tagUrl = page == 1
          ? '$baseUrl/stories?tag=$encoded'
          : '$baseUrl/stories?tag=$encoded&page=$page';
      final res = await ScraperClient.dio.get(tagUrl);
      final items = _parseLushListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return [];
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = _normalizeUrl(url);

    try {
      final res = await ScraperClient.dio.get(cleanUrl);
      final doc = html_parser.parse(res.data.toString());

      final h1El = doc.querySelector('h1') ?? doc.querySelector('title');
      var title = h1El?.text.trim() ?? 'Lush Story';
      title = title.replaceAll(RegExp(r'\s*-\s*Lush Stories.*', caseSensitive: false), '').trim();
      title = title.replaceAll(RegExp(r'\s*\|\s*Lush Stories.*', caseSensitive: false), '').trim();

      // Author extraction
      String? author;
      for (final a in doc.querySelectorAll('a[href*="/profile/"]')) {
        final t = a.text.trim();
        if (t.isNotEmpty) {
          author = t.replaceFirst(RegExp(r'^(Written by|by)\s*', caseSensitive: false), '').trim();
          break;
        }
      }

      // Cover image extraction
      final ogImg = doc.querySelector('meta[property="og:image"]')?.attributes['content'];
      final coverImg = doc.querySelector('.story-cover img')?.attributes['src'] ??
          doc.querySelector('header img')?.attributes['src'];
      final coverUrl = ogImg ?? coverImg;

      // Synopsis extraction
      final ogDesc = doc.querySelector('meta[property="og:description"]')?.attributes['content'];
      final metaDesc = doc.querySelector('meta[name="description"]')?.attributes['content'];
      final subtitle = doc.querySelector('em')?.text.trim();
      final description = ogDesc ?? metaDesc ?? subtitle;

      // Genre tags
      final genres = <String>{};
      for (final a in doc.querySelectorAll('a[href*="/stories/"], a[href*="tag="]')) {
        final t = a.text.trim();
        if (t.isNotEmpty &&
            t != 'Sign up today' &&
            t != 'Write Your Own Story' &&
            !t.toLowerCase().contains('lush') &&
            t.length < 35) {
          genres.add(t);
        }
      }

      return SourceNovelDetails(
        title: title.isNotEmpty ? title : 'Lush Story',
        url: cleanUrl,
        author: author,
        coverUrl: coverUrl,
        description: description,
        status: 'Completed',
        genres: genres.toList(),
        chapters: [
          SourceChapter(
            index: 1.0,
            title: title.isNotEmpty ? title : 'Chapter 1',
            url: cleanUrl,
          ),
        ],
      );
    } catch (_) {
      // Graceful fallback from URL slug
      final slug = cleanUrl.split('/').where((s) => s.isNotEmpty).last;
      final titleFromSlug = slug
          .replaceAll('-', ' ')
          .split(' ')
          .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
          .join(' ');

      return SourceNovelDetails(
        title: titleFromSlug.isNotEmpty ? titleFromSlug : 'Lush Story',
        url: cleanUrl,
        status: 'Completed',
        chapters: [
          SourceChapter(
            index: 1.0,
            title: titleFromSlug.isNotEmpty ? titleFromSlug : 'Chapter 1',
            url: cleanUrl,
          ),
        ],
      );
    }
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = _normalizeUrl(chapterUrl);

    try {
      final res = await ScraperClient.dio.get(cleanUrl);
      final doc = html_parser.parse(res.data.toString());

      // Target semantic story body container
      final contentEl = doc.querySelector('div.story-body') ??
          doc.querySelector('div.story-text') ??
          doc.querySelector('div[class*="story-body"]') ??
          doc.querySelector('div[class*="story-text"]') ??
          doc.querySelector('article');

      if (contentEl != null) {
        // Strip non-content UI nodes
        for (final el in contentEl.querySelectorAll(
          'script, style, iframe, svg, button, nav, form, .ad, .banner, [class*="advert"]',
        )) {
          el.remove();
        }

        final paragraphs = <String>[];
        for (final node in contentEl.querySelectorAll('p')) {
          final text = node.text.trim();
          if (text.isNotEmpty &&
              !text.startsWith('Sign up') &&
              !text.startsWith('Write Your Own') &&
              text != 'Login' &&
              text != 'Register') {
            paragraphs.add(text);
          }
        }

        if (paragraphs.isNotEmpty) {
          return paragraphs.join('\n\n');
        }

        final plainText = contentEl.text.trim();
        if (plainText.isNotEmpty) {
          return plainText;
        }
      }

      // Check if URL points to numeric ID for API fallback
      final idMatch = RegExp(r'/stories/(\d+)').firstMatch(cleanUrl);
      if (idMatch != null) {
        final storyId = idMatch.group(1);
        final apiRes = await ScraperClient.dio.get('$baseUrl/api/stories/$storyId');
        if (apiRes.data is Map && apiRes.data['body'] != null) {
          final bodyHtml = apiRes.data['body'].toString();
          final apiDoc = html_parser.parse(bodyHtml);
          final paras = apiDoc.querySelectorAll('p').map((p) => p.text.trim()).where((t) => t.isNotEmpty).toList();
          if (paras.isNotEmpty) {
            return paras.join('\n\n');
          }
        }
      }
    } catch (_) {}

    return 'Story content could not be loaded at this time. Please check your network connection or verify the story online.';
  }

  List<SourceListingItem> _parseLushListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final seenUrls = <String>{};

    // Find all story link anchors matching /stories/{category}/{slug}
    final storyLinks = doc.querySelectorAll('a[href*="/stories/"]');

    for (final a in storyLinks) {
      final href = a.attributes['href'] ?? '';
      // Pattern: /stories/{category}/{slug}
      if (!RegExp(r'^/stories/[a-z0-9-]+/[a-z0-9-]+$').hasMatch(href)) {
        continue;
      }

      final fullUrl = href.startsWith('http') ? href : '$baseUrl$href';
      if (seenUrls.contains(fullUrl)) continue;

      // Extract title from h2 or h3 or inner text
      final h2 = a.querySelector('h2') ?? a.querySelector('h3');
      var title = h2?.text.trim() ?? '';
      if (title.isEmpty) {
        final directText = a.text.trim();
        if (directText.length > 3 && !directText.startsWith('Sign up')) {
          title = directText;
        }
      }
      if (title.isEmpty) continue;

      seenUrls.add(fullUrl);

      // Card container inspection for author, date, cover, summary
      dom.Element? parent = a.parent;
      String? author;
      String? date;
      String? summary;
      String? coverUrl;

      while (parent != null) {
        final parentClasses = parent.className;
        if (parentClasses.contains('flex-col') ||
            parentClasses.contains('card') ||
            parent.localName == 'article') {
          // Author
          for (final profileA in parent.querySelectorAll('a[href*="/profile/"]')) {
            final t = profileA.text.trim();
            if (t.isNotEmpty) {
              author = t.replaceFirst(RegExp(r'^(Written by|by)\s*', caseSensitive: false), '').trim();
              break;
            }
          }

          // Date
          final timeEl = parent.querySelector('time');
          if (timeEl != null) {
            date = timeEl.text.trim();
          }

          // Summary
          final pEl = parent.querySelector('p');
          if (pEl != null) {
            final pText = pEl.text.trim();
            if (pText.isNotEmpty) {
              summary = pText;
            }
          }

          // Cover thumbnail
          final imgEl = parent.querySelector('img');
          if (imgEl != null) {
            final src = imgEl.attributes['src'];
            if (src != null && !src.contains('lush-logo') && !src.contains('coin-lush')) {
              coverUrl = src;
            }
          }
          break;
        }
        parent = parent.parent;
      }

      // Fallback summary from em tag
      if (summary == null || summary.isEmpty) {
        final em = a.querySelector('em');
        if (em != null) {
          summary = em.text.trim();
        }
      }

      items.add(
        SourceListingItem(
          title: title,
          url: fullUrl,
          author: author,
          date: date,
          summary: summary,
          coverUrl: coverUrl,
          sourceId: id,
        ),
      );
    }

    return items;
  }

  List<SourceListingItem> _parseJsonListings(dynamic data) {
    final items = <SourceListingItem>[];
    if (data is! Map || data['items'] is! List) return items;

    final list = data['items'] as List;
    for (final raw in list) {
      if (raw is! Map) continue;
      final idNum = raw['id'];
      final title = raw['title']?.toString().trim() ?? '';
      if (title.isEmpty || idNum == null) continue;

      final body = raw['body']?.toString() ?? '';
      final cleanSummary = body.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
      final date = raw['created']?.toString();
      final genre = raw['genre']?.toString();

      items.add(
        SourceListingItem(
          title: title,
          url: '$baseUrl/stories/$idNum',
          author: null,
          date: date,
          summary: cleanSummary.isNotEmpty ? cleanSummary : genre,
          coverUrl: null,
          sourceId: id,
        ),
      );
    }

    return items;
  }

  String _normalizeUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    final path = url.startsWith('/') ? url : '/$url';
    return '$baseUrl$path';
  }
}
