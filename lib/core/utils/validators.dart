import '../error/failures.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Full name validation
  static String? validateFullName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Full name is required';
    }
    if (name.trim().length < 2) {
      return 'Please enter a valid full name';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Phone number validation (Rwanda format)
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters except +
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Check various Rwanda phone formats
    bool isValid = false;
    
    if (cleanPhone.startsWith('+250') && cleanPhone.length == 13) {
      isValid = RegExp(r'^\+250[0-9]{9}$').hasMatch(cleanPhone);
    } else if (cleanPhone.startsWith('250') && cleanPhone.length == 12) {
      isValid = RegExp(r'^250[0-9]{9}$').hasMatch(cleanPhone);
    } else if (cleanPhone.startsWith('0') && cleanPhone.length == 10) {
      isValid = RegExp(r'^0[0-9]{9}$').hasMatch(cleanPhone);
    } else if (cleanPhone.length == 9) {
      isValid = RegExp(r'^[0-9]{9}$').hasMatch(cleanPhone);
    }
    
    if (!isValid) {
      return 'Please enter a valid Rwanda phone number';
    }
    
    return null;
  }

  // Price validation
  static String? validatePrice(String? price) {
    if (price == null || price.isEmpty) {
      return 'Price is required';
    }
    
    try {
      double priceValue = double.parse(price.replaceAll(',', ''));
      if (priceValue <= 0) {
        return 'Price must be greater than 0';
      }
      if (priceValue > 10000000) { // Max 10 million RWF
        return 'Price seems too high';
      }
    } catch (e) {
      return 'Please enter a valid price';
    }
    
    return null;
  }

  // Product name validation
  static String? validateProductName(String? productName) {
    if (productName == null || productName.isEmpty) {
      return 'Product name is required';
    }
    if (productName.trim().length < 2) {
      return 'Product name must be at least 2 characters';
    }
    if (productName.trim().length > 100) {
      return 'Product name is too long';
    }
    return null;
  }

  // Store name validation
  static String? validateStoreName(String? storeName) {
    if (storeName == null || storeName.isEmpty) {
      return 'Store name is required';
    }
    if (storeName.trim().length < 2) {
      return 'Store name must be at least 2 characters';
    }
    if (storeName.trim().length > 100) {
      return 'Store name is too long';
    }
    return null;
  }

  // Location validation
  static String? validateLocation(String? location) {
    if (location == null || location.isEmpty) {
      return 'Location is required';
    }
    if (location.trim().length < 2) {
      return 'Please enter a valid location';
    }
    return null;
  }

  // OTP validation
  static String? validateOTP(String? otp) {
    if (otp == null || otp.isEmpty) {
      return 'Verification code is required';
    }
    if (otp.length != 4) {
      return 'Please enter the 4-digit code';
    }
    if (!RegExp(r'^[0-9]{4}$').hasMatch(otp)) {
      return 'Code must contain only numbers';
    }
    return null;
  }

  // Search query validation
  static String? validateSearchQuery(String? query) {
    if (query == null || query.isEmpty) {
      return 'Please enter something to search';
    }
    if (query.trim().length < 2) {
      return 'Search query must be at least 2 characters';
    }
    return null;
  }

  // Password strength checker
  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // Get password strength text
  static String getPasswordStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Generic minimum length validation
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  // Generic maximum length validation
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters';
    }
    return null;
  }

  // URL validation
  static String? validateUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    
    if (!RegExp(r'^https?:\/\/.+').hasMatch(url)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  // Positive number validation
  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    try {
      double number = double.parse(value);
      if (number <= 0) {
        return '$fieldName must be greater than 0';
      }
    } catch (e) {
      return 'Please enter a valid number for $fieldName';
    }
    
    return null;
  }

  // Integer validation
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    try {
      int.parse(value);
    } catch (e) {
      return 'Please enter a valid whole number for $fieldName';
    }
    
    return null;
  }

  // Date validation (not in future)
  static String? validateDateNotFuture(DateTime? date, String fieldName) {
    if (date == null) {
      return '$fieldName is required';
    }
    
    if (date.isAfter(DateTime.now())) {
      return '$fieldName cannot be in the future';
    }
    
    return null;
  }

  // Combine multiple validators
  static String? combineValidators(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}