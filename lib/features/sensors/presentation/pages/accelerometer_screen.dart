import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerScreen extends StatefulWidget {
  final VoidCallback onShakeRefresh;

  const AccelerometerScreen({super.key, required this.onShakeRefresh});

  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Current accelerometer values
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;

  // Shake detection cooldown
  DateTime? _lastShakeTime;
  static const Duration _shakeCooldown = Duration(milliseconds: 1500);
  static const double _shakeThreshold = 15.0;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;
        });

        _detectShake(event);
      },
      onError: (error) {
        debugPrint('Accelerometer error: $error');
      },
    );
  }

  void _detectShake(AccelerometerEvent event) {
    // Check if any axis exceeds threshold
    final bool isShake =
        event.x.abs() > _shakeThreshold ||
        event.y.abs() > _shakeThreshold ||
        event.z.abs() > _shakeThreshold;

    if (isShake) {
      // Check cooldown to prevent multiple triggers
      final now = DateTime.now();
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > _shakeCooldown) {
        _lastShakeTime = now;
        _onShakeDetected();
      }
    }
  }

  void _onShakeDetected() {
    // Show snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shake detected!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF007369),
        ),
      );

      // Call the refresh callback
      widget.onShakeRefresh();
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F6),
      appBar: AppBar(
        title: const Text(
          'Accelerometer',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF007369),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Instruction Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.smartphone,
                        size: 64,
                        color: const Color(0xFF007369),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Shake to Refresh',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3A2A2A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Shake your device to refresh the dashboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Live Values Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Accelerometer Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3A2A2A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildAxisRow('X-Axis', _x, Colors.red),
                      const SizedBox(height: 16),
                      _buildAxisRow('Y-Axis', _y, Colors.green),
                      const SizedBox(height: 16),
                      _buildAxisRow('Z-Axis', _z, Colors.blue),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: const Color(0xFF007369),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Shake detected when any value > $_shakeThreshold',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAxisRow(String label, double value, Color color) {
    return Row(
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3A2A2A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
//