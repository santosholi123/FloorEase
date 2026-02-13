import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dashboard/presentation/pages/home_screen.dart';
import '../provider/booking_provider.dart';
import 'booking_step1_personal.dart';
import 'booking_step2_service.dart';
import 'booking_step3_notes.dart';

class BookingStepperScreen extends StatefulWidget {
  const BookingStepperScreen({super.key});

  @override
  State<BookingStepperScreen> createState() => _BookingStepperScreenState();
}

class _BookingStepperScreenState extends State<BookingStepperScreen> {
  late final BookingProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = BookingProvider();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F8F6),
        appBar: AppBar(
          title: const Text('Bookings'),
          backgroundColor: const Color(0xFF007369),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final maxWidth = isTablet ? 720.0 : double.infinity;
            final horizontalPadding = isTablet ? 28.0 : 20.0;
            final verticalPadding = isTablet ? 24.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Consumer<BookingProvider>(
                    builder: (context, provider, child) {
                      final isLastStep = provider.currentStep == 2;
                      return Stepper(
                        currentStep: provider.currentStep,
                        onStepContinue: () {
                          if (isLastStep) {
                            provider.submit(context);
                          } else {
                            provider.nextStep(context);
                          }
                        },
                        onStepCancel: provider.prevStep,
                        controlsBuilder: (context, details) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: provider.isSubmitting
                                      ? null
                                      : details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF007369),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: provider.isSubmitting && isLastStep
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          isLastStep ? 'Book Now' : 'Next',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                if (provider.currentStep > 0)
                                  OutlinedButton(
                                    onPressed: provider.isSubmitting
                                        ? null
                                        : details.onStepCancel,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text('Back'),
                                  ),
                              ],
                            ),
                          );
                        },
                        steps: const [
                          Step(
                            title: Text('Personal'),
                            content: BookingStep1Personal(),
                            isActive: true,
                          ),
                          Step(
                            title: Text('Service'),
                            content: BookingStep2Service(),
                            isActive: true,
                          ),
                          Step(
                            title: Text('Notes'),
                            content: BookingStep3Notes(),
                            isActive: true,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
