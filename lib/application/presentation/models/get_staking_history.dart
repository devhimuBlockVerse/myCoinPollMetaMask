class StakingHistoryModel {
  final int id;
  final String staker;
  final String stakeId;
  final String amount;
  final int percentage;
  final int duration;
  final String reward;
  final String totalReceive;
  final int? endTime;
  final String endTimeFormatted;
  final String createdAtFormatted;
  final String status;
  final int? remainingTime;

  StakingHistoryModel({
    required this.id,
    required this.staker,
    required this.stakeId,
    required this.amount,
    required this.percentage,
    required this.duration,
    required this.reward,
    required this.totalReceive,
    required this.endTimeFormatted,
    this.endTime,
    required this.createdAtFormatted,
    required this.status,
    this.remainingTime,
  });

  factory StakingHistoryModel.fromJson(Map<String, dynamic> json) {
    return StakingHistoryModel(
      id: json['id'],
      staker: json['staker'],
      stakeId: json['stake_id'],
      amount: json['amount'],
      percentage: json['percentage'],
      duration: json['duration'],
      reward: json['reward'],
      totalReceive: json['total_receive'],
      endTimeFormatted: json['end_time_formatted'],
      endTime: json['end_time'],
      createdAtFormatted: json['created_at_formatted'],
      status: json['status'],
      remainingTime: json['remaining_time'] != null ? (json['remaining_time'] as num).toInt() : null,

    );
  }
}