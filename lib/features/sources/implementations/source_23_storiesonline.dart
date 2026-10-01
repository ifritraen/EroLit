import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class StoriesOnlineSource implements BaseStorySource {
  @override
  String get id => 'storiesonline';

  @override
  String get name => 'StoriesOnline';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://storiesonline.net';

  @override
  String? get iconUrl => 'https://storiesonline.net/favicon.png';

  static const Map<String, String> _defaultHeaders = {
    'Cookie': 'z=1',
  };

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final primaryUrl = page == 1
        ? '$baseUrl/library/new_stories.php'
        : '$baseUrl/library/new_stories.php?p=$page';

    try {
      final res = await ScraperClient.dio.get(
        primaryUrl,
        options: Options(headers: _defaultHeaders),
      );
      final items = _parseStoriesOnlineListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {
      // Proceed to secondary fallback feed
    }

    // Secondary fallback: Serial updates feed
    try {
      final updateUrl = page == 1
          ? '$baseUrl/library/updated_stories.php'
          : '$baseUrl/library/updated_stories.php?p=$page';
      final res = await ScraperClient.dio.get(
        updateUrl,
        options: Options(headers: _defaultHeaders),
      );
      final items = _parseStoriesOnlineListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {
      // Proceed to taxonomy fallback
    }

    // Tertiary fallback: Consensual tag archive
    return getCategoryStories('consensual', page: page);
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Science Fiction', slug: 'science-fiction', count: '3200+'),
      SourceCategory(name: 'High Fantasy', slug: 'high-fantasy', count: '900+'),
      SourceCategory(name: 'Romance', slug: 'romantic', count: '11700+'),
      SourceCategory(name: 'BDSM', slug: 'bdsm', count: '3000+'),
      SourceCategory(name: 'Incest', slug: 'incest', count: '8700+'),
      SourceCategory(name: 'Mind Control', slug: 'mind-control', count: '2600+'),
      SourceCategory(name: 'Consensual', slug: 'consensual', count: '32000+'),
      SourceCategory(name: 'Non-Consensual', slug: 'nonconsensual', count: '5400+'),
      SourceCategory(name: 'Reluctant', slug: 'reluctant', count: '7400+'),
      SourceCategory(name: 'Lesbian', slug: 'lesbian', count: '6000+'),
      SourceCategory(name: 'Bisexual', slug: 'bisexual', count: '6900+'),
      SourceCategory(name: 'Gay', slug: 'gay', count: '1700+'),
      SourceCategory(name: 'Heterosexual', slug: 'heterosexual', count: '24800+'),
      SourceCategory(name: 'Fiction', slug: 'fiction', count: '21900+'),
      SourceCategory(name: 'True Story', slug: 'true-story', count: '3900+'),
      SourceCategory(name: 'Horror', slug: 'horror', count: '1100+'),
      SourceCategory(name: 'Humor', slug: 'humor', count: '2900+'),
      SourceCategory(name: 'Crime', slug: 'crime', count: '990+'),
      SourceCategory(name: 'Military', slug: 'military', count: '1200+'),
      SourceCategory(name: 'Historical', slug: 'historical', count: '1500+'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/stories/bytag/$categorySlug'
        : '$baseUrl/stories/bytag/$categorySlug/$page';

    try {
      final res = await ScraperClient.dio.get(
        url,
        options: Options(headers: _defaultHeaders),
      );
      return _parseStoriesOnlineListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Ma/Fa', slug: 'ma-fa'),
      SourceTag(name: 'Fa/Fa', slug: 'fa-fa'),
      SourceTag(name: 'Ma/Ma', slug: 'ma-ma'),
      SourceTag(name: 'Multiple Partner', slug: 'mult'),
      SourceTag(name: 'Teenagers', slug: 'teenagers'),
      SourceTag(name: 'Coercion', slug: 'coercion'),
      SourceTag(name: 'Drunk/Drugged', slug: 'drunk-drugged'),
      SourceTag(name: 'Slavery', slug: 'slavery'),
      SourceTag(name: 'Blackmail', slug: 'blackmail'),
      SourceTag(name: 'Transgender', slug: 'transgender'),
      SourceTag(name: 'Hypnosis', slug: 'hypnosis'),
      SourceTag(name: 'Crossdressing', slug: 'crossdressing'),
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
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];

    final encoded = Uri.encodeComponent(trimmedQuery);

    // Layer 1: Direct Advanced Search endpoint
    try {
      final searchUrl =
          '$baseUrl/library/search.php?cmd=StartSearch&token=dcf6b4e5&title=$encoded&p=$page';
      final res = await ScraperClient.dio.get(
        searchUrl,
        options: Options(headers: _defaultHeaders),
      );
      final items = _parseStoriesOnlineListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {
      // Proceed to Layer 2 fallback
    }

    // Layer 2: Tag & Genre taxonomy matching
    try {
      final tagSlug = trimmedQuery
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          .replaceAll(RegExp(r'^-+|-+$'), '');
      if (tagSlug.isNotEmpty) {
        final tagStories = await getCategoryStories(tagSlug, page: page);
        if (tagStories.isNotEmpty) return tagStories;
      }
    } catch (_) {
      // Proceed to Layer 3 fallback
    }

    return [];
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final cleanUrl = url.startsWith('http') ? url : '$baseUrl/$url';

    try {
      final res = await ScraperClient.dio.get(
        cleanUrl,
        options: Options(headers: _defaultHeaders),
      );
      final doc = html_parser.parse(res.data.toString());

      // 1. Title Extraction & Cleanup
      final titleEl = doc.querySelector('h1#ptitle') ??
          doc.querySelector('article h1') ??
          doc.querySelector('h1') ??
          doc.querySelector('title');

      var title = titleEl?.text.trim() ?? 'StoriesOnline Story';
      title = title
          .replaceAll(RegExp(r'\s+by\s+.*$', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*-\s*Storiesonline.*$', caseSensitive: false), '')
          .replaceAll(
            RegExp(r'^(Sex Stories|Science Fiction Story|Incest Sex Story|Fantasy Sex Story):\s*',
                caseSensitive: false),
            '',
          )
          .trim();

      if (title.isEmpty) title = 'StoriesOnline Story';

      // 2. Author Extraction
      final authorEl = doc.querySelector('a[href*="/a/"]');
      final author = authorEl?.text.trim();

      // 3. Chapters Extraction
      final chapterLinks = doc.querySelectorAll('span.link a');
      final chapters = <SourceChapter>[];
      final seenUrls = <String>{};

      for (var i = 0; i < chapterLinks.length; i++) {
        final el = chapterLinks[i];
        final chTitle = el.text.trim();
        var chUrl = el.attributes['href'] ?? '';
        if (chUrl.isEmpty) continue;
        if (!chUrl.startsWith('http')) {
          chUrl = '$baseUrl$chUrl';
        }

        if (seenUrls.contains(chUrl)) continue;
        seenUrls.add(chUrl);

        final match = RegExp(r'/(\d+)$').firstMatch(chUrl);
        final chIndex = match != null
            ? double.tryParse(match.group(1)!) ?? (i + 1).toDouble()
            : (i + 1).toDouble();

        chapters.add(
          SourceChapter(
            index: chIndex,
            title: chTitle.isNotEmpty ? chTitle : 'Chapter ${i + 1}',
            url: chUrl,
          ),
        );
      }

      // If no chapter pagination exists, story is a single-chapter work
      if (chapters.isEmpty) {
        chapters.add(
          SourceChapter(
            index: 1.0,
            title: title,
            url: cleanUrl,
          ),
        );
      }

      // 4. Description Extraction
      String? description;
      final articleEl = doc.querySelector('article');
      if (articleEl != null) {
        for (final p in articleEl.querySelectorAll('p')) {
          final text = p.text.trim();
          if (text.length > 40 &&
              !text.startsWith('Tags:') &&
              !text.startsWith('Caution:') &&
              !text.startsWith('Show Story Details') &&
              !text.startsWith('Log In')) {
            description = text;
            break;
          }
        }
      }

      description ??= doc.querySelector('.sdesc')?.text.trim();

      // 5. Genres / Tags
      final genres = <String>[];
      for (final a in doc.querySelectorAll('a[href*="/stories/bytag/"]')) {
        final t = a.text.trim();
        if (t.isNotEmpty && !genres.contains(t) && t != 'Show All Tags') {
          genres.add(t);
        }
      }

      return SourceNovelDetails(
        title: title,
        url: cleanUrl,
        author: author,
        description: description,
        genres: genres,
        status: chapters.length > 1 ? 'Ongoing' : 'Completed',
        chapters: chapters,
      );
    } catch (_) {
      // Fallback details if network or parsing fails
      final fallbackTitle = url.split('/').where((s) => s.isNotEmpty).last;
      return SourceNovelDetails(
        title: fallbackTitle,
        url: cleanUrl,
        status: 'Completed',
        chapters: [
          SourceChapter(
            index: 1.0,
            title: fallbackTitle,
            url: cleanUrl,
          ),
        ],
      );
    }
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final cleanUrl = chapterUrl.startsWith('http') ? chapterUrl : '$baseUrl/$chapterUrl';

    try {
      final res = await ScraperClient.dio.get(
        cleanUrl,
        options: Options(headers: _defaultHeaders),
      );
      final doc = html_parser.parse(res.data.toString());

      final contentEl = doc.querySelector('article') ??
          doc.querySelector('div#story') ??
          doc.querySelector('div.story') ??
          doc.body;

      if (contentEl == null) return 'Content could not be loaded.';

      // Strip UI chrome, rating widgets, script tags, and paywall markers
      for (final el in contentEl.querySelectorAll(
        'script, style, header, footer, nav, noscript, form, '
        '.vform, .vote-form, #s-details, #voteStatusDiv, #foDiv, '
        '.invis, .notice, .fadeout, .sep, .vh, '
        'a[href*="login.php"], a[href*="tempAccess.php"], a[href*="moreData.php"]',
      )) {
        el.remove();
      }

      final paragraphs = <String>[];
      for (final p in contentEl.querySelectorAll('p')) {
        final text = p.text.trim();
        if (text.length > 5 &&
            !text.startsWith('Show Story Details') &&
            !text.startsWith('Log In') &&
            !text.startsWith('To read the complete story')) {
          paragraphs.add(text);
        }
      }

      if (paragraphs.isEmpty) {
        final fallbackText = contentEl.text.trim();
        return fallbackText.isNotEmpty ? fallbackText : 'Content is empty.';
      }

      return paragraphs.join('\n\n');
    } catch (e) {
      return 'Unable to load chapter content from StoriesOnline at this time ($e).';
    }
  }

  List<SourceListingItem> _parseStoriesOnlineListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];
    final entries = doc.querySelectorAll('.entry');

    for (final e in entries) {
      final h3 = e.querySelector('h3.sname') ?? e.querySelector('h3');
      if (h3 == null) continue;

      // Extract story link
      var storyA = h3.querySelector('a[href*="/s/"]') ?? h3.querySelector('a[href*="/n/"]');
      storyA ??= e.querySelector('a[href*="/s/"]') ?? e.querySelector('a[href*="/n/"]');
      if (storyA == null) continue;

      final title = storyA.text.trim();
      var href = storyA.attributes['href'] ?? '';
      if (title.isEmpty || href.isEmpty) continue;

      if (!href.startsWith('http')) {
        href = '$baseUrl$href';
      }

      // Extract author
      final authorA = h3.querySelector('a[href*="/a/"]') ?? e.querySelector('a[href*="/a/"]');
      final author = authorA?.text.trim();

      // Extract summary
      final sdesc = e.querySelector('.sdesc');
      final summary = sdesc?.text.trim();

      // Extract date
      final noscript = e.querySelector('.misc noscript');
      final date = noscript?.text.trim();

      items.add(
        SourceListingItem(
          title: title,
          url: href,
          author: author,
          summary: summary,
          date: date,
          sourceId: id,
        ),
      );
    }

    return items;
  }
}
