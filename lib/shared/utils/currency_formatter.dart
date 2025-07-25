import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'RWF ',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }
  
  static String formatRWF(double amount) {
    return _formatter.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    return NumberFormat('#,##0', 'en_US').format(amount);
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M RWF';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K RWF';
    } else {
      return '${amount.toStringAsFixed(0)} RWF';
    }
  }

  static double? parse(String value) {
    // Remove currency symbol and formatting
    final cleanValue = value
        .replaceAll('RWF', '')
        .replaceAll(',', '')
        .trim();
    
    return double.tryParse(cleanValue);
  }
}
