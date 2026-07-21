import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'admin_scaffold.dart';

class RoutePlaceholderScreen extends StatelessWidget {
  const RoutePlaceholderScreen({required this.title, this.details, super.key});

  final String title;
  final String? details;

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isAdminRoute = currentPath.startsWith('/admin');

    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF8ED5FF),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              details ?? 'Trang này đang trong quá trình phát triển.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFBDC8D1), fontSize: 14),
            ),
          ],
        ),
      ),
    );

    if (isAdminRoute) {
      return AdminScaffold(
        currentPath: currentPath,
        body: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0C1324),
            elevation: 0,
            title: Text(
              title,
              style: const TextStyle(color: Color(0xFFDCE1FB)),
            ),
          ),
          body: content,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    );
  }
}
