import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/booking_provider.dart';

class BookingStep3Notes extends StatelessWidget {
  const BookingStep3Notes({super.key});

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
                      'Schedule + Notes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<String>(
                      value: provider.preferredTime,
                      items: const [
                        DropdownMenuItem(
                          value: 'Morning 8-12',
                          child: Text('Morning 8-12'),
                        ),
                        DropdownMenuItem(
                          value: 'Afternoon 12-4',
                          child: Text('Afternoon 12-4'),
                        ),
                        DropdownMenuItem(
                          value: 'Evening 4-8',
                          child: Text('Evening 4-8'),
                        ),
                      ],
                      onChanged: (value) {
                        provider.setPreferredTime(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Preferred Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: provider.notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Notes (optional)',
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
