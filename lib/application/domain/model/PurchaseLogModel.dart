class PurchaseLogModel {
  final String coinName;
  final String refName;
  final DateTime date;
  final String contractName;
  final String senderName;
  final double ecmAmount;
  final String hash;

  PurchaseLogModel({
    required this.coinName,
    required this.refName,
    required this.date,
    required this.contractName,
    required this.senderName,
    required this.ecmAmount,
    required this.hash,
  });

  factory PurchaseLogModel.fromJson(Map<String, dynamic> json) {
    return PurchaseLogModel(
      coinName: json['coinName'],
      refName: json['refName'],
      date: DateTime.parse(json['date']), // Assuming date is in ISO 8601 format
      contractName: json['contractName'],
      senderName: json['senderName'],
      ecmAmount: json['ecmAmount'].toDouble(),
      hash: json['hash'],
    );
  }
}

extension DateTimeExtension on DateTime {
  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}