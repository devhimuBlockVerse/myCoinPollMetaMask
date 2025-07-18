class PurchaseStatsModel {
  final double totalPurchaseAmount;
  final int totalPurchases;
  final int uniqueStages;

  PurchaseStatsModel({
    required this.totalPurchaseAmount,
    required this.totalPurchases,
    required this.uniqueStages,
  });

  factory PurchaseStatsModel.fromJson(Map<String, dynamic> json) {
    return PurchaseStatsModel(
      totalPurchaseAmount: (json['total_purchase_amount'] ?? 0).toDouble(),
      totalPurchases: json['total_purchases'] ?? 0,
      uniqueStages: json['unique_stages'] ?? 0,
    );
  }
}
