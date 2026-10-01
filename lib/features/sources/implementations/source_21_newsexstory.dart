import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class NewSexStorySource implements BaseStorySource {
  @override
  String get id => 'newsexstory';

  @override
  String get name => 'New Sex Story';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://newsexstory.com';

  @override
  String? get iconUrl =>
      'https://newsexstory.com/wp-content/uploads/2020/07/cropped-favicon-32x32.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Seed directly to Bengali stories category
    return getCategoryStories('bengali-sex-stories', page: page);
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Bengali Sex Stories', slug: 'bengali-sex-stories', count: '1210'),
      SourceCategory(name: 'Animal Stories', slug: 'animal-stories', count: '312'),
      SourceCategory(name: 'Anal Stories', slug: 'anal-stories', count: '97'),
      SourceCategory(name: 'Bisexual Stories', slug: 'bisexual-stories', count: '96'),
      SourceCategory(name: 'BDSM Stories', slug: 'bdsm-stories', count: '93'),
      SourceCategory(name: 'Bondage Stories', slug: 'bondage-stories', count: '41'),
      SourceCategory(name: 'Alien Stories', slug: 'alien-stories', count: '37'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/$categorySlug/'
        : '$baseUrl/$categorySlug/page/$page/';
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
      SourceTag(name: 'Bengali Stories', slug: 'bengali-sex-stories'),
      SourceTag(name: 'Anal', slug: 'anal-stories'),
      SourceTag(name: 'BDSM', slug: 'bdsm-stories'),
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
        ? '$baseUrl/?s=$encoded'
        : '$baseUrl/page/$page/?s=$encoded';
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
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final titleEl = doc.querySelector('h1.entry-title') ?? doc.querySelector('h1');
    final title = titleEl?.text.trim() ?? 'Sex Story';

    final authorEl = doc.querySelector('.author a') ?? doc.querySelector('.byline a');
    final author = authorEl?.text.trim();

    final coverEl = doc.querySelector('.wp-post-image') ??
        doc.querySelector('.entry-content img');
    final coverUrl = coverEl?.attributes['src'] ?? coverEl?.attributes['data-src'];

    final genres = <String>[];
    for (final catLink in doc.querySelectorAll('a[href*="/category/"]')) {
      final name = catLink.text.trim();
      if (name.isNotEmpty && !genres.contains(name)) {
        genres.add(name);
      }
    }

    final descEl = doc.querySelector('.entry-summary p') ??
        doc.querySelector('.entry-content p');
    final description = descEl?.text.trim();

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
      coverUrl: coverUrl,
      description: description,
      status: 'Completed',
      genres: genres,
      chapters: [
        SourceChapter(
          index: 1.0,
          title: title,
          url: url,
          releaseDate: doc.querySelector('time.entry-date')?.text.trim(),
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final res = await ScraperClient.dio.get(chapterUrl);
    final doc = html_parser.parse(res.data.toString());

    final contentEl = doc.querySelector('.entry-content') ?? doc.querySelector('article');
    if (contentEl == null) return 'Content could not be loaded.';

    for (final el in contentEl.querySelectorAll(
      'script, style, iframe, .code-block, .sharedaddy, .adsbygoogle, ins',
    )) {
      el.remove();
    }

    final paragraphs = <String>[];
    for (final node in contentEl.querySelectorAll('p, blockquote')) {
      final text = node.text.trim();
      if (text.isNotEmpty) {
        paragraphs.add(text);
      }
    }

    if (paragraphs.isEmpty) {
      final text = contentEl.text.trim();
      return text.isNotEmpty ? text : 'Content is empty.';
    }

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];

    final articles = doc.querySelectorAll('article[class*="post-"], article.post');
    for (final art in articles) {
      final titleEl = art.querySelector('h2.entry-title a') ?? art.querySelector('h2 a');
      if (titleEl == null) continue;

      final title = titleEl.text.trim();
      final url = titleEl.attributes['href'] ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      final dateEl = art.querySelector('time.entry-date') ?? art.querySelector('.posted-on');
      final summaryEl = art.querySelector('.entry-summary p') ?? art.querySelector('.entry-content p');

      items.add(
        SourceListingItem(
          title: title,
          url: url,
          sourceId: id,
          date: dateEl?.text.trim(),
          summary: summaryEl?.text.trim(),
        ),
      );
    }
    return items;
  }
}
