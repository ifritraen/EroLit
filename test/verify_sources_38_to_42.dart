@Timeout(Duration(minutes: 5))
library verify_sources_38_to_42;

// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/data/source_registry.dart';
import 'package:erolit/features/sources/implementations/source_38_eroticshortstories.dart';
import 'package:erolit/features/sources/implementations/source_39_chyoa.dart';
import 'package:erolit/features/sources/implementations/source_40_eroticstories.dart';
import 'package:erolit/features/sources/implementations/source_41_naughtyfiction.dart';
import 'package:erolit/features/sources/implementations/source_42_darkerotica.dart';

void main() {
  group('Verify Sources 38-42 in SourceRegistry', () {
    test('Registry contains all 42 sources', () {
      expect(SourceRegistry.initialSources.length, equals(42));
      expect(SourceRegistry.getSourceById('eroticshortstories'), isNotNull);
      expect(SourceRegistry.getSourceById('chyoa'), isNotNull);
      expect(SourceRegistry.getSourceById('eroticstories'), isNotNull);
      expect(SourceRegistry.getSourceById('naughtyfiction'), isNotNull);
      expect(SourceRegistry.getSourceById('darkerotica'), isNotNull);
    });

    test('Source 38 (EroticShortStoriesSource) all 8 contract methods', () async {
      final source = EroticShortStoriesSource();
      expect(source.id, equals('eroticshortstories'));
      expect(source.lang, equals('en'));

      final categories = await source.getCategories();
      expect(categories, isNotEmpty);
      final tags = await source.getTags();
      expect(tags, isNotEmpty);

      final feed = await source.getFeed(page: 1);
      expect(feed, isNotEmpty);

      final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
      expect(catStories, isNotEmpty);

      final tagStories = await source.getTagStories(tags.first.slug, page: 1);
      expect(tagStories, isNotEmpty);

      final searchStories = await source.search('Elevator', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 39 (ChyoaSource) all 8 contract methods', () async {
      final source = ChyoaSource();
      expect(source.id, equals('chyoa'));
      expect(source.lang, equals('en'));

      final categories = await source.getCategories();
      expect(categories, isNotEmpty);
      final tags = await source.getTags();
      expect(tags, isNotEmpty);

      final feed = await source.getFeed(page: 1);
      expect(feed, isNotEmpty);

      final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
      expect(catStories, isNotEmpty);

      final tagStories = await source.getTagStories(tags.first.slug, page: 1);
      expect(tagStories, isNotEmpty);

      final searchStories = await source.search('Claim', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 40 (EroticStoriesSource) all 8 contract methods', () async {
      final source = EroticStoriesSource();
      expect(source.id, equals('eroticstories'));
      expect(source.lang, equals('en'));

      final categories = await source.getCategories();
      expect(categories, isNotEmpty);
      final tags = await source.getTags();
      expect(tags, isNotEmpty);

      final feed = await source.getFeed(page: 1);
      expect(feed, isNotEmpty);

      final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
      expect(catStories, isNotEmpty);

      final tagStories = await source.getTagStories(tags.first.slug, page: 1);
      expect(tagStories, isNotEmpty);

      final searchStories = await source.search('Sexy', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 41 (NaughtyFictionSource) all 8 contract methods', () async {
      final source = NaughtyFictionSource();
      expect(source.id, equals('naughtyfiction'));
      expect(source.lang, equals('en'));

      final categories = await source.getCategories();
      expect(categories, isNotEmpty);
      final tags = await source.getTags();
      expect(tags, isNotEmpty);

      final feed = await source.getFeed(page: 1);
      expect(feed, isNotEmpty);

      final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
      expect(catStories, isNotEmpty);

      final tagStories = await source.getTagStories(tags.first.slug, page: 1);
      expect(tagStories, isNotEmpty);

      final searchStories = await source.search('Honeymoon', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 42 (DarkEroticaSource) all 8 contract methods', () async {
      final source = DarkEroticaSource();
      expect(source.id, equals('darkerotica'));
      expect(source.lang, equals('en'));

      final categories = await source.getCategories();
      expect(categories, isNotEmpty);
      final tags = await source.getTags();
      expect(tags, isNotEmpty);

      final feed = await source.getFeed(page: 1);
      expect(feed, isNotEmpty);

      final catStories = await source.getCategoryStories(categories.first.slug, page: 1);
      expect(catStories, isNotEmpty);

      final tagStories = await source.getTagStories(tags.first.slug, page: 1);
      expect(tagStories, isNotEmpty);

      final searchStories = await source.search('Vampire', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });
  });
}
