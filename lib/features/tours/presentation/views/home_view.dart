import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/home_view_model.dart';
import '../widgets/category_chip.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/tour_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: homeStateAsync.when(
        data: (homeState) {
          return RefreshIndicator(
            onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Discover Tours'),
                    background: Container(
                      color: const Color(0xFF0EA5E9),
                      child: const Center(
                        child: Icon(
                          Icons.travel_explore,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.search,
                                color: Color(0xFF64748B),
                              ),
                              hintText: 'Where do you want to go?',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Categories
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (homeState.categories.isEmpty)
                          const Text('No categories found.')
                        else
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homeState.categories.length,
                              itemBuilder: (context, index) {
                                final category = homeState.categories[index];
                                return CategoryChip(
                                  category: category,
                                  isSelected: index == 0,
                                  onTap: () {
                                    // Handle category selection
                                  },
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 32),

                        // Featured Tours
                        const Text(
                          'Featured Tours',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (homeState.featuredTours.isEmpty)
                          const Text('No featured tours found.')
                        else
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homeState.featuredTours.length,
                              itemBuilder: (context, index) {
                                final tour = homeState.featuredTours[index];
                                return TourCard(
                                  tour: tour,
                                  onTap: () {
                                    // Handle tour selection
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const HomeSkeleton(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load data\n${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(homeViewModelProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
