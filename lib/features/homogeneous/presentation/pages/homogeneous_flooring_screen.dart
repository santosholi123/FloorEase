import 'package:flutter/material.dart';
import 'package:batch35_floorease/features/booking/presentation/pages/booking_stepper_screen.dart';
import 'package:batch35_floorease/features/dashboard/presentation/pages/home_screen.dart';

class HomogeneousFlooringScreen extends StatelessWidget {
  const HomogeneousFlooringScreen({super.key});

  static const Color _background = Color(0xFFF3FAF5);

  static const List<Map<String, String>> _paletteItems = [
    {
      'label': '25024',
      'url':
          'https://www.floorcity.com/cdn/shop/products/5A074_1C_1d9ab8e3-9307-47be-b58c-d8fe0f792b0b.jpg?v=1570179186',
    },
    {
      'label': '25034',
      'url':
          'https://archipro.co.nz/images/cdn-images/width%3D3840%2Cquality%3D90/images/s1/product/vinyl-flooring/Armstrong-Accolade-PlusIronbark5A503611Revit.jpg/eyJlZGl0cyI6W3sidHlwZSI6InpwY2YiLCJvcHRpb25zIjp7ImJveFdpZHRoIjoxMjAwLCJib3hIZWlnaHQiOjEyMDAsInpvb21XaWR0aCI6MTIwMCwic2Nyb2xsUG9zWCI6NTAsInNjcm9sbFBvc1kiOjUwLCJiYWNrZ3JvdW5kIjoicmdiKDEyOCwxMTgsMTA4KSIsImZpbHRlciI6MH19XSwicXVhbGl0eSI6ODd9',
    },
    {
      'label': '25047',
      'url':
          'https://www.armstrongflooring.au/cdn/shop/files/20241029P_Armstrong_Accolade2_BegaValley_014_2048x_crop_center.jpg?v=1731548833',
    },
    {
      'label': '8915',
      'url':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcBWHMcvpCWhQDHlV0dQiSc4mNnNUcCn81XA&s',
    },
    {
      'label': 'CN-2301',
      'url':
          'https://skilledfloors.com.au/wp-content/uploads/2018/06/Armstrong-Quantum-5B504301-300x300.jpg',
    },
    {
      'label': 'CN-2306',
      'url':
          'https://www.cainbultman.com/wp-content/uploads/2023/12/TH_21010672_21011672_21014672_800_800.jpg',
    },
  ];

  int _calculateColumns(double width) {
    if (width >= 1100) return 4;
    if (width >= 700) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = _calculateColumns(constraints.maxWidth);
            final horizontalPadding = constraints.maxWidth >= 900 ? 32.0 : 20.0;
            final titleStyle = Theme.of(context).textTheme.headlineSmall
                ?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2A24),
                );
            final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4A5A52),
              height: 1.4,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackButton(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Color Palette', style: titleStyle),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _paletteItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = _paletteItems[index];
                      return _PaletteCard(
                        imageUrl: item['url']!,
                        label: item['label']!,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Homogeneous vinyl flooring is durable, antibacterial, eco-friendly, and easy to maintain. Its flexible designs and strong wear resistance make it suitable for high-traffic areas like hospitals, care centers, schools, transport hubs, offices, malls, and factories.',
                    style: bodyStyle,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookingStepperScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F7A4D),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: Color(0xFF1F2A24)),
      ),
    );
  }
}

class _PaletteCard extends StatelessWidget {
  const _PaletteCard({required this.imageUrl, required this.label});

  final String imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: const Color(0xFFE8F2EC),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: const Color(0xFF1F7A4D),
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE8F2EC),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF7A8A82),
                  ),
                );
              },
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//