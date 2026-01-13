class CurrencyConverter {
  static const Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.50,
    'RUB': 92.50,
    'CNY': 7.24,
    'INR': 83.12,
  };

  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'RUB': '₽',
    'CNY': '¥',
    'INR': '₹',
  };

  List<String> get currencies => _exchangeRates.keys.toList();

  String getCurrencySymbol(String currency) {
    return _currencySymbols[currency] ?? '';
  }

  double convert(double amount, String from, String to) {
    if (!_exchangeRates.containsKey(from) || !_exchangeRates.containsKey(to)) {
      return 0;
    }

    double amountInUSD = amount / _exchangeRates[from]!;
    double result = amountInUSD * _exchangeRates[to]!;

    return double.parse(result.toStringAsFixed(2));
  }

  String getExchangeRate(String from, String to) {
    if (!_exchangeRates.containsKey(from) || !_exchangeRates.containsKey(to)) {
      return '1';
    }

    double rate = _exchangeRates[to]! / _exchangeRates[from]!;
    return rate.toStringAsFixed(4);
  }
}
