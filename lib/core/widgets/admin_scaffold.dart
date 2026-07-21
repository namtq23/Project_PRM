import 'package:flutter/material.dart';
import 'admin_sidebar.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final String currentPath;
  final FloatingActionButton? floatingActionButton;
  final VoidCallback? onCreateTourPressed;

  const AdminScaffold({
    super.key,
    required this.body,
    required this.currentPath,
    this.floatingActionButton,
    this.onCreateTourPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        if (isDesktop) {
          return Scaffold(
            backgroundColor: const Color(0xFF0C1324),
            floatingActionButton: floatingActionButton,
            body: Row(
              children: [
                AdminSidebar(
                  currentPath: currentPath,
                  onCreateTourPressed: onCreateTourPressed,
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFF3E484F),
                ),
                Expanded(child: body),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: const Color(0xFF0C1324),
            drawer: Drawer(
              child: AdminSidebar(
                currentPath: currentPath,
                onCreateTourPressed: onCreateTourPressed,
              ),
            ),
            floatingActionButton: floatingActionButton,
            body: body,
          );
        }
      },
    );
  }
}
