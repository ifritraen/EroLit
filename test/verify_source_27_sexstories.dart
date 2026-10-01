// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/implementations/source_27_sexstories.dart';

void main() {
  test('Verify SexStoriesSource contract implementation & resilience', () async {
    final source = SexStoriesSource();

    expect(source.id, equals('sexstories'));
    expect(source.name, equals('SexStories'));
    expect(source.lang, equals('en'));
    expect(source.baseUrl, equals('https://www.sexstories.com'));
    expect(source.iconUrl, isNotNull);

    // 1. Categories
    final categories = await source.getCategories();
    expect(categories.isNotEmpty, isTrue);
    expect(categories.any((c) => c.slug.contains('Fiction')), isTrue);
    print('Categories verified: ${categories.length} entries');

    // 2. Tags
    final tags = await source.getTags();
    expect(tags.isNotEmpty, isTrue);
    expect(tags.any((t) => t.slug.contains('Blowjob')), isTrue);
    print('Tags verified: ${tags.length} entries');

    // 3. Feed
    final feed = await source.getFeed(page: 1);
    expect(feed.isNotEmpty, isTrue);
    print('Feed verified: ${feed.length} stories returned (first: "${feed.first.title}")');

    // 4. Category Stories
    final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
    expect(catStories.isNotEmpty, isTrue);
    print('Category stories verified: ${catStories.length} stories');

    // 5. Tag Stories
    final tagStories = await source.getTagStories(tags.first.slug, page: 1);
    expect(tagStories.isNotEmpty, isTrue);
    print('Tag stories verified: ${tagStories.length} stories');

    // 6. Search
    final searchResults = await source.search('sister', page: 1);
    expect(searchResults.isNotEmpty, isTrue);
    print('Search verified: ${searchResults.length} matches for "sister"');

    // 7. Story Details
    final details = await source.getStoryDetails('https://www.sexstories.com/story/115518/backseat_sister');
    expect(details.title.isNotEmpty, isTrue);
    expect(details.chapters.isNotEmpty, isTrue);
    print('Story details verified: "${details.title}" by ${details.author} with ${details.chapters.length} chapters');

    // 8. Chapter Content
    final content = await source.getChapterContent(details.chapters.first.url);
    expect(content.isNotEmpty, isTrue);
    expect(content.length > 50, isTrue);
    print('Chapter content verified: ${content.length} characters');
  }, timeout: const Timeout(Duration(seconds: 120)));
}
