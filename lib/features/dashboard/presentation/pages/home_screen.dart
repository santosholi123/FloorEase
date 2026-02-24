import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:batch35_floorease/features/profile/presentation/pages/profile_screen.dart';
import 'package:batch35_floorease/features/booking/presentation/pages/booking_stepper_screen.dart';
import 'package:batch35_floorease/features/homogeneous/presentation/pages/homogeneous_flooring_screen.dart';
import 'package:batch35_floorease/features/heterogeneous/presentation/pages/heterogeneous_flooring_screen.dart';
import 'package:batch35_floorease/features/sports/presentation/pages/sports_flooring_screen.dart';
import 'package:batch35_floorease/features/profile/presentation/provider/profile_provider.dart';
import 'package:batch35_floorease/core/services/gyroscope_tilt_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables for each card's image URL
  String? homogeneousImageUrl = 'assets/images/homogeneous.png';
  String? heterogeneousImageUrl = 'assets/images/heterogeneous.png';
  String? sportsImageUrl = 'assets/images/sports.png';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Shake-to-refresh accelerometer integration
  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime? _lastShakeTime;
  static const Duration _shakeCooldown = Duration(seconds: 2);
  static const double _shakeThreshold = 15.0;

  // Gyroscope tilt parallax service
  final GyroscopeTiltService _gyroscopeService = GyroscopeTiltService();

  // Accelerometer tilt effect for cards
  double tiltX = 0.0;
  double tiltY = 0.0;

  // Hands-free browsing: tilt scroll controller
  final ScrollController _scrollController = ScrollController();
  DateTime? _lastScrollUpdate;
  double _smoothedTiltX = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
    _startAccelerometerListener();
    _gyroscopeService.start();
  }

  void _startAccelerometerListener() {
    _accelSub = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        _detectShake(event);
        _handleTiltScroll(event);
        _handleTiltEffect(event);
      },
      onError: (error) {
        debugPrint('Accelerometer error: $error');
      },
    );
  }

  void _handleTiltEffect(AccelerometerEvent event) {
    setState(() {
      // Normalize with division
      double dx = event.x / 9.8;
      double dy = event.y / 9.8;

      // Clamp between -0.35 and 0.35
      dx = dx.clamp(-0.35, 0.35);
      dy = dy.clamp(-0.35, 0.35);

      // Apply smoothing
      tiltX = tiltX * 0.85 + dx * 0.15;
      tiltY = tiltY * 0.85 + dy * 0.15;
    });
  }

  void _handleTiltScroll(AccelerometerEvent event) {
    // Throttle updates to every 40ms
    final now = DateTime.now();
    if (_lastScrollUpdate != null &&
        now.difference(_lastScrollUpdate!).inMilliseconds < 40) {
      return;
    }
    _lastScrollUpdate = now;

    // Skip if scroll controller not attached
    if (!_scrollController.hasClients) return;

    // Normalize acceleration
    double rawTiltX = event.x / 9.8;

    // Apply low-pass filter for smoothing (alpha = 0.12)
    const double alpha = 0.12;
    _smoothedTiltX = _smoothedTiltX + alpha * (rawTiltX - _smoothedTiltX);

    // Apply deadzone to ignore tiny movements
    double tiltValue = _smoothedTiltX;
    if (tiltValue.abs() < 0.05) {
      tiltValue = 0.0;
    }

    // Convert tilt to scroll delta
    double scrollDelta = tiltValue * 120;

    // Clamp scroll speed per tick between -18 and +18 pixels
    scrollDelta = scrollDelta.clamp(-18.0, 18.0);

    // Calculate new position
    double currentPosition = _scrollController.position.pixels;
    double newPosition = currentPosition + scrollDelta;

    // Clamp within bounds
    double maxExtent = _scrollController.position.maxScrollExtent;
    newPosition = newPosition.clamp(0.0, maxExtent);

    // Apply scroll if delta is significant
    if (scrollDelta.abs() > 0.1) {
      _scrollController.jumpTo(newPosition);
    }
  }

  void _detectShake(AccelerometerEvent event) {
    // Check if any axis exceeds threshold
    final bool isShake =
        event.x.abs() > _shakeThreshold ||
        event.y.abs() > _shakeThreshold ||
        event.z.abs() > _shakeThreshold;

    if (isShake) {
      final now = DateTime.now();
      // Check cooldown to prevent multiple triggers
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > _shakeCooldown) {
        _lastShakeTime = now;
        _onShakeDetected();
      }
    }
  }

  void _onShakeDetected() async {
    // Refresh dashboard data
    await refreshDashboardData();

    // Show snackbar after refresh completes
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard refreshed by shake!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF007369),
        ),
      );
    }
  }

  Future<void> refreshDashboardData() async {
    // Re-fetch profile data (real API call)
    await context.read<ProfileProvider>().fetchProfile();

    // Trigger UI rebuild
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _accelSub?.cancel();
    _gyroscopeService.dispose();
    super.dispose();
  }

  List<_FlooringItem> _getAllItems(BuildContext context) {
    return [
      _FlooringItem(
        title: 'Homogeneous\nFlooring',
        imageUrl: homogeneousImageUrl!,
        keywords: const ['homogeneous', 'vinyl', 'hospital', 'school'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomogeneousFlooringScreen(),
            ),
          );
        },
      ),
      _FlooringItem(
        title: 'Heterogeneous\nFlooring',
        imageUrl: heterogeneousImageUrl!,
        keywords: const ['heterogeneous', 'vinyl', 'commercial', 'office'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HeterogeneousFlooringScreen(),
            ),
          );
        },
      ),
      _FlooringItem(
        title: 'Sports Flooring',
        imageUrl: sportsImageUrl!,
        keywords: const ['sports', 'gym', 'court', 'fitness'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SportsFlooringScreen(),
            ),
          );
        },
      ),
    ];
  }

  List<_FlooringItem> _getFilteredItems(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final items = _getAllItems(context);
    if (query.isEmpty) return items;
    return items.where((item) {
      final title = item.title.replaceAll('\n', ' ').toLowerCase();
      final matchesTitle = title.contains(query);
      final matchesKeywords = item.keywords.any(
        (keyword) => keyword.toLowerCase().contains(query),
      );
      return matchesTitle || matchesKeywords;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F6),
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  // Mobile Layout (Original - unchanged)
  Widget _buildMobileLayout(BuildContext context) {
    final filteredItems = _getFilteredItems(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FloorEase',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3A2A2A),
                    ),
                  ),
                  const Text(
                    'Your Smart Flooring Companion',
                    style: TextStyle(fontSize: 16, color: Color(0xFF3A2A2A)),
                  ),
                ],
              ),

              // Profile image
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: _buildProfileAvatar(radius: 30),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 🔹 FILTER BUTTONS NAVIGATION
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: true,
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF007369),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {},
              ),
              const SizedBox(width: 10),
              FilterChip(
                label: const Text('Homogeneous'),
                selected: false,
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomogeneousFlooringScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              FilterChip(
                label: const Text('Heterogeneous'),
                selected: false,
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HeterogeneousFlooringScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              FilterChip(
                label: const Text('Sports'),
                selected: false,
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SportsFlooringScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 🔹 CARD NAVIGATION
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: filteredItems.isEmpty
                ? _buildNoResults()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(-tiltY)
                      ..rotateY(tiltX)
                      ..translate(tiltX * 12, tiltY * 12),
                    child: GridView.count(
                      controller: _scrollController,
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: filteredItems
                          .map(
                            (item) => _buildFlooringCard(
                              imageUrl: item.imageUrl,
                              title: item.title,
                              onTap: item.onTap,
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ),

        // 🔹 BOTTOM NAV
        Container(
          height: 80,
          color: const Color(0xFF007369),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingStepperScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tablet Layout (Responsive)
  Widget _buildTabletLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 900 ? 3 : 2;
    final filteredItems = _getFilteredItems(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FloorEase',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3A2A2A),
                    ),
                  ),
                  const Text(
                    'Your Smart Flooring Companion',
                    style: TextStyle(fontSize: 17, color: Color(0xFF3A2A2A)),
                  ),
                ],
              ),

              // Profile image
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: _buildProfileAvatar(radius: 32),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 🔹 FILTER BUTTONS NAVIGATION
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: true,
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF007369),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {},
              ),
              const SizedBox(width: 10),
              FilterChip(
                label: const Text('Homogeneous'),
                selected: false,
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomogeneousFlooringScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              FilterChip(
                label: const Text('Heterogeneous'),
                selected: false,
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HeterogeneousFlooringScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              FilterChip(
                label: const Text('Sports'),
                selected: false,
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onSelected: (bool selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SportsFlooringScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 🔹 CARD NAVIGATION (GridView for tablet)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: filteredItems.isEmpty
                ? _buildNoResults()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(-tiltY)
                      ..rotateY(tiltX)
                      ..translate(tiltX * 12, tiltY * 12),
                    child: GridView.count(
                      controller: _scrollController,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: filteredItems
                          .map(
                            (item) => _buildFlooringCard(
                              imageUrl: item.imageUrl,
                              title: item.title,
                              onTap: item.onTap,
                              isTablet: true,
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ),

        // 🔹 BOTTOM NAV
        Container(
          height: 70,
          color: const Color(0xFF007369),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 32),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingStepperScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 32),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlooringCard({
    required String imageUrl,
    required String title,
    required VoidCallback onTap,
    bool isTablet = false,
  }) {
    final isNetworkImage = imageUrl.startsWith('http');
    final fontSize = isTablet ? 19.0 : 18.0;
    return GestureDetector(
      onTap: onTap,
      child: ValueListenableBuilder<Offset>(
        valueListenable: _gyroscopeService.tiltNotifier,
        builder: (context, tilt, child) {
          return TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 120),
            tween: Tween<Offset>(begin: tilt, end: tilt),
            builder: (context, animatedTilt, animatedChild) {
              final tiltY = (-animatedTilt.dy).clamp(-1.0, 1.0) * 0.18;
              final tiltX = (animatedTilt.dx).clamp(-1.0, 1.0) * 0.08;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(tiltY)
                  ..rotateX(tiltX),
                child: animatedChild,
              );
            },
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image (asset or network)
                isNetworkImage
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      )
                    : Image.asset(imageUrl, fit: BoxFit.cover),

                // Title overlay at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((0.6 * 255).toInt()),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.search_off, color: Colors.black54, size: 32),
          SizedBox(height: 8),
          Text(
            'No results found',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar({required double radius}) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        final profileImage = provider.profile?.profileImage;

        if (profileImage != null && profileImage.isNotEmpty) {
          return CircleAvatar(
            key: ValueKey(profileImage),
            radius: radius,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.network(
                profileImage,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.person,
                      size: radius * 1.2,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          );
        }

        return CircleAvatar(
          key: const ValueKey('default-profile'),
          radius: radius,
          backgroundImage: const AssetImage('assets/images/profile.png'),
        );
      },
    );
  }
}

class _FlooringItem {
  const _FlooringItem({
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.keywords = const [],
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final List<String> keywords;
}
//