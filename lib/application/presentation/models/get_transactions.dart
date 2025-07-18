// Transaction model
class TransactionModel {
  final String direction;
  final String hash;
  final String shortHash;
  final String explorerUrl;
  final String from;
  final String to;
  final String timestamp;
  final String age;
  final num convertedValue;

  TransactionModel({
    required this.direction,
    required this.hash,
    required this.shortHash,
    required this.explorerUrl,
    required this.from,
    required this.to,
    required this.timestamp,
    required this.age,
    required this.convertedValue,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      direction: json['direction'] ?? '',
      hash: json['hash'] ?? '',
      shortHash: json['short_hash'] ?? '',
      explorerUrl: json['explorer_url'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      timestamp: json['timestamp'] ?? '',
      age: json['age'] ?? '',
      convertedValue: json['converted_value'] ?? 0,
    );
  }

  Map<String, dynamic> toDisplayMap(int index) {
    return {
      'SL': '${index + 1}',
      'DateTime': timestamp,
      'TxnHash': shortHash,
      'Status': direction.toUpperCase(),
      'Amount': convertedValue.toString(),
    };
  }
}
