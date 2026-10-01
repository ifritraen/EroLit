// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/implementations/source_26_nifty.dart';

void main() {
  test('Verify NiftySource complete functionality', () async {
    final source = NiftySource();
    print('=== Verifying NiftySource ===');
    print('ID: ${source.id}, Name: ${source.name}, BaseUrl: ${source.baseUrl}');

    // 1. getCategories
    final categories = await source.getCategories();
    print('\n[1] getCategories: found ${categories.length} categories');
    expect(categories, isNotEmpty);

    // 2. getTags
    final tags = await source.getTags();
    print('\n[2] getTags: found ${tags.length} tags');
    expect(tags, isNotEmpty);

    // 3. getFeed
    print('\n[3] getFeed (page 1)...');
    final feed = await source.getFeed(page: 1);
    print('Feed items count: ${feed.length}');
    for (final item in feed.take(3)) {
      print('  Feed: ${item.title} -> ${item.url}');
    }
    expect(feed, isNotEmpty);

    // 4. getCategoryStories
    print('\n[4] getCategoryStories (college, page 1)...');
    final catStories = await source.getCategoryStories('college', page: 1);
    print('Category stories count: ${catStories.length}');
    for (final item in catStories.take(3)) {
      print('  CatStory: ${item.title} -> ${item.url}');
    }
    expect(catStories, isNotEmpty);

    // 5. getTagStories
    print('\n[5] getTagStories (romance, page 1)...');
    final tagStories = await source.getTagStories('romance', page: 1);
    print('Tag stories count: ${tagStories.length}');
    for (final item in tagStories.take(3)) {
      print('  TagStory: ${item.title} -> ${item.url}');
    }
    expect(tagStories, isNotEmpty);

    // 6. search
    print('\n[6] search ("college", page 1)...');
    final searchResults = await source.search('college', page: 1);
    print('Search results count: ${searchResults.length}');
    for (final item in searchResults.take(3)) {
      print('  Search: ${item.title} -> ${item.url}');
    }
    expect(searchResults, isNotEmpty);

    // 7. getStoryDetails (Multi-part directory saga)
    print('\n[7] getStoryDetails (Directory saga)...');
    final sagaDetails = await source.getStoryDetails('https://www.nifty.org/nifty/gay/college/my-dormmate-the-cocksucker/');
    print('Saga Title: ${sagaDetails.title}');
    print('Saga Chapters: ${sagaDetails.chapters.length}');
    for (final ch in sagaDetails.chapters) {
      print('  Ch: [${ch.index}] ${ch.title} -> ${ch.url}');
    }
    expect(sagaDetails.chapters, isNotEmpty);

    // 8. getStoryDetails (Standalone single story)
    print('\n[8] getStoryDetails (Standalone story)...');
    final singleDetails = await source.getStoryDetails('https://www.nifty.org/nifty/gay/college/how-i-slowly-turned-gay');
    print('Single Title: ${singleDetails.title}');
    print('Single Author: ${singleDetails.author}');
    print('Single Chapters: ${singleDetails.chapters.length}');
    expect(singleDetails.chapters, isNotEmpty);

    // 9. getChapterContent (Plaintext story)
    print('\n[9] getChapterContent (Plaintext)...');
    final txtContent = await source.getChapterContent('https://www.nifty.org/nifty/gay/college/my-dormmate-the-cocksucker/my-dormmate-the-cocksucker-1');
    print('Plaintext content length: ${txtContent.length}');
    expect(txtContent.length, greaterThan(50));

    // 10. getChapterContent (HTML story)
    print('\n[10] getChapterContent (HTML)...');
    final htmlContent = await source.getChapterContent('https://www.nifty.org/nifty/gay/adult-youth/roman-takes-a-chance/roman-takes-a-chance-1.html');
    print('HTML content length: ${htmlContent.length}');
    expect(htmlContent.length, greaterThan(50));

    print('\nALL NIFTY VERIFICATIONS PASSED SUCCESSFULLY!');
  }, timeout: const Timeout(Duration(seconds: 120)));
}
