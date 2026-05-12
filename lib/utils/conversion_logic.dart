import '../models/conversion_category.dart';

class ConversionLogic {
  // Conversion rates to base units
  static const Map<String, Map<String, double>> _conversionRates = {
    // Length (base: meter)
    'length': {
      'Meter': 1.0,
      'Kilometer': 0.001,
      'Centimeter': 100.0,
      'Millimeter': 1000.0,
      'Mile': 0.000621371,
      'Yard': 1.09361,
      'Foot': 3.28084,
      'Inch': 39.3701,
    },
    
    // Weight (base: kilogram)
    'weight': {
      'Kilogram': 1.0,
      'Gram': 1000.0,
      'Milligram': 1000000.0,
      'Metric Ton': 0.001,
      'Pound': 2.20462,
      'Ounce': 35.274,
      'Stone': 0.157473,
    },
    
    // Time (base: second)
    'time': {
      'Second': 1.0,
      'Minute': 1.0 / 60,
      'Hour': 1.0 / 3600,
      'Day': 1.0 / 86400,
      'Week': 1.0 / 604800,
      'Month': 1.0 / 2592000,
      'Year': 1.0 / 31536000,
      'Millisecond': 1000.0,
    },
    
    // Speed (base: meter per second)
    'speed': {
      'Meter/Second': 1.0,
      'Kilometer/Hour': 3.6,
      'Mile/Hour': 2.23694,
      'Foot/Second': 3.28084,
      'Knot': 1.94384,
    },
    
    // Distance (same as length, base: meter)
    'distance': {
      'Meter': 1.0,
      'Kilometer': 0.001,
      'Centimeter': 100.0,
      'Millimeter': 1000.0,
      'Mile': 0.000621371,
      'Yard': 1.09361,
      'Foot': 3.28084,
      'Inch': 39.3701,
      'Nautical Mile': 0.000539957,
    },
    
    // Currency (base: USD) - Static rates for demo
    'currency': {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.79,
      'JPY': 149.50,
      'CNY': 7.24,
      'INR': 83.12,
      'AUD': 1.53,
      'CAD': 1.36,
      'CHF': 0.88,
      'MXN': 17.05,
    },
  };

  static List<String> getUnitsForCategory(ConversionCategory category) {
    final categoryKey = category.name;
    return _conversionRates[categoryKey]?.keys.toList() ?? [];
  }

  static double convert(
    double value,
    String fromUnit,
    String toUnit,
    ConversionCategory category,
  ) {
    if (fromUnit == toUnit) return value;

    final categoryKey = category.name;
    final rates = _conversionRates[categoryKey];
    
    if (rates == null || !rates.containsKey(fromUnit) || !rates.containsKey(toUnit)) {
      return 0.0;
    }

    // Convert to base unit first, then to target unit
    final fromRate = rates[fromUnit]!;
    final toRate = rates[toUnit]!;
    
    final baseValue = value / fromRate;
    final result = baseValue * toRate;
    
    return result;
  }

  // Method to update currency rates (for future API integration)
  static void updateCurrencyRates(Map<String, double> newRates) {
    _conversionRates['currency']?.addAll(newRates);
  }
}
