// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/implementations/source_29_tgstorytime.dart';

void main() {
  test('Verify TGStorytimeSource contract implementation & resilience', () async {
    final source = TGStorytimeSource();

    expect(source.id, equals('tgstorytime'));
    expect(source.name, equals('TGStorytime'));
    expect(source.lang, equals('en'));
    expect(source.baseUrl, equals('https://www.tgstorytime.com'));
    expect(source.iconUrl, isNotNull);

    // 1. Categories
    final categories = await source.getCategories();
    expect(categories, isNotEmpty);
    print('Categories verified: ${categories.length} entries');

    // 2. Tags
    final tags = await source.getTags();
    expect(tags, isNotEmpty);
    print('Tags verified: ${tags.length} entries');

    // 3. Feed
    final feed = await source.getFeed(page: 1);
    expect(feed, isNotEmpty);
    print('Feed verified: ${feed.length} stories (first: "${feed.first.title}")');

    // 4. Category Stories
    final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
    expect(catStories, isNotEmpty);
    print('Category stories: ${catStories.length} stories');

    // 5. Tag Stories
    final tagStories = await source.getTagStories(tags.first.slug, page: 1);
    expect(tagStories, isNotEmpty);
    print('Tag stories: ${tagStories.length} stories');

    // 6. Search
    final searchResults = await source.search('transformation', page: 1);
    expect(searchResults, isNotEmpty);
    print('Search verified: ${searchResults.length} matches for "transformation"');

    // 7. Story Details
    final details = await source.getStoryDetails('https://www.tgstorytime.com/viewstory.php?sid=9412');
    expect(details.title, isNotEmpty);
    expect(details.chapters, isNotEmpty);
    print('Story details verified: "${details.title}" with ${details.chapters.length} chapter(s)');

    // 8. Chapter Content
    final content = await source.getChapterContent(details.chapters.first.url);
    expect(content, isNotEmpty);
    print('Chapter content verified: ${content.length} characters');

    print('\nALL TGSTORYTIME TESTS PASSED!');
  }, timeout: const Timeout(Duration(seconds: 120)));
}
