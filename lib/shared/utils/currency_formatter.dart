import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Rwanda Franc formatter
  static final NumberFormat _rwfFormatter = NumberFormat.currency(
    locale: 'en_RW',
    symbol: 'RWF ',
    decimalDigits: 0,
  );

  // Number formatter without currency symbol
  static final NumberFormat _numberFormatter = NumberFormat('#,##0', 'en_US');

  // Decimal number formatter
  static final NumberFormat _decimalFormatter = NumberFormat('#,##0.00', 'en_US');

  // Format price in RWF
  static String formatRWF(double amount) {
    if (amount == 0) return 'RWF 0';
    return _rwfFormatter.format(amount);
  }

  // Format price in RWF without symbol
  static String formatRWFWithoutSymbol(double amount) {
    return _numberFormatter.format(amount);
  }

  // Format price with custom currency
  static String formatWithCurrency(double amount, String currency) {
    if (amount == 0) return '$currency 0';
    return '$currency ${_numberFormatter.format(amount)}';
  }

  // Format number with thousands separator
  static String formatNumber(double number) {
    return _numberFormatter.format(number);
  }

  // Format number with decimals
  static String formatDecimal(double number) {
    return _decimalFormatter.format(number);
  }

  // Format compact (K, M, B)
  static String formatCompact(double amount) {
    if (amount >= 1000000000) {
      return 'RWF ${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return 'RWF ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'RWF ${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return formatRWF(amount);
    }
  }

  // Format price range
  static String formatPriceRange(double minPrice, double maxPrice) {
    if (minPrice == maxPrice) {
      return formatRWF(minPrice);
    }
    return '${formatRWF(minPrice)} - ${formatRWF(maxPrice)}';
  }

  // Format percentage
  static String formatPercentage(double percentage, {int decimalPlaces = 1}) {
    final formatter = NumberFormat.decimalPattern();
    formatter.minimumFractionDigits = decimalPlaces;
    formatter.maximumFractionDigits = decimalPlaces;
    return '${formatter.format(percentage)}%';
  }

  // Format price change with sign
  static String formatPriceChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${formatRWF(change)}';
  }

  // Format price change percentage
  static String formatPriceChangePercentage(double percentage) {
    final sign = percentage >= 0 ? '+' : '';
    return '$sign${formatPercentage(percentage)}';
  }

  // Parse string to double (for user input)
  static double? parsePrice(String priceString) {
    try {
      // Remove currency symbols and spaces
      String cleanString = priceString
          .replaceAll('RWF', '')
          .replaceAll('Frw', '')
          .replaceAll(',', '')
          .trim();
      
      return double.tryParse(cleanString);
    } catch (e) {
      return null;
    }
  }

  // Validate price input
  static bool isValidPrice(String priceString) {
    final parsed = parsePrice(priceString);
    return parsed != null && parsed > 0;
  }

  // Format input as user types (for text field)
  static String formatInputAsUserTypes(String input) {
    final parsed = parsePrice(input);
    if (parsed == null) return input;
    return formatRWFWithoutSymbol(parsed);
  }

  // Get currency symbol
  static String getCurrencySymbol() {
    return 'RWF';
  }

  // Format discount percentage
  static String formatDiscount(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0 || discountedPrice <= 0) return '';
    
    final discount = ((originalPrice - discountedPrice) / originalPrice) * 100;
    if (discount <= 0) return '';
    
    return '-${formatPercentage(discount, decimalPlaces: 0)}';
  }

  // Format savings amount
  static String formatSavings(double originalPrice, double discountedPrice) {
    if (originalPrice <= discountedPrice) return '';
    
    final savings = originalPrice - discountedPrice;
    return 'Save ${formatRWF(savings)}';
  }

  // Format price per unit (e.g., per kg, per liter)
  static String formatPricePerUnit(double price, String unit) {
    return '${formatRWF(price)}/$unit';
  }

  // Format average price
  static String formatAveragePrice(List<double> prices) {
    if (prices.isEmpty) return 'N/A';
    
    final average = prices.reduce((a, b) => a + b) / prices.length;
    return 'Avg. ${formatRWF(average)}';
  }

  // Format price trend
  static String formatPriceTrend(double currentPrice, double previousPrice) {
    if (previousPrice == 0) return 'New';
    
    final change = currentPrice - previousPrice;
    final changePercentage = (change / previousPrice) * 100;
    
    if (change > 0) {
      return '↑ ${formatPriceChangePercentage(changePercentage)}';
    } else if (change < 0) {
      return '↓ ${formatPriceChangePercentage(changePercentage.abs())}';
    } else {
      return '→ No change';
    }
  }

  // Format price for comparison table
  static String formatComparisonPrice(double price, bool isLowest) {
    final formattedPrice = formatRWF(price);
    return isLowest ? '$formattedPrice (Best)' : formattedPrice;
  }

  // Format bulk price (e.g., buy 5 for RWF 1000)
  static String formatBulkPrice(int quantity, double totalPrice) {
    return 'Buy $quantity for ${formatRWF(totalPrice)}';
  }

  // Get formatted price with currency code
  static String formatWithCurrencyCode(double amount) {
    return '${formatRWFWithoutSymbol(amount)} RWF';
  }

  // Format price for API (always as string without formatting)
  static String formatForAPI(double amount) {
    return amount.toStringAsFixed(2);
  }

  // Format monthly/yearly prices
  static String formatSubscriptionPrice(double price, String period) {
    return '${formatRWF(price)}/$period';
  }

  // Format installment price
  static String formatInstallmentPrice(double totalPrice, int installments) {
    final installmentAmount = totalPrice / installments;
    return '${formatRWF(installmentAmount)} × $installments installments';
  }
}