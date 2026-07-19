import 'package:flutter/material.dart';

class RoutePlaceholderScreen extends StatelessWidget {
  const RoutePlaceholderScreen({required this.title, this.details, super.key});

  final String title;
  final String? details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              if (details case final details?) ...[
                const SizedBox(height: 8),
                Text(details, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
