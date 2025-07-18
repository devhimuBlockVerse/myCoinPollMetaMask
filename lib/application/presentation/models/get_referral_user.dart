class ReferralUserListModel {
  final int? id;
  final String? name;
  final String? userId;
  final String? date;
  final String? status;

  ReferralUserListModel({
    this.id,
    this.name,
    this.userId,
    this.date,
    this.status,
  });

  factory ReferralUserListModel.fromJson(Map<String, dynamic> json) {
    return ReferralUserListModel(
      id: json['id'],
      name: json['name'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      date: json['created_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}