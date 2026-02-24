import 'package:flutter/material.dart';

import '../pages/booking_success_screen.dart';

class BookingProvider extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityAddressController = TextEditingController();
  final TextEditingController areaSizeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? serviceType;
  String? flooringType;
  String? preferredTime;
  String? preferredDate;

  int currentStep = 0;
  bool isSubmitting = false;

  final Map<String, String?> errors = {};

  void nextStep(BuildContext context) {
    final isValid = validateStep(currentStep);
    if (!isValid) return;
    if (currentStep < 2) {
      currentStep += 1;
      notifyListeners();
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      currentStep -= 1;
      notifyListeners();
    }
  }

  void setPreferredDate(DateTime date) {
    final value =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    preferredDate = value;
    errors.remove('preferredDate');
    notifyListeners();
  }

  void setServiceType(String? value) {
    serviceType = value;
    notifyListeners();
  }

  void setFlooringType(String? value) {
    flooringType = value;
    notifyListeners();
  }

  void setPreferredTime(String? value) {
    preferredTime = value;
    notifyListeners();
  }

  bool validateStep(int step) {
    bool isValid = true;

    if (step == 0) {
      errors.remove('fullName');
      errors.remove('phone');
      errors.remove('cityAddress');

      if (fullNameController.text.trim().isEmpty) {
        errors['fullName'] = 'Full name is required';
        isValid = false;
      }

      final phone = phoneController.text.trim();
      final phoneRegex = RegExp(r'^(\d{10}|\+977\d{10})$');
      if (phone.isEmpty) {
        errors['phone'] = 'Mobile number is required';
        isValid = false;
      } else if (!phoneRegex.hasMatch(phone)) {
        errors['phone'] = 'Enter 10 digits or +977XXXXXXXXXX';
        isValid = false;
      }

      if (cityAddressController.text.trim().isEmpty) {
        errors['cityAddress'] = 'City/Address is required';
        isValid = false;
      }
    }

    if (step == 1) {
      errors.remove('areaSize');
      errors.remove('preferredDate');

      final areaText = areaSizeController.text.trim();
      final areaValue = int.tryParse(areaText);
      if (areaText.isEmpty) {
        errors['areaSize'] = 'Area size is required';
        isValid = false;
      } else if (areaValue == null || areaValue <= 0) {
        errors['areaSize'] = 'Area size must be greater than 0';
        isValid = false;
      }

      if (preferredDate == null || preferredDate!.isEmpty) {
        errors['preferredDate'] = 'Preferred date is required';
        isValid = false;
      }
    }

    notifyListeners();
    return isValid;
  }

  Future<void> submit(BuildContext context) async {
    final step0Valid = validateStep(0);
    final step1Valid = validateStep(1);
    if (!step0Valid || !step1Valid) {
      currentStep = step0Valid ? 1 : 0;
      notifyListeners();
      return;
    }

    isSubmitting = true;
    notifyListeners();

    final payload = {
      'fullName': fullNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'cityAddress': cityAddressController.text.trim(),
      'serviceType': serviceType,
      'flooringType': flooringType,
      'areaSize': int.tryParse(areaSizeController.text.trim()) ?? 0,
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'notes': notesController.text.trim(),
    };

    debugPrint('Booking payload: $payload');
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookingSuccessScreen()),
      );
    }

    isSubmitting = false;
    notifyListeners();
  }

  void reset() {
    fullNameController.clear();
    phoneController.clear();
    emailController.clear();
    cityAddressController.clear();
    areaSizeController.clear();
    notesController.clear();

    serviceType = null;
    flooringType = null;
    preferredTime = null;
    preferredDate = null;

    currentStep = 0;
    isSubmitting = false;
    errors.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityAddressController.dispose();
    areaSizeController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
