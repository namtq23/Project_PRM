import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_constants.dart';

/// Seeds the database with realistic sample data for development and testing.
abstract final class DatabaseSeeder {
  static Future<void> seed(Database db) async {
    final now = DateTime.now().toIso8601String();

    // --- Categories ---
    final categoryIds = <String, int>{};
    final categories = [
      {
        'title': 'Biển đảo',
        'description': 'Khám phá các bãi biển và hòn đảo tuyệt đẹp',
      },
      {'title': 'Leo núi', 'description': 'Chinh phục những đỉnh núi hùng vĩ'},
      {
        'title': 'Văn hóa',
        'description': 'Tìm hiểu văn hóa và lịch sử Việt Nam',
      },
      {
        'title': 'Ẩm thực',
        'description': 'Trải nghiệm ẩm thực địa phương đặc sắc',
      },
      {
        'title': 'Du thuyền',
        'description': 'Nghỉ dưỡng và khám phá trên du thuyền sang trọng',
      },
      {
        'title': 'Nghỉ dưỡng',
        'description': 'Thư giãn tại các khu nghỉ dưỡng cao cấp',
      },
    ];

    for (final cat in categories) {
      final id = await db.insert(DatabaseConstants.categoriesTable, {
        'title': cat['title'],
        'description': cat['description'],
        'created_at': now,
        'updated_at': now,
      });
      categoryIds[cat['title']!] = id;
    }

    // --- Shared Sample Data for detailed fields ---
    final sampleImages = [
      'https://images.unsplash.com/photo-1596422846543-74c6fc0e28f1', // Ha Long
      'https://images.unsplash.com/photo-1583417319070-4a69db38a482', // Sapa
      'https://images.unsplash.com/photo-1557315366-3197b1a03fb7', // Hoi An
      'https://images.unsplash.com/photo-1528127269322-539801943592', // Da Nang
      'https://images.unsplash.com/photo-1596422846543-74c6fc0e28f1',
    ];

    final sampleInclusions = [
      'Xe du lịch đời mới đưa đón theo lịch trình',
      'Khách sạn 4 sao (2 người/phòng)',
      'Vé tham quan các điểm trong chương trình',
      'Hướng dẫn viên chuyên nghiệp',
      'Bảo hiểm du lịch',
    ];

    final sampleExclusions = [
      'Chi phí cá nhân ngoài chương trình',
      'Thuế VAT',
      'Tiền tip cho HDV và tài xế',
    ];

    final sampleItinerary = [
      {
        'day': 1,
        'title': 'Đón khách & Tham quan',
        'description':
            'Xe và HDV đón quý khách tại điểm hẹn. Bắt đầu hành trình tham quan các điểm đến nổi bật trong ngày. Chiều nhận phòng khách sạn, tự do nghỉ ngơi.',
        'images': [sampleImages[0], sampleImages[1]],
      },
      {
        'day': 2,
        'title': 'Khám phá văn hóa & ẩm thực',
        'description':
            'Sau bữa sáng, đoàn khởi hành đi tham quan di tích lịch sử và trải nghiệm văn hóa địa phương. Thưởng thức đặc sản vùng miền vào bữa trưa.',
        'images': [sampleImages[2]],
      },
      {
        'day': 3,
        'title': 'Mua sắm & Chia tay',
        'description':
            'Tự do tham quan, mua sắm đặc sản về làm quà. Trả phòng khách sạn, xe đưa đoàn ra sân bay/nhà ga. Kết thúc chương trình.',
        'images': [sampleImages[3]],
      },
    ];

    // --- Tours ---
    final tours = [
      // Biển đảo
      {
        'category': 'Biển đảo',
        'title': 'Phú Quốc - Thiên Đường Biển Đảo 3N2Đ',
        'description':
            'Khám phá vẻ đẹp hoang sơ của Phú Quốc với bãi biển trắng mịn, nước biển trong xanh. Tour bao gồm tham quan làng chài, lặn ngắm san hô và thưởng thức hải sản tươi sống.',
        'price': 3500000.0,
        'duration_days': 3,
        'location_name': 'Phú Quốc',
      },
      {
        'category': 'Biển đảo',
        'title': 'Nha Trang - Vinpearl & Đảo Bà Nà 4N3Đ',
        'description':
            'Hành trình thư giãn tại Nha Trang kết hợp vui chơi tại Vinpearl Land. Tham quan Tháp Chàm, tắm bùn khoáng và du ngoạn đảo.',
        'price': 4200000.0,
        'duration_days': 4,
        'location_name': 'Nha Trang',
      },
      // ... Add a featured tour for Da Nang to match the Stitch design perfectly
      {
        'category': 'Văn hóa',
        'title': 'Kỳ quan Bà Nà Hills & Phố Cổ Hội An',
        'description':
            'Trải nghiệm sự kết hợp hoàn hảo giữa vẻ đẹp hiện đại và nét cổ kính của miền Trung Việt Nam. Từ những công trình kiến trúc kỳ vĩ tại Bà Nà Hills, vẻ đẹp yên bình của Bán đảo Sơn Trà đến không gian hoài cổ, rực rỡ sắc đèn lồng của Phố cổ Hội An.',
        'price': 3500000.0,
        'duration_days': 3,
        'location_name': 'TP. Đà Nẵng, Việt Nam',
        'images': [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCW6q3ToEe75F1OlpWA-ShlPaeMx6eajBD4t7r9m0CUWihr71yMvyPuk0f_qEbdVgnkfND72Dw5Jh1HVVjSjOnrqOEXUSUR9OhIU8jWHsFr7RMPRzhh-CVfZrimuwFvpNprPGb7f_VpQUwBGNjlIY4YOFbI0wsmBzizGZfDYKyAmV9mve-E3eHlj5EMPipaisgP6Z2131MTrhkQgdkIPYPC0nNvFQEGzhlH0CZd20Fx_fLjlOgGIZeL',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBVZWnCdKtzjVQ3YSddjOJxKekGWdTRceY-jty24w4UfQgZgmqL0zFZym4eawP_qDpJ3HNP1bnAF9cIGxq9EzxEUl4ZnSCY7gtSrsc9gvhWFjg9UDvI2OM7A1U_YpqAi-iAMSaKUrv4mJZB-pHrzO3gHlRyYDPCyRoXp88SbpAMXuBqC32bWefrJV5HBg1fG75kI0e6ZzMJgSeGrBrZfgi2BF9Qkzf0_EPAd0Am1FhB6G-KKfbThUvT',
        ],
        'itinerary': [
          {
            'day': 1,
            'title': 'Đà Nẵng - Bán Đảo Sơn Trà',
            'description':
                'Chào mừng bạn đến với Đà Nẵng. Đoàn khởi hành tham quan Linh Ứng Tự và ngắm hoàng hôn trên biển.',
            'images': [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCrJAlaxwv18BKKwWZigX8iRghVKJUaJwA9_onsDM9S18yENVc8OTVw3aAdALEWxaqyEqs7YTWrJLcg_bQsHzGBMZW9D1-qU-0KhsjO82ezGH0fpclzxL5Lr8-mb3wNlPtp32ETY57q5-uLor0M0qIRt_oj4NAAyjV0kfdRzsq1ZwvyIkFwlc-P6sd8JWS98FlST2xWPVgzllXVafPw3WHGJUc7EmjCeDBDsC0m_wvKzx0lAAWcTDAD',
            ],
          },
          {
            'day': 2,
            'title': 'Bà Nà Hills - Cầu Vàng',
            'description':
                'Cả ngày khám phá "Chốn bồng lai tiên cảnh" Bà Nà. Trải nghiệm hệ thống cáp treo đạt nhiều kỷ lục thế giới.',
          },
          {
            'day': 3,
            'title': 'Hội An - Chia tay',
            'description':
                'Tham quan Chùa Cầu, nhà cổ Tấn Ký và thưởng thức đặc sản Hội An trước khi kết thúc hành trình.',
          },
        ],
      },
      {
        'category': 'Leo núi',
        'title': 'Sapa - Nóc nhà Đông Dương 3N2Đ',
        'description':
            'Chinh phục đỉnh Fansipan, thăm bản Cát Cát và thưởng thức đặc sản vùng cao. Trải nghiệm không khí lạnh giá sương mù tuyệt đẹp.',
        'price': 2800000.0,
        'duration_days': 3,
        'location_name': 'Sapa, Lào Cai',
      },
      {
        'category': 'Văn hóa',
        'title': 'Khám phá Hà Nội Cổ Kính 1 Ngày',
        'description':
            'Hành trình 1 ngày tham quan Văn Miếu, Lăng Bác, Hồ Gươm và phố cổ Hà Nội.',
        'price': 850000.0,
        'duration_days': 1,
        'location_name': 'Hà Nội',
      },
      {
        'category': 'Du thuyền',
        'title': 'Du Thuyền Hạ Long 5 Sao 2N1Đ',
        'description':
            'Nghỉ dưỡng đẳng cấp trên du thuyền, thăm vịnh Hạ Long, hang Sửng Sốt, chèo kayak trên vịnh.',
        'price': 4500000.0,
        'duration_days': 2,
        'location_name': 'Hạ Long, Quảng Ninh',
      },
      {
        'category': 'Nghỉ dưỡng',
        'title': 'Đà Lạt - Thành Phố Ngàn Hoa 4N3Đ',
        'description':
            'Thư giãn tại Đà Lạt, tham quan Thung lũng tình yêu, đỉnh Langbiang, hái dâu tại vườn.',
        'price': 3200000.0,
        'duration_days': 4,
        'location_name': 'Đà Lạt, Lâm Đồng',
      },
      {
        'category': 'Ẩm thực',
        'title': 'Food Tour Hải Phòng Trong Ngày',
        'description':
            'Thưởng thức bánh đa cua, bún cá cay, bánh mì que và sủi dìn đặc trưng Hải Phòng.',
        'price': 600000.0,
        'duration_days': 1,
        'location_name': 'Hải Phòng',
      },
    ];

    for (final tour in tours) {
      final categoryId = categoryIds[tour['category'] as String];
      final duration = tour['duration_days'] as int;

      // Select appropriate itinerary based on duration
      final activeItinerary = tour.containsKey('itinerary')
          ? tour['itinerary']
          : sampleItinerary.take(duration).toList();

      await db.insert(DatabaseConstants.toursTable, {
        'category_id': categoryId,
        'title': tour['title'],
        'description': tour['description'],
        'price': tour['price'],
        'duration_days': tour['duration_days'],
        'status': 'active',
        'created_at': now,
        'updated_at': now,
        'max_group_size': 15,
        'languages': 'Việt, Anh',
        'cancellation_policy': 'Trước 24h',
        'location_name': tour['location_name'],
        'images': jsonEncode(
          tour.containsKey('images') ? tour['images'] : sampleImages,
        ),
        'inclusions': jsonEncode(sampleInclusions),
        'exclusions': jsonEncode(sampleExclusions),
        'itinerary': jsonEncode(activeItinerary),
      });
    }
  }
}
