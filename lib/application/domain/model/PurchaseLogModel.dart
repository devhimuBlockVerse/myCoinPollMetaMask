// class PurchaseLogModel {
//   final String coinName;
//   final String refName;
//   final DateTime date;
//   final String contractName;
//   final String senderName;
//   final double ecmAmount;
//   final String hash;
//
//   PurchaseLogModel({
//     required this.coinName,
//     required this.refName,
//     required this.date,
//     required this.contractName,
//     required this.senderName,
//     required this.ecmAmount,
//     required this.hash,
//   });
//
//   factory PurchaseLogModel.fromJson(Map<String, dynamic> json) {
//     return PurchaseLogModel(
//       coinName: json['coinName'],
//       refName: json['refName'],
//       date: DateTime.parse(json['date']),
//       contractName: json['contractName'],
//       senderName: json['senderName'],
//       ecmAmount: json['ecmAmount'].toDouble(),
//       hash: json['hash'],
//     );
//   }
// }
class PurchaseLogModel {
  // final String coinName;
  final int id;
  final String hash;
  final int userId;
  final String buyer;
  final double amount;
  final String createdAt;
  final String icoStage;
  final int? referralUserId;
  final double referralAmount;
  final double referralEth;

  PurchaseLogModel({
    // required this.coinName,
    required this.id,
    required this.hash,
    required this.userId,
    required this.buyer,
    required this.amount,
    required this.createdAt,
    required this.icoStage,
    this.referralUserId,
    required this.referralAmount,
    required this.referralEth,
  });

  factory PurchaseLogModel.fromJson(Map<String, dynamic> json) {
    return PurchaseLogModel(
      // coinName: json['coinName'] ?? 'ECM',
      id: json['id'] ?? 0,
      hash: json['hash'] ?? '',
      userId: json['user_id'] ?? 0,
      buyer: json['buyer'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      icoStage: json['ico_stage'] ?? '',
      referralUserId: json['referral_user_id'] != null
          ? int.tryParse(json['referral_user_id'].toString())
          : null,
      referralAmount: double.tryParse(json['referral_amount'].toString()) ?? 0.0,
      referralEth: double.tryParse(json['referral_eth'].toString()) ?? 0.0,
    );
  }
}

