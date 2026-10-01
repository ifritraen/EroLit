// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:erolit/features/sources/data/source_registry.dart';

void main() {
  test('Verify categories and tags across all 32 sources', () async {
    print('================================================================');
    print('TESTING CATEGORIES & TAGS ACROSS ALL 32 SOURCES');
    print('================================================================');

    final sources = SourceRegistry.initialSources;
    print('Total sources registered: ${sources.length}\n');

    final failureReport = <String, List<String>>{};

    for (int i = 0; i < sources.length; i++) {
      final s = sources[i];
      final num = (i + 1).toString().padLeft(2, '0');
      print('----------------------------------------------------');
      print('[$num/${sources.length}] Source: ${s.name} (${s.id}) - Lang: ${s.lang}');
      print('Base URL: ${s.baseUrl}');

      final issues = <String>[];

      // 1. Test Categories
      try {
        final cats = await s.getCategories();
        print('  -> Categories count: ${cats.length}');
        if (cats.isEmpty) {
          issues.add('Categories list is EMPTY');
          print('     [FAIL] No categories defined');
        } else {
          final testCat = cats.first;
          print('     Testing category: "${testCat.name}" (slug: ${testCat.slug})');
          try {
            final catStories = await s.getCategoryStories(testCat.slug, page: 1);
            print('     [RESULT] Found ${catStories.length} stories');
            if (catStories.isEmpty) {
              issues.add('Category "${testCat.slug}" returned 0 stories');
            }
          } catch (e) {
            print('     [ERROR] Category query failed: $e');
            issues.add('Category "${testCat.slug}" error: $e');
          }
        }
      } catch (e) {
        print('  [ERROR] getCategories() crashed: $e');
        issues.add('getCategories() crashed: $e');
      }

      // 2. Test Tags
      try {
        final tags = await s.getTags();
        print('  -> Tags count: ${tags.length}');
        if (tags.isEmpty) {
          issues.add('Tags list is EMPTY');
          print('     [FAIL] No tags defined');
        } else {
          final testTag = tags.first;
          print('     Testing tag: "${testTag.name}" (slug: ${testTag.slug})');
          try {
            final tagStories = await s.getTagStories(testTag.slug, page: 1);
            print('     [RESULT] Found ${tagStories.length} stories');
            if (tagStories.isEmpty) {
              issues.add('Tag "${testTag.slug}" returned 0 stories');
            }
          } catch (e) {
            print('     [ERROR] Tag query failed: $e');
            issues.add('Tag "${testTag.slug}" error: $e');
          }
        }
      } catch (e) {
        print('  [ERROR] getTags() crashed: $e');
        issues.add('getTags() crashed: $e');
      }

      if (issues.isNotEmpty) {
        failureReport[s.id] = issues;
      }
    }

    print('\n================================================================');
    print('DIAGNOSTIC SUMMARY REPORT');
    print('================================================================');
    print('Total Sources: ${sources.length}');
    print('Sources with issues: ${failureReport.length}');
    print('Sources working 100%: ${sources.length - failureReport.length}');
    print('----------------------------------------------------');
    failureReport.forEach((id, problems) {
      print('Source: $id');
      for (final p in problems) {
        print('   - $p');
      }
    });
  }, timeout: const Timeout(Duration(minutes: 5)));
}
