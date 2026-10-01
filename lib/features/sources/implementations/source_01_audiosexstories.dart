import 'package:html/parser.dart' as html_parser;
import '../domain/source_contract.dart';
import '../engine/scraper_client.dart';

class AudioSexStoriesSource implements BaseStorySource {
  @override
  String get id => 'audiosexstories';

  @override
  String get name => 'Audio Sex Stories';

  @override
  String get lang => 'bn';

  @override
  String get baseUrl => 'https://www.audiosexstories.net';

  @override
  String? get iconUrl => null;

  @override
  Future<List<SourceListingItem>> getFeed({int page = 1}) async {
    // Bengali archive
    final url = page == 1
        ? '$baseUrl/language/bengali/'
        : '$baseUrl/language/bengali/page/$page/';

    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<List<SourceCategory>> getCategories() async {
    return [
      SourceCategory(name: 'Bengali Stories', slug: 'language/bengali'),
      SourceCategory(name: 'Hindi Stories', slug: 'language/hindi'),
      SourceCategory(name: 'Cheating Wives', slug: 'category/cheating-wives'),
      SourceCategory(name: 'Couple', slug: 'category/couple'),
      SourceCategory(name: 'Housewife', slug: 'category/housewife'),
      SourceCategory(name: 'Threesome', slug: 'category/threesome'),
      SourceCategory(name: 'Fetishes', slug: 'category/indian-fetishes'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1}) async {
    try {
      final cleanSlug = categorySlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final path = cleanSlug.contains('/') ? cleanSlug : 'category/$cleanSlug';
      final url = page == 1
          ? '$baseUrl/$path/'
          : '$baseUrl/$path/page/$page/';

      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    final searchKeyword = categorySlug.split('/').last.replaceAll('-', ' ');
    return search(searchKeyword, page: page);
  }

  @override
  Future<List<SourceTag>> getTags() async {
    return [
      SourceTag(name: 'Cheating Wives', slug: 'category/cheating-wives'),
      SourceTag(name: 'Housewife', slug: 'category/housewife'),
      SourceTag(name: 'Couple', slug: 'category/couple'),
      SourceTag(name: 'Threesome', slug: 'category/threesome'),
      SourceTag(name: 'Bengali Audio', slug: 'language/bengali'),
      SourceTag(name: 'Hindi Audio', slug: 'language/hindi'),
    ];
  }

  @override
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1}) async {
    try {
      final cleanSlug = tagSlug.trim().replaceAll(RegExp(r'^/|/$'), '');
      final path = cleanSlug.contains('/') ? cleanSlug : 'tag/$cleanSlug';
      final url = page == 1
          ? '$baseUrl/$path/'
          : '$baseUrl/$path/page/$page/';

      final res = await ScraperClient.dio.get(url);
      final items = _parseListings(res.data.toString());
      if (items.isNotEmpty) return items;
    } catch (_) {}

    final searchKeyword = tagSlug.split('/').last.replaceAll('-', ' ');
    return search(searchKeyword, page: page);
  }

  @override
  Future<List<SourceListingItem>> search(String query, {int page = 1}) async {
    final url = page == 1
        ? '$baseUrl/?s=${Uri.encodeComponent(query)}'
        : '$baseUrl/page/$page/?s=${Uri.encodeComponent(query)}';

    final res = await ScraperClient.dio.get(url);
    return _parseListings(res.data.toString());
  }

  @override
  Future<SourceNovelDetails> getStoryDetails(String url) async {
    final res = await ScraperClient.dio.get(url);
    final doc = html_parser.parse(res.data.toString());

    final title = doc.querySelector('h1.post_title, .video_item_title')?.text.trim() ?? 'Audio Story';
    final cover = doc.querySelector('.post_img img, .video_item_img img')?.attributes['src'];
    final description = doc.querySelector('.post_content, .excrept')?.text.trim();

    return SourceNovelDetails(
      title: title,
      url: url,
      coverUrl: cover,
      description: description,
      status: 'Completed',
      chapters: [
        SourceChapter(
          index: 1.0,
          title: 'Full Audio Episode',
          url: url,
        ),
      ],
    );
  }

  @override
  Future<String> getChapterContent(String chapterUrl) async {
    final res = await ScraperClient.dio.get(chapterUrl);
    final doc = html_parser.parse(res.data.toString());

    // Extract direct MP3 audio stream link if present
    final audioSrc = doc.querySelector('.post_audio audio')?.attributes['src'] ??
        doc.querySelector('audio source')?.attributes['src'] ??
        doc.querySelector('audio')?.attributes['src'];

    final textContent = doc.querySelector('.post_content')?.text.trim() ?? '';

    final buffer = StringBuffer();
    if (audioSrc != null && audioSrc.isNotEmpty) {
      buffer.writeln('[Audio Stream Available]');
      buffer.writeln('Stream URL: $audioSrc\n');
    }
    if (textContent.isNotEmpty) {
      buffer.writeln(textContent);
    } else {
      buffer.writeln('Audio episode ready for playback.');
    }

    return buffer.toString();
  }

  List<SourceListingItem> _parseListings(String html) {
    final doc = html_parser.parse(html);
    final items = doc.querySelectorAll('.video_item');
    final List<SourceListingItem> result = [];

    for (final item in items) {
      final titleEl = item.querySelector('.video_item_title a');
      final title = titleEl?.text.trim() ?? '';
      final url = titleEl?.attributes['href'] ?? '';
      final cover = item.querySelector('.video_item_img img')?.attributes['src'];
      final summary = item.querySelector('.excrept p')?.text.trim();

      if (title.isNotEmpty && url.isNotEmpty) {
        result.add(
          SourceListingItem(
            title: title,
            url: url,
            coverUrl: cover,
            summary: summary,
            sourceId: id,
          ),
        );
      }
    }

    return result;
  }
}
