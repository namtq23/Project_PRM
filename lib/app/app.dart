import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../features/profile/presentation/view_models/theme_mode_view_model.dart';

class TourBookingApp extends ConsumerWidget {
  const TourBookingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeViewModelProvider).asData?.value;
    return MaterialApp.router(
      title: 'VietTravel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode ?? ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
