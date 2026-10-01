import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/feed/presentation/feed_screen.dart';
import '../../features/local/presentation/local_screen.dart';
import '../../features/navigation/scaffold_with_nav_bar.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/sources/presentation/sources_screen.dart';
import '../../features/sources/presentation/source_detail_screen.dart';
import '../../features/reader/views/reader_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _feedNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'feedNav');
final _sourcesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sourcesNav');
final _localNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'localNav');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settingsNav');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/feed',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Feed
          StatefulShellBranch(
            navigatorKey: _feedNavigatorKey,
            routes: [
              GoRoute(
                path: '/feed',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FeedScreen(),
                ),
              ),
            ],
          ),

          // Branch 2: Sources
          StatefulShellBranch(
            navigatorKey: _sourcesNavigatorKey,
            routes: [
              GoRoute(
                path: '/sources',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SourcesScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final sourceId = state.pathParameters['id']!;
                      return SourceDetailScreen(sourceId: sourceId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 3: Local
          StatefulShellBranch(
            navigatorKey: _localNavigatorKey,
            routes: [
              GoRoute(
                path: '/local',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: LocalScreen(),
                ),
              ),
            ],
          ),

          // Branch 4: Settings
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reader/:novelId',
        builder: (context, state) {
          final novelId = int.parse(state.pathParameters['novelId']!);
          final chapterIdStr = state.uri.queryParameters['chapterId'];
          final chapterId = chapterIdStr != null ? int.tryParse(chapterIdStr) : null;
          return ReaderScreen(novelId: novelId, chapterId: chapterId);
        },
      ),
    ],
  );
});
