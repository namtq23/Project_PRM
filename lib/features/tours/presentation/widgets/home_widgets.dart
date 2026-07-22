import 'package:flutter/material.dart';

class TourPreview {
  const TourPreview({
    required this.tourId,
    required this.title,
    required this.location,
    required this.price,
    required this.basePrice,
    required this.image,
  });
  final int tourId;
  final String title;
  final String location;
  final String price;
  final double basePrice;
  final String image;
}

const featuredTours = [
  TourPreview(
    tourId: 1,
    title: 'Trải nghiệm nghỉ dưỡng 5 sao Sunset Sanato',
    location: 'Phú Quốc, Kiên Giang',
    price: '3.500.000đ / người',
    basePrice: 3500000,
    image: 'assets/images/tours/phu_quoc.jpg',
  ),
  TourPreview(
    tourId: 2,
    title: 'Khám phá Cầu Vàng Bà Nà Hills & Phố cổ Hội An',
    location: 'Đà Nẵng',
    price: '1.250.000đ / người',
    basePrice: 1250000,
    image: 'assets/images/tours/da_nang.jpg',
  ),
  TourPreview(
    tourId: 3,
    title: 'Mùa lúa chín Mù Cang Chải - Kỳ quan ruộng bậc thang',
    location: 'Yên Bái',
    price: '2.800.000đ / người',
    basePrice: 2800000,
    image: 'assets/images/tours/mu_cang_chai.jpg',
  ),
];

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 260,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      image: const DecorationImage(
        image: AssetImage('assets/images/tours/home_hero.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x11000000), Color(0xB8000000)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Khám phá vẻ đẹp Việt Nam',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            readOnly: true,
            onTap: () {},
            decoration: InputDecoration(
              hintText: 'Bạn muốn đi đâu?',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    required this.title,
    required this.action,
    super.key,
  });
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      TextButton(onPressed: () {}, child: Text(action)),
    ],
  );
}

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});
  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _CategoryChip(label: 'Tất cả', icon: Icons.grid_view, selected: true),
        _CategoryChip(label: 'Biển đảo', icon: Icons.beach_access_outlined),
        _CategoryChip(label: 'Núi rừng', icon: Icons.landscape_outlined),
        _CategoryChip(label: 'Văn hóa', icon: Icons.temple_buddhist_outlined),
        _CategoryChip(label: 'Ẩm thực', icon: Icons.restaurant_outlined),
      ],
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    this.selected = false,
  });
  final String label;
  final IconData icon;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: selected,
        onSelected: (_) {},
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selectedColor: colors.primary,
        checkmarkColor: colors.onPrimary,
        labelStyle: TextStyle(
          color: selected ? colors.onPrimary : colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class TourCard extends StatelessWidget {
  const TourCard({required this.tour, required this.onBook, super.key});
  final TourPreview tour;
  final VoidCallback onBook;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(tour.image, fit: BoxFit.cover),
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Color(0xE6FFFFFF),
                  child: Icon(Icons.favorite_border, color: Color(0xFFEF4444)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tour.location,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tour.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tour.price,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onBook,
                      child: const Text('Đặt ngay'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationGrid extends StatelessWidget {
  const DestinationGrid({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth >= 700
          ? (constraints.maxWidth - 12) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: width,
            child: const _DestinationTile(
              name: 'Đà Lạt',
              subtitle: 'Thành phố sương mù',
              image: 'assets/images/tours/da_lat.jpg',
            ),
          ),
          SizedBox(
            width: width,
            child: const _DestinationTile(
              name: 'Hội An',
              subtitle: 'Phố cổ đèn lồng',
              image: 'assets/images/tours/hoi_an.jpg',
            ),
          ),
          SizedBox(
            width: width,
            child: const _DestinationTile(
              name: 'Ninh Bình',
              subtitle: 'Vịnh Hạ Long trên cạn',
              image: 'assets/images/tours/ninh_binh.jpg',
            ),
          ),
        ],
      );
    },
  );
}

class _DestinationTile extends StatelessWidget {
  const _DestinationTile({
    required this.name,
    required this.subtitle,
    required this.image,
  });
  final String name;
  final String subtitle;
  final String image;
  @override
  Widget build(BuildContext context) => Container(
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0xC0000000)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle.toUpperCase(),
            style: const TextStyle(
              color: Color(0xDDFFFFFF),
              fontSize: 10,
              letterSpacing: 1.1,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
