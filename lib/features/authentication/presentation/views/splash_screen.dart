import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../widgets/auth_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/auth/ha_long_splash.jpg', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x22000000), Color(0x11000000), Color(0xB8001723)],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 38, 24, 28),
            child: Column(
              children: [
                const AuthLogo(size: 72, icon: Icons.explore_outlined),
                const SizedBox(height: 12),
                const Text(
                  'Khám phá',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'PREMIUM TRAVEL',
                  style: TextStyle(
                    color: Color(0xDDFFFFFF),
                    fontSize: 12,
                    letterSpacing: 2.6,
                  ),
                ),
                const Spacer(),
                const Text(
                  '“ Khám phá Việt Nam cùng chúng tôi ”',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 14),
                Container(width: 42, height: 2, color: AuthColors.primary),
                const Spacer(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: const Column(
                    children: [
                      LinearProgressIndicator(
                        value: .65,
                        minHeight: 3,
                        color: AuthColors.primary,
                        backgroundColor: Color(0x44FFFFFF),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Đang tải trải nghiệm của bạn...',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: 250,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => context.goNamed(RouteNames.login),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Bắt đầu hành trình'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AuthColors.primaryDark,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
