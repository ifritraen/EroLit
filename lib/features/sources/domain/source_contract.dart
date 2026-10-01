class SourceListingItem {
  final String title;
  final String url;
  final String? coverUrl;
  final String? author;
  final String? date;
  final String? summary;
  final String sourceId;

  SourceListingItem({
    required this.title,
    required this.url,
    this.coverUrl,
    this.author,
    this.date,
    this.summary,
    required this.sourceId,
  });
}

class SourceCategory {
  final String name;
  final String slug;
  final String? count;

  SourceCategory({
    required this.name,
    required this.slug,
    this.count,
  });
}

class SourceTag {
  final String name;
  final String slug;

  SourceTag({
    required this.name,
    required this.slug,
  });
}

class SourceChapter {
  final double index;
  final String title;
  final String url;
  final String? releaseDate;

  SourceChapter({
    required this.index,
    required this.title,
    required this.url,
    this.releaseDate,
  });
}

class SourceNovelDetails {
  final String title;
  final String url;
  final String? author;
  final String? coverUrl;
  final String? description;
  final String? status;
  final List<String> genres;
  final List<SourceChapter> chapters;

  SourceNovelDetails({
    required this.title,
    required this.url,
    this.author,
    this.coverUrl,
    this.description,
    this.status,
    this.genres = const [],
    this.chapters = const [],
  });
}

abstract class BaseStorySource {
  String get id;
  String get name;
  String get lang; // 'bn', 'en', 'hi', etc.
  String get baseUrl;
  String? get iconUrl;

  Future<List<SourceListingItem>> getFeed({int page = 1});
  Future<List<SourceCategory>> getCategories();
  Future<List<SourceListingItem>> getCategoryStories(String categorySlug, {int page = 1});
  Future<List<SourceTag>> getTags();
  Future<List<SourceListingItem>> getTagStories(String tagSlug, {int page = 1});
  Future<List<SourceListingItem>> search(String query, {int page = 1});
  Future<SourceNovelDetails> getStoryDetails(String url);
  Future<String> getChapterContent(String chapterUrl);
}
