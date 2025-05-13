class TextFieldValidators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    final RegExp emailPattern =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (!emailPattern.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  // Phone number validation (must start with +639 and be 13 digits long)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Check if the phone number starts with 09
    if (!value.startsWith('09')) {
      return 'Phone number must start with 09';
    }

    // Check if the input contains only numbers
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only numbers';
    }

    // Check if the phone number has exactly 11 digits
    if (value.length != 11) {
      return 'Phone number must be exactly 11 digits long';
    }

    return null;
  }

  // Name validation (no numbers, special characters allowed)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    // Regular expression for names (letters and spaces only)
    final RegExp namePattern = RegExp(r'^[a-zA-Z\s]+$');
    if (!namePattern.hasMatch(value)) {
      return 'Name must only contain letters and spaces';
    }

    return null;
  }

  // TIN validation (no repeating sequences like 111 or 222)
  static String? validateTIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'TIN is required';
    }

    final RegExp tinPattern = RegExp(r'(.)\1{2,}');
    if (tinPattern.hasMatch(value)) {
      return 'TIN should not contain repeating numbers like 111, 222, etc.';
    }

    if (value.contains('123456789') ||
        value == '123456789000' ||
        value.contains('1234')) {
      return 'TIN cannot be a counting sequence like 123456789';
    }

    if (value.length < 9 || value.length > 12) {
      return 'Tin Number must contain 9-12 digits';
    }

    return null;
  }

  // Engine number validation (10 alphanumeric characters)
  static String? validateEngineNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Engine number is required';
    }

    // Check if Engine number has at least 17 characters
    if (value.length > 17) {
      return 'Engine number should not be greater than 17 characters';
    }

    // // Regular expression to allow alphanumeric characters and any length above 10
    // final RegExp chassisPattern = RegExp(r'^[a-zA-Z0-9]+$');

    // if (!chassisPattern.hasMatch(value)) {
    //   return 'Chassis number must contain only alphanumeric characters';
    // }

    return null;
  }

  // Chassis number (VIN) validation (must be exactly 17 alphanumeric characters)
  static String? validateChassisNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Chassis number is required';
    }

    // Check if chassis number has at least 17 characters
    if (value.length > 17) {
      return 'Chassis number should not be greater than 17 characters';
    }

    // // Regular expression to allow alphanumeric characters and any length above 17
    // final RegExp chassisPattern = RegExp(r'^[a-zA-Z0-9]+$');

    // if (!chassisPattern.hasMatch(value)) {
    //   return 'Chassis number must contain only alphanumeric characters';
    // }

    return null;
  }

  // Empty text field validation
  static String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? validatePlateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    // Regular expression to enforce letters and numbers
    final RegExp plateNumberPattern =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z0-9\s]+$');

    if (!plateNumberPattern.hasMatch(value)) {
      return 'This field must have both letters and numbers.';
    }

    // Optional: Check for length (6 to 8 characters)
    if (value.length < 6 || value.length > 8) {
      return 'This field be between 6 and 8 characters long.';
    }

    return null; // Return null if validation passes
  }
}
