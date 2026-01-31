import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:batch35_floorease/features/profile/presentation/pages/profile_screen.dart';
import 'package:batch35_floorease/features/homogeneous/presentation/pages/homogeneous_flooring_screen.dart';
import 'package:batch35_floorease/features/heterogeneous/presentation/pages/heterogeneous_flooring_screen.dart';
import 'package:batch35_floorease/features/sports/presentation/pages/sports_flooring_screen.dart';
import 'package:batch35_floorease/core/utils/image_picker_helper.dart';
import 'package:batch35_floorease/core/api/api_endpoints.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FloorType { homogeneous, heterogeneous, sports }

class _HomeScreenState extends State<HomeScreen> {
  // State variables for each card's image URL
  String? homogeneousImageUrl = 'assets/images/homogeneous.png';
  String? heterogeneousImageUrl = 'assets/images/heterogeneous.png';
  String? sportsImageUrl = 'assets/images/sports.png';

  bool isUploading = false;

  Future<void> pickAndUploadForCard(FloorType type) async {
    // Pick image from gallery
    final image = await ImagePickerHelper.pickFromGallery();
    if (image == null) return;

    print("Uploading image...");
    setState(() {
      isUploading = true;
    });

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '${ApiEndpoints.baseUrl}/api/upload',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final uploadedImageUrl = responseData['imageUrl'];

        setState(() {
          // Update only the specific card's image URL
          switch (type) {
            case FloorType.homogeneous:
              homogeneousImageUrl = uploadedImageUrl;
              break;
            case FloorType.heterogeneous:
              heterogeneousImageUrl = uploadedImageUrl;
              break;
            case FloorType.sports:
              sportsImageUrl = uploadedImageUrl;
              break;
          }
          isUploading = false;
        });

        print("Upload success: $uploadedImageUrl");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        }
      }
    } catch (e) {
      print("Upload error: $e");
      setState(() {
        isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Upload failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3A2A2A),
                        ),
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
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
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
                          builder: (context) =>
                              const HomogeneousFlooringScreen(),
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
                          builder: (context) =>
                              const HeterogeneousFlooringScreen(),
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
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    // Homogeneous Card
                    _buildFlooringCardWithUpload(
                      imageUrl: homogeneousImageUrl!,
                      title: 'Homogeneous\nFlooring',
                      floorType: FloorType.homogeneous,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomogeneousFlooringScreen(),
                          ),
                        );
                      },
                    ),
                    // Heterogeneous Card
                    _buildFlooringCardWithUpload(
                      imageUrl: heterogeneousImageUrl!,
                      title: 'Heterogeneous\nFlooring',
                      floorType: FloorType.heterogeneous,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HeterogeneousFlooringScreen(),
                          ),
                        );
                      },
                    ),
                    // Sports Card
                    _buildFlooringCardWithUpload(
                      imageUrl: sportsImageUrl!,
                      title: 'Sports Flooring',
                      floorType: FloorType.sports,
                      onTap: () {
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
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
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
        ),
      ),
    );
  }

  Widget _buildFlooringCardWithUpload({
    required String imageUrl,
    required String title,
    required FloorType floorType,
    required VoidCallback onTap,
  }) {
    final isNetworkImage = imageUrl.startsWith('http');

    return GestureDetector(
      onTap: onTap,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // "+" icon overlay at top-right
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  key: floorType == FloorType.homogeneous
                      ? const Key('add_image_homogeneous')
                      : floorType == FloorType.heterogeneous
                      ? const Key('add_image_heterogeneous')
                      : const Key('add_image_sports'),
                  onTap: () => pickAndUploadForCard(floorType),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007369),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.3 * 255).toInt()),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
