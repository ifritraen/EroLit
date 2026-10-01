// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/implementations/source_25_ao3.dart';

void main() {
  test('Verify AO3Source contract implementation and operations', () async {
    final source = AO3Source();

    expect(source.id, equals('ao3'));
    expect(source.name, equals('Archive of Our Own (Original Works)'));
    expect(source.lang, equals('en'));
    expect(source.baseUrl, equals('https://archiveofourown.org'));
    expect(source.iconUrl, isNotNull);

    // 1. Categories
    print('=== Testing getCategories ===');
    final categories = await source.getCategories();
    expect(categories, isNotEmpty);
    print('Categories count: ${categories.length}');

    // 2. Tags
    print('\n=== Testing getTags ===');
    final tags = await source.getTags();
    expect(tags, isNotEmpty);
    print('Tags count: ${tags.length}');

    // 3. Feed
    print('\n=== Testing getFeed ===');
    final feed = await source.getFeed(page: 1);
    expect(feed, isNotEmpty);
    print('Feed count: ${feed.length} (first: "${feed.first.title}")');

    // 4. Category Stories
    print('\n=== Testing getCategoryStories ===');
    final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
    expect(catStories, isNotEmpty);
    print('Category "${categories.first.slug}" count: ${catStories.length}');

    // 5. Tag Stories
    print('\n=== Testing getTagStories ===');
    final tagStories = await source.getTagStories(tags.first.slug, page: 1);
    expect(tagStories, isNotEmpty);
    print('Tag "${tags.first.slug}" count: ${tagStories.length}');

    // 6. Search
    print('\n=== Testing search ===');
    final searchResults = await source.search('romance', page: 1);
    expect(searchResults, isNotEmpty);
    print('Search "romance" count: ${searchResults.length}');

    // 7. Story Details
    print('\n=== Testing getStoryDetails ===');
    final firstItem = feed.first;
    final details = await source.getStoryDetails(firstItem.url);
    expect(details.title, isNotEmpty);
    expect(details.chapters, isNotEmpty);
    print('Story details: "${details.title}" with ${details.chapters.length} chapter(s)');

    // 8. Chapter Content
    print('\n=== Testing getChapterContent ===');
    final chapterUrl = details.chapters.first.url;
    final content = await source.getChapterContent(chapterUrl);
    expect(content, isNotEmpty);
    print('Chapter content length: ${content.length} characters');

    print('\nALL AO3 TESTS PASSED!');
  }, timeout: const Timeout(Duration(seconds: 120)));
}
