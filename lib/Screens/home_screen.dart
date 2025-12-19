import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flooring_card.dart';
import 'profile_screen.dart';
import 'homogeneous_flooring_screen.dart';
import 'heterogeneous_flooring_screen.dart';
import 'sports_flooring_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F6),
      body: SafeArea(
        child: Column(
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
                      color: Colors.black.withOpacity(0.05),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomogeneousFlooringScreen(),
                          ),
                        );
                      },
                      child: const FlooringCard(
                        image: 'assets/images/homogeneous.png',
                        title: 'Homogeneous\nFlooring',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HeterogeneousFlooringScreen(),
                          ),
                        );
                      },
                      child: const FlooringCard(
                        image: 'assets/images/heterogeneous.png',
                        title: 'Heterogeneous\nFlooring',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SportsFlooringScreen(),
                          ),
                        );
                      },
                      child: const FlooringCard(
                        image: 'assets/images/sports.png',
                        title: 'Sports Flooring',
                      ),
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
                    icon: const Icon(Icons.person, color: Colors.white, size: 30),
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
}
