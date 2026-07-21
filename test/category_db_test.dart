import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/core/database/app_database.dart';
import 'package:project_prm/features/admin/content_management/manage_categories/data/data_sources/category_local_data_source.dart';
import 'package:project_prm/features/admin/content_management/manage_categories/models/category_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Verify Category CRUD operations in SQLite', () async {
    final appDb = AppDatabase(databasePath: inMemoryDatabasePath, seedDemoData: false);
    final dataSource = CategoryLocalDataSource(appDb);

    // 1. Fetch initially (should be empty because seedDemoData is false)
    final initialCategories = await dataSource.fetchAllCategories();
    expect(initialCategories.length, equals(0));

    // 2. Insert Category
    final newCat = CategoryModel(
      title: 'Khám Phá Biển Sâu',
      shortName: 'Biển Sâu',
      description: 'Trải nghiệm lặn biển cao cấp',
      icon: 'explore',
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5',
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final id = await dataSource.insertCategory(newCat);
    expect(id, isNotNull);

    // 3. Fetch list and verify
    final categories = await dataSource.fetchAllCategories();
    expect(categories.length, equals(1));
    expect(categories.first.title, equals('Khám Phá Biển Sâu'));
    expect(categories.first.shortName, equals('Biển Sâu'));
    expect(categories.first.status, equals('active'));

    // 4. Update Category
    final addedCat = categories.first;
    final updatedCat = addedCat.copyWith(
      title: 'Khám Phá Biển Sâu Siêu Cấp',
      status: 'inactive',
    );
    final count = await dataSource.updateCategory(updatedCat);
    expect(count, equals(1));

    // Verify update
    final updatedCategories = await dataSource.fetchAllCategories();
    expect(updatedCategories.first.title, equals('Khám Phá Biển Sâu Siêu Cấp'));
    expect(updatedCategories.first.status, equals('inactive'));

    // 5. Delete Category
    final deleteCount = await dataSource.deleteCategory(id);
    expect(deleteCount, equals(1));

    // Verify deletion
    final finalCategories = await dataSource.fetchAllCategories();
    expect(finalCategories.length, equals(0));

    await appDb.close();
  });
}
