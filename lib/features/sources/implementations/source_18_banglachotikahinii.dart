import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class BanglaChotiKahiniSource implements BaseStorySource {
  @override
  String get id => 'banglachotikahinii';

  @override
  String get name => 'Bangla Choti Kahini';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://www.banglachotikahinii.com';

  @override
  String? get iconUrl =>
      'https://www.banglachotikahinii.com/wp-content/uploads/2014/12/cropped-Favicon-32x32.png';

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
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
      SourceCategory(name: 'অজাচার বাংলা চটি গল্প', slug: 'bangla-incest-choti'),
      SourceCategory(name: 'কাজের মাসি চোদার গল্প', slug: 'kajer-masi-bangla-choti'),
      SourceCategory(name: 'কাজের মেয়ে চোদার গল্প', slug: 'kajer-meye-bangla-choti'),
      SourceCategory(name: 'কুমারী মেয়ে চোদার গল্প', slug: 'kumari-meye-bangla-choti'),
      SourceCategory(name: 'গৃহবধূর চোদন কাহিনী', slug: 'bangla-housewife-sex-story'),
      SourceCategory(name: 'গে সেক্স চটি', slug: 'gay-sex-choti'),
      SourceCategory(name: 'গ্রুপ সেক্সের বাংলা চটি গল্প', slug: 'bangla-choti-group-sex'),
      SourceCategory(name: 'পরকিয়া বাংলা চটি গল্প', slug: 'bangla-illicit-sex-story'),
      SourceCategory(name: 'বৌদি চোদার গল্প', slug: 'boudi-sex-story'),
      SourceCategory(name: 'বাংলা চটি', slug: 'bengali-sex-stories'),
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

    // Fallback to search query
    try {
      final searchItems = await search(cleanSlug.replaceAll('-', ' '), page: page);
      if (searchItems.isNotEmpty) return searchItems;
    } catch (_) {}

    return [];
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'বৌদি', slug: 'boudi-sex-story'),
      SourceTag(name: 'অজাচার', slug: 'bangla-incest-choti'),
      SourceTag(name: 'গৃহবধূ', slug: 'bangla-housewife-sex-story'),
      SourceTag(name: 'পরকিয়া', slug: 'bangla-illicit-sex-story'),
      SourceTag(name: 'কুমারী', slug: 'kumari-meye-bangla-choti'),
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
    final title = titleEl?.text.trim() ?? 'Bangla Story';

    final authorEl = doc.querySelector('.author a') ?? doc.querySelector('.byline a');
    final author = authorEl?.text.trim();

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
      'script, style, iframe, .sharedaddy, .wpcnt, .post-ratings, .jp-relatedposts, ins, .adsbygoogle',
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

  List<SourceListingItem> _parseHtmlListings(String html) {
    final doc = html_parser.parse(html);
    final items = <SourceListingItem>[];

    final articles = doc.querySelectorAll('article[class*="post-"], article.post');
    for (final art in articles) {
      final titleEl = art.querySelector('h2.entry-title a') ??
          art.querySelector('.entry-title a') ??
          art.querySelector('h2 a');
      if (titleEl == null) continue;

      final title = titleEl.text.trim();
      final url = titleEl.attributes['href'] ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      final authorEl = art.querySelector('.author a') ?? art.querySelector('.byline a');
      final dateEl = art.querySelector('time.entry-date') ?? art.querySelector('.posted-on');
      final summaryEl = art.querySelector('.entry-summary p') ?? art.querySelector('.entry-summary');

      items.add(
        SourceListingItem(
          title: title,
          url: url,
          sourceId: id,
          author: authorEl?.text.trim(),
          date: dateEl?.text.trim(),
          summary: summaryEl?.text.trim(),
        ),
      );
    }

    return items;
  }
}
