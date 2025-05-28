import '../../../framework/utils/enums/milestone_status.dart';

class RewardModel {
  final String? primaryReward;
  final String? secondaryReward;

  RewardModel({this.primaryReward, this.secondaryReward});
}

class EcmTaskModel {
  final String id;
  final String title;
  final String imageUrl;
  final String targetSales;
  final String deadline;
  final RewardModel reward;
  final String milestoneMessage;
  final EcmTaskStatus status;

  EcmTaskModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.targetSales,
    required this.deadline,
    required this.reward,
    required this.milestoneMessage,
    required this.status,
  });
}
