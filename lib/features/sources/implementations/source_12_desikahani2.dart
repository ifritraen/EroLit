import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class DesiKahani2Source implements BaseStorySource {
  @override
  String get id => 'desikahani2';

  @override
  String get name => 'Desi Kahani 2';

  @override
  String get lang => 'hi';

  @override
  String get baseUrl => 'https://www.desikahani2.net';

  @override
  String? get iconUrl =>
      'https://www.desikahani2.net/wp-content/uploads/2014/12/cropped-Favicon-192x192.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Fast REST API primary query
    try {
      final apiUrl =
          '$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=100&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return _parseApiPosts(res.data as List);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        return [];
      }
    } catch (_) {}

    // HTML fallback
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
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
      SourceCategory(name: 'Desi Chudai', slug: 'desi-chudai', count: '3369'),
      SourceCategory(name: 'Parivar Me Chudai', slug: 'parivar-me-chudai', count: '2294'),
      SourceCategory(name: 'Meri Chudai', slug: 'meri-chudai', count: '1841'),
      SourceCategory(name: 'Behan Ki Chudai', slug: 'behan-ki-chudai', count: '1819'),
      SourceCategory(name: 'Bhabhi Ki Chudai', slug: 'bhabhi-ki-chudai', count: '1582'),
      SourceCategory(name: 'Group Sex', slug: 'group-sex', count: '1139'),
      SourceCategory(name: 'Hindi Chudai Kahani', slug: 'hindi-chudai-kahani', count: '1070'),
      SourceCategory(name: 'Maa Beta', slug: 'maa-beta', count: '979'),
      SourceCategory(name: 'Pehli Chudai', slug: 'pehli-chudai', count: '748'),
      SourceCategory(name: 'Tamil Kamakathaikal', slug: 'tamil-kamakathaikal', count: '655'),
      SourceCategory(name: 'Gay Chudai', slug: 'gay-chudai', count: '408'),
      SourceCategory(name: 'Teacher Student Chudai', slug: 'teacher-student-chudai', count: '383'),
      SourceCategory(name: 'Naukar-Naukrani', slug: 'naukar-naukrani', count: '353'),
      SourceCategory(name: 'Other Languages', slug: 'other-languages', count: '334'),
      SourceCategory(name: 'Office Sex', slug: 'office-sex', count: '322'),
      SourceCategory(name: 'Baap Beti', slug: 'baap-beti', count: '292'),
      SourceCategory(name: 'Top Collection', slug: 'top-collection', count: '282'),
      SourceCategory(name: 'Lesbian Sex', slug: 'lesbian-sex', count: '270'),
      SourceCategory(name: 'Malayalam Kambi Kathakal', slug: 'malayalam-kambi-kathakal', count: '1'),
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
      SourceTag(name: 'Chudai', slug: 'chudai'),
      SourceTag(name: 'Chudakkad', slug: 'chudakkad'),
      SourceTag(name: 'Bhai', slug: 'bhai'),
      SourceTag(name: 'Bhabhi', slug: 'bhabhi'),
      SourceTag(name: 'Incest', slug: 'incest'),
      SourceTag(name: 'Maa', slug: 'maa'),
      SourceTag(name: 'Affair', slug: 'affair'),
      SourceTag(name: 'Stranger', slug: 'stranger'),
      SourceTag(name: 'Hardcore', slug: 'hardcore'),
      SourceTag(name: 'House Wife', slug: 'house-wife'),
      SourceTag(name: 'Padosan', slug: 'padosan'),
      SourceTag(name: 'Girlfriend', slug: 'girlfriend'),
      SourceTag(name: 'Beta', slug: 'beta'),
      SourceTag(name: 'Randi', slug: 'randi'),
      SourceTag(name: 'First Time', slug: 'first-time'),
      SourceTag(name: 'Behan', slug: 'behan'),
      SourceTag(name: 'Home Sex', slug: 'home-sex'),
      SourceTag(name: 'Virgin', slug: 'virgin'),
      SourceTag(name: 'Threesome', slug: 'threesome'),
      SourceTag(name: 'Behen', slug: 'behen'),
      SourceTag(name: 'Aunty', slug: 'aunty'),
      SourceTag(name: 'Friend', slug: 'friend'),
      SourceTag(name: 'Gaand', slug: 'gaand'),
      SourceTag(name: 'Seduce', slug: 'seduce'),
      SourceTag(name: 'Desi Girl', slug: 'desi-girl'),
      SourceTag(name: 'Teacher', slug: 'teacher'),
      SourceTag(name: 'Mummy', slug: 'mummy'),
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
    // REST API search primary
    try {
      final apiUrl =
          '$baseUrl/wp-json/wp/v2/posts?search=${Uri.encodeComponent(query)}&page=$page&per_page=100&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return _parseApiPosts(res.data as List);
      }
    } catch (_) {}

    // HTML search fallback
    final url = page == 1
        ? '$baseUrl/?s=${Uri.encodeComponent(query)}'
        : '$baseUrl/page/$page/?s=${Uri.encodeComponent(query)}';
    try {
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

    final title =
        doc.querySelector('h1.entry-title, h1')?.text.trim() ?? 'Desi Kahani';
    final author =
        doc.querySelector('.author a, .entry-author a, .byline a')?.text.trim();
    final cover = doc
        .querySelector(
          '.featured-image img, .post-image img, .entry-content img',
        )
        ?.attributes['src'];

    final genres = <String>{};
    for (final el in doc.querySelectorAll('.cat-links a, .tags-links a')) {
      final name = el.text.trim();
      if (name.isNotEmpty) {
        genres.add(name);
      }
    }

    final description = doc
            .querySelector('meta[name="description"]')
            ?.attributes['content']
            ?.trim() ??
        doc.querySelector('.entry-content p')?.text.trim();

    return SourceNovelDetails(
      title: title,
      url: url,
      author: author,
      coverUrl: cover,
      description: description,
      status: 'Completed',
      genres: genres.toList(),
      chapters: [
        SourceChapter(
          index: 1.0,
          title: 'Full Story',
          url: url,
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

    // Strip ad iframes, banners, scripts, styles, and social widgets
    contentEl
        .querySelectorAll(
          'iframe, script, style, noscript, .adsbygoogle, [class*="ad-"], [id*="ad-"], [id^="zone-"], .sharedaddy, .sd-sharing, .sd-content, .post-navigation, nav',
        )
        .forEach((el) => el.remove());

    final paragraphs = contentEl
        .querySelectorAll('p')
        .map((p) => p.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (paragraphs.isNotEmpty) {
      return paragraphs.join('\n\n');
    }

    return contentEl.text.trim();
  }

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final articles = doc.querySelectorAll('article.post, article[id^="post-"]');
    final List<SourceListingItem> result = [];

    for (final article in articles) {
      final titleEl = article.querySelector(
        'h2.entry-title a, h1.entry-title a, .entry-title a',
      );
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final author = article
          .querySelector('.author a, .entry-author a, .byline a')
          ?.text
          .trim();
      final date = article
          .querySelector('time.entry-date, time.published, time')
          ?.text
          .trim();
      final summary = article
          .querySelector(
            '.entry-summary p, .entry-summary, .entry-content p, .entry-content',
          )
          ?.text
          .trim();
      final cover = article
          .querySelector('.post-image img, .featured-image img, img')
          ?.attributes['src'];

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            author: author,
            date: date,
            summary: summary,
            coverUrl: cover,
            sourceId: id,
          ),
        );
      }
    }

    return result;
  }

  List<SourceListingItem> _parseApiPosts(List posts) {
    final List<SourceListingItem> result = [];
    for (final post in posts) {
      if (post is! Map) continue;
      final rawTitle = post['title']?['rendered']?.toString() ?? '';
      final title = html_parser.parse(rawTitle).body?.text.trim() ?? '';
      final url = post['link']?.toString() ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      String? author;
      try {
        author = post['_embedded']?['author']?[0]?['name']?.toString();
      } catch (_) {}

      final date = post['date']?.toString();

      String? summary;
      try {
        final rawExcerpt = post['excerpt']?['rendered']?.toString() ?? '';
        summary = html_parser.parse(rawExcerpt).body?.text.trim();
      } catch (_) {}

      String? cover;
      try {
        cover = post['_embedded']?['wp:featuredmedia']?[0]?['source_url']
            ?.toString();
      } catch (_) {}

      result.add(
        SourceListingItem(
          title: title,
          url: url,
          author: author,
          date: date,
          summary: summary,
          coverUrl: cover,
          sourceId: id,
        ),
      );
    }
    return result;
  }
}
