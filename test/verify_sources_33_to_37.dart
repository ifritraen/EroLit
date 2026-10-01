@Timeout(Duration(minutes: 5))
library verify_sources_33_to_37;

// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/data/source_registry.dart';
import 'package:erolit/features/sources/implementations/source_33_bigcloset.dart';
import 'package:erolit/features/sources/implementations/source_34_bdsmlibrary.dart';
import 'package:erolit/features/sources/implementations/source_35_xnxxstories.dart';
import 'package:erolit/features/sources/implementations/source_36_asstr.dart';
import 'package:erolit/features/sources/implementations/source_37_theeroticlibrary.dart';

void main() {
  group('Verify Sources 33-37 in SourceRegistry', () {
    test('Registry contains all 37 sources', () {
      expect(SourceRegistry.initialSources.length, equals(37));
      expect(SourceRegistry.getSourceById('bigcloset'), isNotNull);
      expect(SourceRegistry.getSourceById('bdsmlibrary'), isNotNull);
      expect(SourceRegistry.getSourceById('xnxxstories'), isNotNull);
      expect(SourceRegistry.getSourceById('asstr'), isNotNull);
      expect(SourceRegistry.getSourceById('theeroticlibrary'), isNotNull);
    });

    test('Source 33 (BigClosetSource) all 8 contract methods', () async {
      final source = BigClosetSource();
      expect(source.id, equals('bigcloset'));
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

      final searchStories = await source.search('Amber', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 34 (BDSMLibrarySource) all 8 contract methods', () async {
      final source = BDSMLibrarySource();
      expect(source.id, equals('bdsmlibrary'));
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

      final searchStories = await source.search('Governess', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 35 (XnxxStoriesSource) all 8 contract methods', () async {
      final source = XnxxStoriesSource();
      expect(source.id, equals('xnxxstories'));
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

      final searchStories = await source.search('Neighbor', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 36 (AsstrSource) all 8 contract methods', () async {
      final source = AsstrSource();
      expect(source.id, equals('asstr'));
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

      final searchStories = await source.search('Seduction', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });

    test('Source 37 (TheEroticLibrarySource) all 8 contract methods', () async {
      final source = TheEroticLibrarySource();
      expect(source.id, equals('theeroticlibrary'));
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

      final searchStories = await source.search('Fanny', page: 1);
      expect(searchStories, isNotEmpty);

      final details = await source.getStoryDetails(feed.first.url);
      expect(details.title, isNotEmpty);
      expect(details.chapters, isNotEmpty);

      final content = await source.getChapterContent(details.chapters.first.url);
      expect(content, isNotEmpty);
    });
  });
}
