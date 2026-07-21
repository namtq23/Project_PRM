import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';

class TourBookingApp extends ConsumerWidget {
  const TourBookingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Tour Booking',
    debugShowCheckedModeBanner: false,
    routerConfig: ref.watch(appRouterProvider),
  );
}
