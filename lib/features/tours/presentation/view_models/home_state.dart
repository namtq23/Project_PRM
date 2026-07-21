import 'package:equatable/equatable.dart';

import '../../models/category_model.dart';
import '../../models/tour_model.dart';

class HomeState extends Equatable {
  final List<Category> categories;
  final List<Tour> featuredTours;

  const HomeState({this.categories = const [], this.featuredTours = const []});

  HomeState copyWith({List<Category>? categories, List<Tour>? featuredTours}) {
    return HomeState(
      categories: categories ?? this.categories,
      featuredTours: featuredTours ?? this.featuredTours,
    );
  }

  @override
  List<Object?> get props => [categories, featuredTours];
}
