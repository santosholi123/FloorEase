import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/booking_provider.dart';

class BookingStep2Service extends StatelessWidget {
  const BookingStep2Service({super.key});

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
                      'Service Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<String>(
                      value: provider.serviceType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Installation',
                          child: Text('Installation'),
                        ),
                        DropdownMenuItem(
                          value: 'Repair',
                          child: Text('Repair'),
                        ),
                        DropdownMenuItem(
                          value: 'Polish',
                          child: Text('Polish'),
                        ),
                        DropdownMenuItem(
                          value: 'Inspection',
                          child: Text('Inspection'),
                        ),
                      ],
                      onChanged: (value) {
                        provider.serviceType = value;
                        provider.notifyListeners();
                      },
                      decoration: InputDecoration(
                        labelText: 'Service Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    DropdownButtonFormField<String>(
                      value: provider.flooringType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Homogeneous',
                          child: Text('Homogeneous'),
                        ),
                        DropdownMenuItem(
                          value: 'Heterogeneous',
                          child: Text('Heterogeneous'),
                        ),
                        DropdownMenuItem(value: 'SPC', child: Text('SPC')),
                        DropdownMenuItem(value: 'Vinyl', child: Text('Vinyl')),
                        DropdownMenuItem(
                          value: 'Carpet',
                          child: Text('Carpet'),
                        ),
                        DropdownMenuItem(
                          value: 'Wooden',
                          child: Text('Wooden'),
                        ),
                      ],
                      onChanged: (value) {
                        provider.flooringType = value;
                        provider.notifyListeners();
                      },
                      decoration: InputDecoration(
                        labelText: 'Flooring Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      controller: provider.areaSizeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Area Size (sq.ft) *',
                        errorText: provider.errors['areaSize'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: provider.preferredDate ?? '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Preferred Date *',
                        errorText: provider.errors['preferredDate'],
                        suffixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: now,
                          lastDate: DateTime(now.year + 2),
                        );
                        if (picked != null) {
                          provider.setPreferredDate(picked);
                        }
                      },
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
