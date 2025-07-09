class ReferralStatsModel {
  final int totalReferrals;
  final int totalPurchaseUsers;
  final double totalReferralAmount;
  final double totalReferralEth;

  ReferralStatsModel({
    required this.totalReferrals,
    required this.totalPurchaseUsers,
    required this.totalReferralAmount,
    required this.totalReferralEth,
  });

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatsModel(
      totalReferrals: json['total_referrals'] ?? 0,
      totalPurchaseUsers: json['total_purchase_users'] ?? 0,
      totalReferralAmount: (json['total_referral_amount'] ?? 0).toDouble(),
      totalReferralEth: (json['total_referral_eth'] ?? 0).toDouble(),
    );
  }
}
