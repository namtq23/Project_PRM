import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as mobile_sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_constants.dart';

part 'app_database.g.dart';

class AppDatabase {
  AppDatabase({
    DatabaseFactory? factory,
    String? databasePath,
    this.seedDemoData = kDebugMode,
  }) : _factoryOverride = factory,
       _databasePathOverride = databasePath;

  final DatabaseFactory? _factoryOverride;
  final String? _databasePathOverride;
  final bool seedDemoData;
  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final DatabaseFactory factory;
    final String databasePath;

    if (_factoryOverride != null) {
      factory = _factoryOverride;
      databasePath = _databasePathOverride ?? DatabaseConstants.databaseName;
    } else if (kIsWeb) {
      factory = databaseFactoryFfiWebNoWebWorker;
      databasePath = DatabaseConstants.databaseName;
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      factory = mobile_sqflite.databaseFactory;
      final databasesDirectory = await factory.getDatabasesPath();
      databasePath = path.join(
        databasesDirectory,
        DatabaseConstants.databaseName,
      );
    } else {
      sqfliteFfiInit();
      factory = databaseFactoryFfi;
      final databasesDirectory = await factory.getDatabasesPath();
      databasePath = path.join(
        databasesDirectory,
        DatabaseConstants.databaseName,
      );
    }
    final database = await factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: DatabaseConstants.databaseVersion,
        onConfigure: (database) => database.execute('PRAGMA foreign_keys = ON'),
        onCreate: (database, _) => _createSchema(database),
        onUpgrade: (database, oldVersion, _) async {
          if (oldVersion < 2) await _createSchema(database);
          if (oldVersion < 3) {
            await database.execute('DROP TABLE IF EXISTS tours');
            await database.execute('DROP TABLE IF EXISTS categories');
            for (final statement in DatabaseConstants.allTables) {
              await database.execute(statement);
            }
          }
          if (oldVersion < 4) {
            await database.execute('DROP TABLE IF EXISTS reviews');
            await database.execute(DatabaseConstants.createReviewsTable);
          }
          if (oldVersion < 6) {
            await database.execute('DELETE FROM bookings');
            await database.execute('DELETE FROM reviews');
            await database.execute('DELETE FROM tours');
            await database.execute('DELETE FROM categories');
          }
        },
      ),
    );

    if (seedDemoData) {
      await _seedAdmin(database);
      await _seedDemoCategories(database);
      await _seedDemoTours(database);
      await _seedDemoBookings(database);
      await _seedDemoReviews(database);
    }

    return database;
  }

  Future<void> _createSchema(Database database) async {
    for (final statement in DatabaseConstants.allTables) {
      await database.execute(statement);
    }
    for (final statement in DatabaseConstants.allIndexes) {
      await database.execute(statement);
    }
  }

  Future<void> _seedAdmin(Database database) async {
    final nowString = DateTime.now().toUtc().toIso8601String();
    await database.execute('''
      INSERT OR IGNORE INTO users (
        email, password_hash, full_name, role, status, auth_provider, created_at, updated_at
      ) VALUES (
        'hoanganh2k52@gmail.com',
        '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
        'Hoàng Anh',
        'admin',
        'active',
        'local',
        '$nowString',
        '$nowString'
      )
    ''');
    await database.execute('''
      UPDATE users SET role = 'admin' WHERE email = 'hoanganh2k52@gmail.com'
    ''');
  }

  Future<void> _seedDemoCategories(Database database) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.execute('DELETE FROM categories');
    await database.execute('''
      INSERT OR IGNORE INTO categories (id, title, short_name, description, icon, image_url, status, created_at, updated_at) VALUES
      (1, 'Thượng Lưu & Dưỡng', 'Resort 5 Sao', 'Kỳ nghỉ dưỡng cao cấp 5 sao tại các khu resort đắt giá nhất.', 'luxury-gold', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?q=80&w=600', 'active', '$now', '$now'),
      (2, 'Khám Phá & Trải Nghiệm', 'Trải Nghiệm', 'Trekking, chinh phục thiên nhiên hoang sơ và núi rừng.', 'adventure-cyan', 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600', 'active', '$now', '$now'),
      (3, 'Văn Hóa & Di Sản', 'Di Sản', 'Hành trình tìm hiểu lịch sử, kiến trúc và di tích danh thắng.', 'heritage-amber', 'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?q=80&w=600', 'active', '$now', '$now'),
      (4, 'Ẩm Thực & Phố Cổ', 'Gourmet', 'Tour trải nghiệm văn hóa ẩm thực đặc sắc từng vùng miền.', 'gourmet-red', 'https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=600', 'active', '$now', '$now'),
      (5, 'Biển Đảo Kỳ Thú', 'Biển Đảo', 'Hành trình vi vu các thiên đường biển đảo nhiệt đới.', 'ocean-blue', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=600', 'active', '$now', '$now')
    ''');
  }

  Future<void> _seedDemoTours(Database database) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.execute('DELETE FROM tours');
    final demoTours = <Map<String, Object?>>[
      {
        'id': 1,
        'category_id': 1,
        'title': 'Tour Du Thuyền 5 Sao Vịnh Hạ Long - Lan Hạ (2N1Đ)',
        'description': 'Trải nghiệm ngủ đêm sang trọng trên vịnh biển di sản với du thuyền 5 sao chuẩn quốc tế.',
        'price': 3850000.0,
        'duration_days': 2,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 2,
        'category_id': 3,
        'title': 'Hành Trình Di Sản Miền Trung: Đà Nẵng - Hội An - Huế (4N3Đ)',
        'description': 'Chiêm ngưỡng di sản văn hóa cổ kính, phố cổ Hội An lộng lẫy và cố đô Huế trang nghiêm.',
        'price': 5990000.0,
        'duration_days': 4,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 3,
        'category_id': 5,
        'title': 'Khám Phá Thiên Đường Biển Đảo Phú Quốc (3N2Đ)',
        'description': 'Tận hưởng kỳ nghỉ nhiệt đới, câu cá lặn ngắm san hô tại Nam Đảo và check-in Sunset Sanato.',
        'price': 4200000.0,
        'duration_days': 3,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1583417267826-aebc4d1543e5?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 4,
        'category_id': 2,
        'title': 'Sapa - Chinh Phục Đỉnh Fansipan - Cát Cát (3N2Đ)',
        'description': 'Hành trình khám phá Tây Bắc, trekking bản Cát Cát và đi cáp treo chinh phục nóc nhà Đông Dương.',
        'price': 3250000.0,
        'duration_days': 3,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1540611025311-01df3cef54b5?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 5,
        'category_id': 4,
        'title': 'Tour Trải Nghiệm Miền Tây River Life: Cần Thơ - Bến Tre (2N1Đ)',
        'description': 'Hòa mình vào cuộc sống sông nước miền Tây, du ngoạn chợ nổi Cái Răng và thưởng thức trái cây miệt vườn.',
        'price': 1890000.0,
        'duration_days': 2,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 6,
        'category_id': 3,
        'title': 'Cố Đô Hà Nội - Ninh Bình - Tràng An (1 Ngày)',
        'description': 'Khám phá văn hóa cố đô Hoa Lư, đi thuyền trôi dòng Tràng An kỳ vĩ và viếng chùa Bái Đính.',
        'price': 950000.0,
        'duration_days': 1,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1509060464153-4466739f7840?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 7,
        'category_id': 2,
        'title': 'Trekking Tà Xùa - Săn Mây Đại Ngàn (2N1Đ)',
        'description': 'Chinh phục sống lưng khủng long Tà Xùa hoang sơ, săn biển mây bồng bềnh giữa núi rừng Sơn La.',
        'price': 2450000.0,
        'duration_days': 2,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 8,
        'category_id': 1,
        'title': 'Tour Cao Cấp: Khám Phá Mùa Thu Nhật Bản (5N4Đ)',
        'description': 'Kỳ nghỉ dưỡng thượng lưu ngắm lá đỏ Momiji tại Tokyo - Núi Phú Sĩ - Kyoto sang trọng.',
        'price': 28900000.0,
        'duration_days': 5,
        'status': 'active',
        'firestore_id': 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?q=80&w=1000',
        'created_at': now,
        'updated_at': now,
      },
    ];

    for (final tour in demoTours) {
      await database.insert(
        DatabaseConstants.toursTable,
        tour,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _seedDemoBookings(Database database) async {
    await database.execute('DELETE FROM bookings');
    
    // Seed some users so we have more than 1 user for average ticket/LTV calculation
    await database.execute('''
      INSERT OR IGNORE INTO users (id, email, password_hash, full_name, role, status, auth_provider, avatar_url, created_at, updated_at) VALUES
      (2, 'user1@gmail.com', 'hash', 'Nguyễn Văn Nam', 'user', 'active', 'local', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
      (3, 'user2@gmail.com', 'hash', 'Trần Thị Mai', 'user', 'active', 'local', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
      (4, 'user3@gmail.com', 'hash', 'Lê Hoàng Long', 'user', 'active', 'local', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
      (5, 'user4@gmail.com', 'hash', 'Phạm Minh Anh', 'user', 'active', 'local', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z')
    ''');

    final demoBookings = <Map<String, Object?>>[
      // Month 1 (Jan)
      {
        'id': 1,
        'user_id': 2,
        'tour_id': 5, // Miền Tây (1.89M)
        'booking_date': '2026-01-10T12:00:00Z',
        'total_cost': 3780000.0, // 2 passengers
        'payment_method': 'Credit Card',
        'status': 'completed',
        'passenger_quantity': 2,
        'created_at': '2026-01-10T12:00:00Z',
        'updated_at': '2026-01-10T12:00:00Z',
      },
      // Month 2 (Feb)
      {
        'id': 2,
        'user_id': 3,
        'tour_id': 7, // Tà Xùa (2.45M)
        'booking_date': '2026-02-14T09:00:00Z',
        'total_cost': 2450000.0,
        'payment_method': 'Bank Transfer',
        'status': 'completed',
        'passenger_quantity': 1,
        'created_at': '2026-02-14T09:00:00Z',
        'updated_at': '2026-02-14T09:00:00Z',
      },
      // Month 3 (Mar)
      {
        'id': 3,
        'user_id': 4,
        'tour_id': 1, // Hạ Long (3.85M)
        'booking_date': '2026-03-05T15:30:00Z',
        'total_cost': 3850000.0,
        'payment_method': 'Bank Transfer',
        'status': 'confirmed',
        'passenger_quantity': 1,
        'created_at': '2026-03-05T15:30:00Z',
        'updated_at': '2026-03-05T15:30:00Z',
      },
      // Month 4 (Apr)
      {
        'id': 4,
        'user_id': 2,
        'tour_id': 6, // Hà Nội (950k)
        'booking_date': '2026-04-18T14:20:00Z',
        'total_cost': 2850000.0, // 3 passengers
        'payment_method': 'Credit Card',
        'status': 'completed',
        'passenger_quantity': 3,
        'created_at': '2026-04-18T14:20:00Z',
        'updated_at': '2026-04-18T14:20:00Z',
      },
      // Month 5 (May)
      {
        'id': 5,
        'user_id': 3,
        'tour_id': 5, // Miền Tây
        'booking_date': '2026-05-22T10:00:00Z',
        'total_cost': 1890000.0,
        'payment_method': 'Credit Card',
        'status': 'cancelled',
        'passenger_quantity': 1,
        'created_at': '2026-05-22T10:00:00Z',
        'updated_at': '2026-05-22T10:00:00Z',
      },
      // Month 6 (Jun)
      {
        'id': 6,
        'user_id': 5,
        'tour_id': 7, // Tà Xùa
        'booking_date': '2026-06-12T11:45:00Z',
        'total_cost': 4900000.0, // 2 passengers
        'payment_method': 'Bank Transfer',
        'status': 'completed',
        'passenger_quantity': 2,
        'created_at': '2026-06-12T11:45:00Z',
        'updated_at': '2026-06-12T11:45:00Z',
      },
      // Month 7 (Jul)
      {
        'id': 7,
        'user_id': 2,
        'tour_id': 3, // Phú Quốc (4.2M)
        'booking_date': '2026-07-20T16:00:00Z',
        'total_cost': 8400000.0, // 2 passengers
        'payment_method': 'Bank Transfer',
        'status': 'pending',
        'passenger_quantity': 2,
        'created_at': '2026-07-20T16:00:00Z',
        'updated_at': '2026-07-20T16:00:00Z',
      },
    ];

    for (final booking in demoBookings) {
      await database.insert(
        DatabaseConstants.bookingsTable,
        booking,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _seedDemoReviews(Database database) async {
    await database.execute('DELETE FROM reviews');
    final now = DateTime.now().toUtc().toIso8601String();
    final demoReviews = <Map<String, Object?>>[
      {
        'id': 1,
        'user_id': 2, // Nguyễn Văn Nam
        'tour_id': 1, // Hạ Long Vịnh Lan Hạ
        'rating': 5,
        'comment': 'Dịch vụ du thuyền tuyệt vời, đồ ăn tươi ngon và nhân viên phục vụ rất chu đáo! Tôi chắc chắn sẽ quay lại.',
        'status': 'approved',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 2,
        'user_id': 3, // Trần Thị Mai
        'tour_id': 4, // Sapa Fansipan
        'rating': 5,
        'comment': 'Chuyến đi Sapa săn mây rất đẹp, hướng dẫn viên nhiệt tình, hỗ trợ đoàn rất chu đáo suốt hành trình.',
        'status': 'approved',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 3,
        'user_id': 4, // Lê Hoàng Long
        'tour_id': 3, // Phú Quốc
        'rating': 4,
        'comment': 'Cần cải thiện chất lượng xe đưa đón một chút nhưng tổng thể dịch vụ khách sạn và lịch trình vẫn rất đáng tiền.',
        'status': 'approved',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 4,
        'user_id': 5, // Phạm Minh Anh
        'tour_id': 2, // Đà Nẵng Hội An Huế
        'rating': 5,
        'comment': 'Khách sạn trung tâm tiện lợi, các điểm di sản rất đẹp và mang nhiều giá trị lịch sử Việt Nam.',
        'status': 'pending',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 5,
        'user_id': 2, // Nguyễn Văn Nam
        'tour_id': 7, // Tà Xùa
        'rating': 5,
        'comment': 'Trekking Tà Xùa mệt nhưng ngắm được biển mây cực kỳ mãn nhãn và đáng nhớ.',
        'status': 'flagged',
        'created_at': now,
        'updated_at': now,
      },
    ];

    for (final review in demoReviews) {
      await database.insert(
        DatabaseConstants.reviewsTable,
        review,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> close() async {
    final database = _database;
    _database = null;
    await database?.close();
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();
