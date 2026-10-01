import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class BdSexStorySource implements BaseStorySource {
  @override
  String get id => 'bdsexstory';

  @override
  String get name => 'BD Sex Story';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://bdsexstory.online';

  @override
  String? get iconUrl =>
      'https://bdsexstory.online/wp-content/uploads/2025/02/003-512-150x150.webp';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Primary: REST API query
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=100&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return _parseApiPosts(res.data as List);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        return [];
      }
    } catch (_) {}

    // Fallback: HTML parsing
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
      SourceCategory(name: 'Bangla Choti', slug: 'bangla-choti', count: '206'),
      SourceCategory(name: 'মা ছেলে চটি', slug: 'adult-choti-kahini-ma', count: '107'),
      SourceCategory(name: 'মা মেয়ে চোদা', slug: 'ma-meye-chodar-choti-golpo', count: '20'),
      SourceCategory(name: 'মাগি চোদার গল্প', slug: 'magi-chodar-golpo', count: '14'),
      SourceCategory(name: 'Husband Wife Sex', slug: 'husband-wife-sex-choti', count: '9'),
      SourceCategory(name: 'Virgin Girl Choda', slug: 'virgin-girl-choda', count: '8'),
      SourceCategory(name: 'কাজের মাসি', slug: 'kajer-masir-pod-mara', count: '5'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/category/$categorySlug/'
        : '$baseUrl/category/$categorySlug/page/$page/';
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
      SourceTag(name: 'Bangla Choti', slug: 'bangla-choti'),
      SourceTag(name: 'মা ছেলে', slug: 'adult-choti-kahini-ma'),
      SourceTag(name: 'মাগি চোদা', slug: 'magi-chodar-golpo'),
      SourceTag(name: 'Virgin', slug: 'virgin-girl-choda'),
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
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?search=$encoded&page=$page&per_page=100&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return _parseApiPosts(res.data as List);
      }
    } catch (_) {}

    final url = page == 1 ? '$baseUrl/?s=$encoded' : '$baseUrl/page/$page/?s=$encoded';
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
    final title = titleEl?.text.trim() ?? 'Bangla Choti';

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
    if (contentEl == null) return 'গল্পটি লোড করা যায়নি।';

    for (final el in contentEl.querySelectorAll(
      'script, style, iframe, .code-block, .sharedaddy, .adsbygoogle, ins, #respond',
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
      return text.isNotEmpty ? text : 'গল্পের টেক্সট ফাঁকা।';
    }

    return paragraphs.join('\n\n');
  }

  List<SourceListingItem> _parseApiPosts(List posts) {
    final items = <SourceListingItem>[];
    for (final post in posts) {
      if (post is! Map) continue;
      final titleMap = post['title'] as Map?;
      final rawTitle = titleMap?['rendered']?.toString() ?? '';
      final title = _unescapeHtml(rawTitle);

      final link = post['link']?.toString() ?? '';
      if (title.isEmpty || link.isEmpty) continue;

      String? coverUrl;
      final embedded = post['_embedded'] as Map?;
      if (embedded != null && embedded['wp:featuredmedia'] is List) {
        final mediaList = embedded['wp:featuredmedia'] as List;
        if (mediaList.isNotEmpty && mediaList[0] is Map) {
          coverUrl = mediaList[0]['source_url']?.toString();
        }
      }

      final date = post['date']?.toString().split('T').first;
      final excerptMap = post['excerpt'] as Map?;
      final excerpt = _stripHtml(excerptMap?['rendered']?.toString() ?? '');

      items.add(
        SourceListingItem(
          title: title,
          url: link,
          sourceId: id,
          coverUrl: coverUrl,
          date: date,
          summary: excerpt.isNotEmpty ? excerpt : null,
        ),
      );
    }
    return items;
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

  String _stripHtml(String html) {
    return html_parser.parse(html).body?.text.trim() ?? '';
  }

  String _unescapeHtml(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8216;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&#8211;', '–')
        .replaceAll('&#8212;', '—')
        .replaceAll('&nbsp;', ' ');
  }
}
