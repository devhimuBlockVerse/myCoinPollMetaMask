import '../../framework/utils/enums/milestone_status.dart';
import '../domain/model/milestone_list_models.dart';

final List<EcmTaskModel> milestoneListsData = List.generate(20, (i) {
  final statuses = EcmTaskStatus.values;
  final id = '${i + 1}';
  final title = [
    'Sell ECM Coin',
    'Promote ECM on Socials',
    'Host ECM Webinar',
    'Develop ECM Feature',
    'Get 10 Referrals',
    'Create ECM Tutorial',
    'Engage Community',
    'Publish ECM Article',
    'Design ECM Poster',
    'Build ECM App'
  ][i % 10];

  final reward = i % 4 == 0
      ? RewardModel(primaryReward: 'Tour Trip', secondaryReward: '\$200 USD')
      : RewardModel(primaryReward: '\$${(i + 1) * 50} USD');

  return EcmTaskModel(
    id: id,
    title: '$title',
    imageUrl: 'https://picsum.photos/seed/$id/200/220',
    targetSales: i % 3 == 0 ? '${(i + 1) * 100} ECM' : '${(i + 1) * 10} ECM',
    deadline: '${10 + i} Jul 2025',
    reward: reward,
    milestoneMessage: 'You will Get ${reward.primaryReward}${reward.secondaryReward != null ? ' & ${reward.secondaryReward}' : ''} after completing the milestone.',
    status: statuses[i % statuses.length],
  );
});
