class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Required!';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid Email!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password Required!';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First Name Required!';
    }
    return null;
  }

  static String? validateSignUpPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password Required!';
    }
    if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(value)) {
      return 'Password must contain at least 8 characters, including uppercase, lowercase, number, and special character.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    // Check if the phone number is empty
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Regular expression for validating phone numbers
    final RegExp phoneRegExp = RegExp(r'^[0-9]{10,15}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null; // Return null if the phone number is valid
  }
}
