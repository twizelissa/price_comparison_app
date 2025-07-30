import 'package:dartz/dartz.dart';
import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return const Left(ValidationFailure(message: 'Invalid input - not a positive integer'));
    }
  }

  Either<Failure, double> stringToDouble(String str) {
    try {
      final double value = double.parse(str);
      return Right(value);
    } on FormatException {
      return const Left(ValidationFailure(message: 'Invalid input - not a valid number'));
    }
  }

  Either<Failure, double> stringToPositiveDouble(String str) {
    try {
      final double value = double.parse(str);
      if (value <= 0) throw const FormatException();
      return Right(value);
    } on FormatException {
      return const Left(ValidationFailure(message: 'Invalid input - not a positive number'));
    }
  }

  Either<Failure, int> stringToInteger(String str) {
    try {
      final integer = int.parse(str);
      return Right(integer);
    } on FormatException {
      return const Left(ValidationFailure(message: 'Invalid input - not a valid integer'));
    }
  }

  String formatPrice(double price, {String currency = 'RWF'}) {
    if (price == price.roundToDouble()) {
      return '${price.round().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )} $currency';
    } else {
      return '${price.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )} $currency';
    }
  }

  String formatPriceShort(double price, {String currency = 'RWF'}) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M $currency';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(1)}K $currency';
    } else {
      return '${price.round()} $currency';
    }
  }

  String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    
    // Format for Rwanda phone numbers
    if (digitsOnly.length == 9 && digitsOnly.startsWith('7')) {
      return '+250 ${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 12 && digitsOnly.startsWith('250')) {
      return '+${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6, 9)} ${digitsOnly.substring(9)}';
    }
    
    return phone; // Return original if doesn't match expected format
  }

  String cleanPhoneNumber(String phone) {
    // Remove all non-digit characters except +
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Handle Rwanda format
    if (cleaned.startsWith('+250')) {
      return cleaned;
    } else if (cleaned.startsWith('250')) {
      return '+$cleaned';
    } else if (cleaned.startsWith('0') && cleaned.length == 10) {
      return '+250${cleaned.substring(1)}';
    } else if (cleaned.length == 9 && cleaned.startsWith('7')) {
      return '+250$cleaned';
    }
    
    return cleaned;
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }

  String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * 
        math.cos(_degreesToRadians(lat2)) * 
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()}m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidRwandanPhone(String phone) {
    final cleanPhone = cleanPhoneNumber(phone);
    return RegExp(r'^\+250[0-9]{9}$').hasMatch(cleanPhone);
  }

  double calculatePriceChange(double oldPrice, double newPrice) {
    if (oldPrice == 0) return 0;
    return ((newPrice - oldPrice) / oldPrice) * 100;
  }

  String formatPriceChange(double changePercent) {
    final sign = changePercent >= 0 ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(1)}%';
  }
}

// Import math for distance calculation
import 'dart:math' as math;