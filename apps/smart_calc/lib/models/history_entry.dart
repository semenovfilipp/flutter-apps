class HistoryEntry {
  final String expression;
  final String result;
  final DateTime timestamp;
  final String calculatorType;

  HistoryEntry({
    required this.expression,
    required this.result,
    required this.timestamp,
    required this.calculatorType,
  });

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'calculatorType': calculatorType,
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      calculatorType: json['calculatorType'] as String,
    );
  }

  @override
  String toString() {
    return '$expression = $result';
  }
}
