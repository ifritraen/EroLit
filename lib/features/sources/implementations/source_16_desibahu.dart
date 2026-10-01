import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class DesiBahuSource implements BaseStorySource {
  @override
  String get id => 'desibahu';

  @override
  String get name => 'Desi Bahu';

  @override
  String get lang => 'hi';

  @override
  String get baseUrl => 'https://desibahu.com';

  @override
  String? get iconUrl => 'https://desibahu.com/favicon.ico';

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
      SourceCategory(name: 'Free Sex Stories', slug: 'free-sex-stories', count: '145'),
      SourceCategory(name: 'Indian Sex Stories', slug: 'indiansexstories', count: '124'),
      SourceCategory(name: 'Indian Wife', slug: 'indian-wife', count: '84'),
      SourceCategory(name: 'Erotic Sex Stories', slug: 'erotic-sex-stories', count: '58'),
      SourceCategory(name: 'Incest Sex', slug: 'incest-sex', count: '54'),
      SourceCategory(name: 'Indian Mom / Aunty', slug: 'indian-mom-chachi', count: '54'),
      SourceCategory(name: 'Desi Sex Stories', slug: 'desi-sex-stories', count: '43'),
      SourceCategory(name: 'Group Sex Stories', slug: 'group-sex-stories', count: '43'),
      SourceCategory(name: 'Sex with Stranger', slug: 'sex-with-stranger', count: '39'),
      SourceCategory(name: 'Maid / Servant', slug: 'maid-servant', count: '30'),
      SourceCategory(name: 'First time Sex', slug: 'first-time-sex-stories', count: '28'),
      SourceCategory(name: 'Hindi Sex Stories', slug: 'hindi-sex-stories', count: '28'),
      SourceCategory(name: 'Aunty & Bhabhi', slug: 'aunty-bhabhi', count: '27'),
      SourceCategory(name: 'Literotica', slug: 'literotica', count: '26'),
      SourceCategory(name: 'Bhabhi Sex Story', slug: 'bhabhi-sex-story', count: '22'),
      SourceCategory(name: 'Office / Teacher', slug: 'office-teacher', count: '16'),
      SourceCategory(name: 'Anal Sex', slug: 'anal-sex-story', count: '11'),
      SourceCategory(name: 'Interracial Sex', slug: 'interracial-sex', count: '9'),
      SourceCategory(name: 'Gay Male', slug: 'gay-sex-stories', count: '7'),
      SourceCategory(name: 'Gangbang & Group Sex', slug: 'gangbang-group-sex', count: '6'),
      SourceCategory(name: 'Wife Swapping', slug: 'wife-swapping', count: '5'),
      SourceCategory(name: 'Lesbian Sex', slug: 'lesbian-sex-story', count: '2'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(
    String categorySlug, {
    int page = 1,
  }) async {
    try {
      final query = categorySlug.replaceAll('-', ' ');
      final items = await search(query, page: page);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
    final url = page == 1
        ? '$baseUrl/category/$cleanSlug/'
        : '$baseUrl/category/$cleanSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Indian Sex Stories', slug: 'indian-sex-stories'),
      SourceTag(name: 'Literotica', slug: 'literotica'),
      SourceTag(name: 'Hindi Sex Stories', slug: 'hindi-sex-stories'),
      SourceTag(name: 'Desi Kahani 2', slug: 'desikahani2'),
      SourceTag(name: 'Desi Tales 2', slug: 'desitales2'),
      SourceTag(name: 'Armpit Fetish', slug: 'armpit-fetish'),
      SourceTag(name: 'Desi Sex Stories', slug: 'desi-sex-stories'),
      SourceTag(name: 'Group Sex Stories', slug: 'group-sex-stories'),
      SourceTag(name: 'Desi Kahani', slug: 'desi-kahani'),
      SourceTag(name: 'Desi Wife Sex Stories', slug: 'desi-wife-sex-stories'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    try {
      final query = tagSlug.replaceAll('-', ' ');
      final items = await search(query, page: page);
      if (items.isNotEmpty) return items;
    } catch (_) {}

    final cleanSlug = tagSlug.trim().replaceAll(RegExp(r'^/|/$'), '');
    final url = page == 1
        ? '$baseUrl/tag/$cleanSlug/'
        : '$baseUrl/tag/$cleanSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return [];
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
    final title = titleEl?.text.trim() ?? 'Untitled Story';

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
      'script, style, iframe, .sharedaddy, .adsbygoogle, ins, .code-block',
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

    final articles = doc.querySelectorAll('article[class*="post-"], article.post, .post');
    for (final art in articles) {
      final titleEl = art.querySelector('h2.entry-title a') ??
          art.querySelector('.entry-title a') ??
          art.querySelector('h2 a');
      if (titleEl == null) continue;

      final title = titleEl.text.trim();
      final url = titleEl.attributes['href'] ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      final dateEl = art.querySelector('time.entry-date') ??
          art.querySelector('.posted-on');
      final summaryEl = art.querySelector('.entry-summary p') ??
          art.querySelector('.entry-content p');

      final coverEl = art.querySelector('.wp-post-image') ?? art.querySelector('img');
      final coverUrl = coverEl?.attributes['src'] ?? coverEl?.attributes['data-src'];

      items.add(
        SourceListingItem(
          title: title,
          url: url,
          sourceId: id,
          date: dateEl?.text.trim(),
          summary: summaryEl?.text.trim(),
          coverUrl: coverUrl,
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
