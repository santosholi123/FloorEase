import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/booking_provider.dart';

class BookingStep1Personal extends StatelessWidget {
  const BookingStep1Personal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final spacing = isTablet ? 20.0 : 16.0;
            final padding = isTablet ? 24.0 : 20.0;

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Personal Info',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: provider.fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name *',
                        errorText: provider.errors['fullName'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: provider.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        errorText: provider.errors['phone'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: provider.cityAddressController,
                      decoration: InputDecoration(
                        labelText: 'City/Address *',
                        errorText: provider.errors['cityAddress'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
