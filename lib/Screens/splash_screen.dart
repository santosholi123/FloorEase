import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00C3E3), // Cyan at top
              Color(0xFFA6FFB8), // Light green at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Logo at the top
              _buildLogo(),
              
              const Spacer(),
              
              // Main title and tagline
              _buildTitle(),
              
              const Spacer(),
              
              // Get Started button
              _buildGetStartedButton(context),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Simple house icon with roof and door
        SizedBox(
          width: 60,
          height: 40,
          child: Stack(
            children: [
              // Roof
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(60, 15),
                  painter: RoofPainter(),
                ),
              ),
              // House body
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                height: 25,
                child: Container(
                  color: Colors.white,
                ),
              ),
              // Door
              Positioned(
                bottom: 0,
                left: 22,
                width: 15,
                height: 20,
                child: Container(
                  color: Colors.cyan.shade200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'FloorEase',
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'FloorEase',
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your Smart Flooring Companion',
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the next screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006D5B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Get Start',
            style: GoogleFonts.quicksand(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
