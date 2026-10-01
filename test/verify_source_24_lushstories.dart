// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/implementations/source_24_lushstories.dart';

void main() {
  test('Verify Source 24: Lush Stories complete functionality', () async {
    final source = LushStoriesSource();

    expect(source.id, equals('lushstories'));
    expect(source.name, equals('Lush Stories'));
    expect(source.lang, equals('en'));
    expect(source.baseUrl, equals('https://www.lushstories.com'));

    print('=== Testing getFeed ===');
    final feed = await source.getFeed(page: 1);
    print('Feed items count: ${feed.length}');
    expect(feed, isNotEmpty);
    final firstFeed = feed.first;
    print('First feed item: ${firstFeed.title} -> ${firstFeed.url}');
    expect(firstFeed.title, isNotEmpty);
    expect(firstFeed.url, startsWith('http'));

    print('\n=== Testing getCategories ===');
    final cats = await source.getCategories();
    print('Categories count: ${cats.length}');
    expect(cats, isNotEmpty);
    expect(cats.length, greaterThanOrEqualTo(50));

    print('\n=== Testing getCategoryStories ===');
    final catStories = await source.getCategoryStories('cuckold', page: 1);
    print('Category "cuckold" stories: ${catStories.length}');
    expect(catStories, isNotEmpty);
    print('First cuckold story: ${catStories.first.title}');

    print('\n=== Testing getTags ===');
    final tags = await source.getTags();
    print('Tags count: ${tags.length}');
    expect(tags, isNotEmpty);

    print('\n=== Testing getTagStories ===');
    final tagStories = await source.getTagStories('seduction', page: 1);
    print('Tag "seduction" stories: ${tagStories.length}');
    expect(tagStories, isNotEmpty);

    print('\n=== Testing search ===');
    final searchResults = await source.search('wife', page: 1);
    print('Search "wife" results: ${searchResults.length}');
    expect(searchResults, isNotEmpty);

    print('\n=== Testing getStoryDetails ===');
    final detailUrl = firstFeed.url;
    final details = await source.getStoryDetails(detailUrl);
    print('Story Title: ${details.title}');
    print('Author: ${details.author}');
    print('Description: ${details.description?.substring(0, details.description!.length > 80 ? 80 : details.description!.length)}');
    print('Chapters: ${details.chapters.length}');
    expect(details.title, isNotEmpty);
    expect(details.chapters, isNotEmpty);

    print('\n=== Testing getChapterContent ===');
    final chapterUrl = details.chapters.first.url;
    final content = await source.getChapterContent(chapterUrl);
    print('Chapter content length: ${content.length}');
    print('Preview: ${content.substring(0, content.length > 150 ? 150 : content.length)}...');
    expect(content, isNotEmpty);
    expect(content, isNot(contains('could not be loaded')));

    print('\n=== Testing Resilience Fallback on Invalid Slugs/URLs ===');
    final invalidCat = await source.getCategoryStories('non-existent-genre-xyz-999', page: 1);
    print('Non-existent category returned: ${invalidCat.length} items (no crash)');

    final invalidTag = await source.getTagStories('non-existent-tag-xyz-999', page: 1);
    print('Non-existent tag returned: ${invalidTag.length} items (no crash)');

    final invalidDetails = await source.getStoryDetails('https://www.lushstories.com/stories/fiction/non-existent-slug');
    print('Invalid story details title: ${invalidDetails.title} (no crash)');
    expect(invalidDetails.title, isNotEmpty);

    final invalidContent = await source.getChapterContent('https://www.lushstories.com/stories/fiction/non-existent-slug');
    print('Invalid chapter content response: $invalidContent (no crash)');
    expect(invalidContent, isNotEmpty);

    print('\nALL LUSH STORIES TESTS PASSED CLEANLY!');
  });
}
