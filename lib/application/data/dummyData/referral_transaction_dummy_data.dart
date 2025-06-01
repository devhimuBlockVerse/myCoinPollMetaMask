
class ReferralTransactionModel {
  final String coinName;
  final DateTime date;
  final String userName;
  final String uuId;
  final double purchaseAmountECM;
  final int referralBonusMCM; // Changed to int based on screenshot
  final int referralBonusETH; // Changed to int based on screenshot

  ReferralTransactionModel({
    required this.coinName,
    required this.date,
    required this.userName,
    required this.uuId,
    required this.purchaseAmountECM,
    required this.referralBonusMCM,
    required this.referralBonusETH,
  });

  factory ReferralTransactionModel.fromJson(Map<String, dynamic> json) {
    return ReferralTransactionModel(
      coinName: json['coinName'],
      date: DateTime.parse(json['date']), // Assuming date is in ISO 8601 format
      userName: json['userName'],
      uuId: json['uuId'],
      purchaseAmountECM: json['purchaseAmountECM'].toDouble(),
      referralBonusMCM: json['referralBonusMCM'],
      referralBonusETH: json['referralBonusETH'],
    );
  }
}

extension DateTimeExtension on DateTime {
  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}