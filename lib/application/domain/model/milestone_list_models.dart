import '../../../framework/utils/enums/milestone_status.dart';

class RewardModel {
  final String? primaryReward; // e.g., "$200 USD" or "Tour Trip"
  final String? secondaryReward; // e.g., "200 USD" (if primary is "Tour Trip")

  RewardModel({this.primaryReward, this.secondaryReward});
}

class EcmTaskModel {
  final String id;
  final String title;
  final String imageUrl; // URL or local asset path for the image
  final String targetSales; // e.g., "1000 ECM"
  final String deadline; // e.g., "10 May 2025"
  final RewardModel reward;
  final String milestoneMessage; // e.g., "You will Get $200 after completing the milestone."
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
