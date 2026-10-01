import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class TheIndianSexStorySource implements BaseStorySource {
  @override
  String get id => 'theindiansexstory';

  @override
  String get name => 'The Indian Sex Story';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://en.theindiansexstory.com';

  @override
  String? get iconUrl =>
      'https://en.theindiansexstory.com/wp-content/uploads/2024/11/cropped-cropped-The-Indian-Sex-Story-32x32.png';

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
      SourceCategory(name: 'Hardcore sex Story', slug: 'hardcore-sex-story', count: '314'),
      SourceCategory(name: 'Family Sex Story', slug: 'family-sex-story', count: '169'),
      SourceCategory(name: 'Cheating Wife', slug: 'cheating-wife', count: '130'),
      SourceCategory(name: 'Anal Sex Story', slug: 'anal-sex-story', count: '88'),
      SourceCategory(name: 'Group Sex Story', slug: 'group-sex-story', count: '66'),
      SourceCategory(name: 'Brother Sister Sex Story', slug: 'brother-sister-sex-story', count: '66'),
      SourceCategory(name: 'Virgin Girl Hymen Break', slug: 'virgin-girl-hymen-break-sex-story', count: '62'),
      SourceCategory(name: 'Teen sex story', slug: 'teen-sex-story', count: '55'),
      SourceCategory(name: 'Aunty Sex Story', slug: 'aunty-sex-story', count: '46'),
      SourceCategory(name: 'Husband Wife Sex story', slug: 'husband-wife-sex-story', count: '37'),
      SourceCategory(name: 'Sister in law sex story', slug: 'sister-in-law-sex-story', count: '37'),
      SourceCategory(name: 'Girlfriend Boyfriend Sex Story', slug: 'girlfriend-boyfriend-sex-story', count: '35'),
      SourceCategory(name: 'Cuckold Sex Story', slug: 'cuckold-sex-story', count: '29'),
      SourceCategory(name: 'Sex with Stranger', slug: 'sex-with-stranger', count: '22'),
      SourceCategory(name: 'Dad Daughter Sex Story', slug: 'dad-daughter-sex-story', count: '18'),
      SourceCategory(name: 'Student and Teacher Sex Story', slug: 'student-and-teacher-sex-story', count: '18'),
      SourceCategory(name: 'Father in Law sex story', slug: 'father-in-law-sex-story', count: '18'),
      SourceCategory(name: 'Mom Son sex story', slug: 'mom-son-sex-story', count: '15'),
      SourceCategory(name: 'Jija Sali sex story', slug: 'jija-sali-sex-story', count: '14'),
      SourceCategory(name: 'Cheating Husband', slug: 'cheating-husband', count: '13'),
      SourceCategory(name: 'Neighbor Sex Story', slug: 'neighbor-sex-story', count: '12'),
      SourceCategory(name: 'Sex with servant', slug: 'sex-with-servant', count: '12'),
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
      SourceTag(name: 'Big Dick', slug: 'big-dick'),
      SourceTag(name: 'Strong Cock', slug: 'strong-cock'),
      SourceTag(name: 'Dirty Sex', slug: 'dirty-sex'),
      SourceTag(name: 'Bra-Panty', slug: 'bra-panty'),
      SourceTag(name: 'Finering', slug: 'finering'),
      SourceTag(name: 'Romantic Sex', slug: 'romantic-sex'),
      SourceTag(name: 'Married Woman', slug: 'married-woman'),
      SourceTag(name: 'Blowjob', slug: 'blowjob'),
      SourceTag(name: 'Sex with Elder Woman', slug: 'sex-with-elder-woman'),
      SourceTag(name: 'Incest Sex', slug: 'incest-sex'),
      SourceTag(name: 'Virgin', slug: 'virgin'),
      SourceTag(name: 'Anal Sex Story', slug: 'anal-sex-story'),
      SourceTag(name: 'Hymen', slug: 'hymen'),
      SourceTag(name: 'Risky Sex', slug: 'risky-sex'),
      SourceTag(name: 'Hot Girl Sex', slug: 'hot-girl-sex'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(
    String tagSlug, {
    int page = 1,
  }) async {
    final url = page == 1
        ? '$baseUrl/tag/$tagSlug/'
        : '$baseUrl/tag/$tagSlug/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseHtmlListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final encoded = Uri.encodeComponent(query);
    // Try REST search
    try {
      final apiUrl = '$baseUrl/wp-json/wp/v2/posts?search=$encoded&page=$page&per_page=100&_embed';
      final res = await ScraperClient.dio.get(apiUrl);
      if (res.statusCode == 200 && res.data is List) {
        return _parseApiPosts(res.data as List);
      }
    } catch (_) {}

    // Fallback HTML search
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

    // Clean ads, code-blocks, and widgets
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
      final titleEl = art.querySelector('.entry-title a') ?? art.querySelector('h2 a');
      if (titleEl == null) continue;

      final title = titleEl.text.trim();
      final url = titleEl.attributes['href'] ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      final dateEl = art.querySelector('time.entry-date') ?? art.querySelector('.published');
      final summaryEl = art.querySelector('.entry-summary p') ?? art.querySelector('.entry-content p');

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
