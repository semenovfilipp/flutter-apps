class UnitConverter {
  static const Map<String, Map<String, double>> _conversionRates = {
    'Length': {
      'Meters': 1.0,
      'Kilometers': 0.001,
      'Centimeters': 100.0,
      'Millimeters': 1000.0,
      'Miles': 0.000621371,
      'Yards': 1.09361,
      'Feet': 3.28084,
      'Inches': 39.3701,
    },
    'Weight': {
      'Kilograms': 1.0,
      'Grams': 1000.0,
      'Milligrams': 1000000.0,
      'Pounds': 2.20462,
      'Ounces': 35.274,
      'Tons': 0.001,
    },
    'Temperature': {
      'Celsius': 1.0,
      'Fahrenheit': 1.0,
      'Kelvin': 1.0,
    },
  };

  List<String> get categories => _conversionRates.keys.toList();

  List<String> getUnits(String category) {
    return _conversionRates[category]?.keys.toList() ?? [];
  }

  double convert(double value, String category, String from, String to) {
    if (category == 'Temperature') {
      return _convertTemperature(value, from, to);
    }

    if (!_conversionRates.containsKey(category)) return 0;
    if (!_conversionRates[category]!.containsKey(from)) return 0;
    if (!_conversionRates[category]!.containsKey(to)) return 0;

    double baseValue = value / _conversionRates[category]![from]!;
    double result = baseValue * _conversionRates[category]![to]!;

    return double.parse(result.toStringAsFixed(6));
  }

  double _convertTemperature(double value, String from, String to) {
    double celsius;

    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        return 0;
    }

    switch (to) {
      case 'Celsius':
        return double.parse(celsius.toStringAsFixed(2));
      case 'Fahrenheit':
        return double.parse(((celsius * 9 / 5) + 32).toStringAsFixed(2));
      case 'Kelvin':
        return double.parse((celsius + 273.15).toStringAsFixed(2));
      default:
        return 0;
    }
  }
}
