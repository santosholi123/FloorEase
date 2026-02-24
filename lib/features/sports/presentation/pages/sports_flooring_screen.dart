import 'package:flutter/material.dart';
import 'package:batch35_floorease/features/booking/presentation/pages/booking_stepper_screen.dart';
import 'package:batch35_floorease/features/dashboard/presentation/pages/home_screen.dart';

class SportFlooringScreen extends StatelessWidget {
  const SportFlooringScreen({super.key});

  static const Color _background = Color(0xFFF3FAF5);

  static const List<Map<String, String>> _paletteItems = [
    {
      'label': 'SP115',
      'url':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT826S-82821xO2C5-vDEuEH7cv3M8SJAK0HA&s',
    },
    {
      'label': 'SP-199-04',
      'url':
          'https://www.greatmats.com/images/ecore/athletic-vinyl-padded-roll-court-install-chestnut-wheat.jpg',
    },
    {
      'label': 'SP-199-06',
      'url':
          'https://thumbs.dreamstime.com/b/sports-balls-field-grass-copy-space-top-down-view-football-volleyball-basketball-soccer-ball-153164486.jpg',
    },
    {
      'label': 'SP8814',
      'url':
          'https://www.casalisport.com/media/immagini/2869_n_Ferrero_Sport_Village_8_560x380.jpg',
    },
    {
      'label': 'SP8809',
      'url':
          'https://media.tarkett-image.com/medium/IN_HP_Multiflex_M_8772001_8772002_002.jpg',
    },
    {
      'label': 'SP-199-05',
      'url':
          'https://gallantsports.in/wp-content/uploads/2025/01/Where-can-PVC-be-used_side-image.jpg',
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
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
                  Text('Color Palette', style: titleStyle),
                  const SizedBox(height: 12),
                  Text(
                    'We provide high performance sports flooring solutions across Nepal ideal for indoor courts, gyms, fitness centers, and multipurpose sports halls. Designed for durability, slip resistance, and athlete safety.',
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

class SportsFlooringScreen extends SportFlooringScreen {
  const SportsFlooringScreen({super.key});
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