class StakingPlanModel {
  final int id;
  final String name;
  final int duration;
  final int rewardPercentage;
  final int isActive;
  final double currentPoll;
  final double maxPoll;
  final DateTime createdAt;
  final DateTime updatedAt;

  StakingPlanModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.rewardPercentage,
    required this.isActive,
    required this.currentPoll,
    required this.maxPoll,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StakingPlanModel.fromJson(Map<String, dynamic> json) {
    return StakingPlanModel(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      rewardPercentage: json['reward_percentage'],
      isActive: json['is_active'],
      currentPoll: (json['current_poll'] is int)
          ? (json['current_poll'] as int).toDouble()
          : (json['current_poll'] as double),
      maxPoll: (json['max_poll'] is int)
          ? (json['max_poll'] as int).toDouble()
          : (json['max_poll'] as double),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
