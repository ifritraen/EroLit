// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/implementations/source_30_adultfanfiction.dart';

void main() {
  test('Verify AdultFanfictionSource contract implementation & resilience', () async {
    final source = AdultFanfictionSource();

    expect(source.id, equals('adultfanfiction'));
    expect(source.name, equals('Adult FanFiction'));
    expect(source.lang, equals('en'));
    expect(source.baseUrl, equals('http://adult-fanfiction.org'));
    expect(source.iconUrl, isNotNull);

    // 1. Categories
    final categories = await source.getCategories();
    expect(categories.isNotEmpty, isTrue);
    expect(categories.any((c) => c.slug == 'original'), isTrue);
    expect(categories.any((c) => c.slug == 'hp'), isTrue);
    print('Categories verified: ${categories.length} entries');

    // 2. Tags
    final tags = await source.getTags();
    expect(tags.isNotEmpty, isTrue);
    expect(tags.any((t) => t.slug == 'romance'), isTrue);
    print('Tags verified: ${tags.length} entries');

    // 3. Feed
    final feed = await source.getFeed(page: 1);
    expect(feed.isNotEmpty, isTrue);
    print('Feed verified: ${feed.length} stories returned (first: "${feed.first.title}")');

    // 4. Category Stories
    final catStories = await source.getCategoryStories('original', page: 1);
    expect(catStories.isNotEmpty, isTrue);
    print('Category stories verified: ${catStories.length} stories');

    // 5. Tag Stories
    final tagStories = await source.getTagStories('romance', page: 1);
    expect(tagStories.isNotEmpty, isTrue);
    print('Tag stories verified: ${tagStories.length} stories');

    // 6. Search
    final searchResults = await source.search('reward', page: 1);
    expect(searchResults.isNotEmpty, isTrue);
    print('Search verified: ${searchResults.length} matches for "reward"');

    // 7. Story Details
    final details = await source.getStoryDetails('http://original.adult-fanfiction.org/story.php?no=600110781');
    expect(details.title.isNotEmpty, isTrue);
    expect(details.chapters.isNotEmpty, isTrue);
    print('Story details verified: "${details.title}" by ${details.author} with ${details.chapters.length} chapters');

    // 8. Chapter Content
    final content = await source.getChapterContent(details.chapters.first.url);
    expect(content.isNotEmpty, isTrue);
    expect(content.length > 50, isTrue);
    print('Chapter content verified: ${content.length} characters');
  }, timeout: const Timeout(Duration(seconds: 30)));
}
