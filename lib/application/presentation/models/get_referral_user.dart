// class ReferralUserListModel {
//   final int? id;
//   final String? name;
//   final String? userId;
//   final String? date;
//   final String? status;
//
//   ReferralUserListModel({
//     this.id,
//     this.name,
//     this.userId,
//     this.date,
//     this.status,
//   });
//
//   factory ReferralUserListModel.fromJson(Map<String, dynamic> json) {
//     return ReferralUserListModel(
//       id: json['id'],
//       name: json['name'] ?? '',
//       userId: json['user_id']?.toString() ?? '',
//       date: json['created_at'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }

class ReferralUserListModel {
  final String date;
  final String name;
  final String userId;
  final String status;

  ReferralUserListModel({
    required this.date,
    required this.name,
    required this.userId,
    required this.status,
  });

  factory ReferralUserListModel.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = DateTime.parse(json['created_at']);
    String formattedDate =
        '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
    String statusStr = json['status'] == 1 ? 'Active' : 'Inactive';

    return ReferralUserListModel(
      date: formattedDate,
      name: json['name'] ?? '',
      userId: json['unique_id'] ?? '',
      status: statusStr,
    );
  }
}

