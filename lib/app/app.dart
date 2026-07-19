import 'package:flutter/material.dart';

import 'router/app_router.dart';

class TourBookingApp extends StatelessWidget {
  const TourBookingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Tour Booking',
    debugShowCheckedModeBanner: false,
    routerConfig: appRouter,
  );
}
