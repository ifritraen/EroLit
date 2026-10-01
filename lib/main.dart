import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: EroLitApp(),
    ),
  );
}

class EroLitApp extends ConsumerWidget {
  const EroLitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    ThemeData activeTheme;
    switch (themeMode) {
      case AppThemeMode.light:
        activeTheme = AppTheme.lightTheme;
        break;
      case AppThemeMode.dark:
        activeTheme = AppTheme.darkTheme;
        break;
      case AppThemeMode.oled:
        activeTheme = AppTheme.oledTheme;
        break;
      case AppThemeMode.system:
        activeTheme = AppTheme.darkTheme;
        break;
    }

    return MaterialApp.router(
      title: 'EroLit',
      debugShowCheckedModeBanner: false,
      theme: activeTheme,
      routerConfig: router,
    );
  }
}
