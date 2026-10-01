import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class XxxIndianStoriesSource implements BaseStorySource {
  @override
  String get id => 'xxxindianstories';

  @override
  String get name => 'XXX Indian Stories';

  @override
  String get lang => 'en';

  @override
  String get baseUrl => 'https://www.xxxindianstories.com';

  @override
  String? get iconUrl =>
      'https://www.xxxindianstories.com/wp-content/uploads/2020/01/xis_app_icon_192x192_0.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    final url = page == 1 ? '$baseUrl/' : '$baseUrl/page/$page/';
    try {
      final res = await ScraperClient.dio.get(url);
      return _parseHtmlListings(res.data.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 403) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Couple', slug: 'couple'),
      SourceCategory(name: 'Desi', slug: 'desi'),
      SourceCategory(name: 'Family Sex Stories', slug: 'family-sex-stories'),
      SourceCategory(name: 'Gay Male', slug: 'gay-male'),
      SourceCategory(name: 'Group', slug: 'group'),
      SourceCategory(name: 'Lesbian', slug: 'lesbian'),
      SourceCategory(name: 'Maid Servant', slug: 'maid-servant'),
      SourceCategory(name: 'Naukrani', slug: 'naukrani'),
      SourceCategory(name: 'Office / Teacher', slug: 'office-teacher'),
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
      final items = _parseHtmlListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Cheating Wife', slug: 'cheating-wife'),
      SourceTag(name: 'Horny', slug: 'horny'),
      SourceTag(name: 'IndianSexStories2', slug: 'indiansexstories2'),
      SourceTag(name: 'Lust', slug: 'lust'),
      SourceTag(name: 'Mature Wife', slug: 'mature-wife'),
      SourceTag(name: 'Bhabhi', slug: 'bhabhi'),
      SourceTag(name: 'Housewife', slug: 'housewife'),
      SourceTag(name: 'First Time', slug: 'first-time'),
      SourceTag(name: 'Hindi Audio', slug: 'hindi-audio'),
      SourceTag(name: 'Blowjob', slug: 'blowjob'),
      SourceTag(name: 'Affair', slug: 'affair'),
      SourceTag(name: 'Aunty', slug: 'aunty'),
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

    return [];
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
      if (e.response?.statusCode == 404 || e.response?.statusCode == 403) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final titleEl = doc.querySelector('h1.entry-title') ?? doc.querySelector('h1');
    final title = titleEl?.text.trim() ?? 'Untitled Story';

    final authorEl = doc.querySelector('.entry-meta .author a') ??
        doc.querySelector('.author a') ??
        doc.querySelector('.byline a');
    final author = authorEl?.text.trim();

    final coverEl = doc.querySelector('.wp-post-image') ??
        doc.querySelector('.entry-content img');
    final coverUrl = coverEl?.attributes['src'] ?? coverEl?.attributes['data-src'];

    final genres = <String>[];
    for (final catLink in doc.querySelectorAll('.entry-header a[href*="/category/"], .cat-links a')) {
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

    // Clean advertisements and widgets
    for (final el in contentEl.querySelectorAll(
      'script, style, iframe, .sharedaddy, .wpcnt, .post-ratings, .jp-relatedposts, ins, .adsbygoogle',
    )) {
      el.remove();
    }

    final paragraphs = <String>[];
    for (final node in contentEl.querySelectorAll('p, blockquote')) {
      final text = node.text.trim();
      if (text.isEmpty) continue;
      // Skip disclaimer and feedback footers
      if (text.contains('Author of this story wrote it for you') ||
          text.contains('feedback in the comments below')) {
        continue;
      }
      paragraphs.add(text);
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

    final articles = doc.querySelectorAll('article[class*="post-"], article.post, .inside-article');
    for (final art in articles) {
      final titleEl = art.querySelector('h2.entry-title a') ??
          art.querySelector('.entry-title a') ??
          art.querySelector('h2 a');
      if (titleEl == null) continue;

      final title = titleEl.text.trim();
      final url = titleEl.attributes['href'] ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      final authorEl = art.querySelector('.entry-meta .author a') ??
          art.querySelector('.byline a');
      final dateEl = art.querySelector('time.entry-date') ??
          art.querySelector('time.published') ??
          art.querySelector('.posted-on');
      final summaryEl = art.querySelector('.entry-summary p') ??
          art.querySelector('.entry-summary');

      final coverEl = art.querySelector('img.attachment-post-thumbnail') ??
          art.querySelector('img.wp-post-image') ??
          art.querySelector('img');
      final coverUrl = coverEl?.attributes['src'] ?? coverEl?.attributes['data-src'];

      items.add(
        SourceListingItem(
          title: title,
          url: url,
          sourceId: id,
          author: authorEl?.text.trim(),
          date: dateEl?.text.trim(),
          summary: summaryEl?.text.trim(),
          coverUrl: coverUrl,
        ),
      );
    }

    return items;
  }
}
