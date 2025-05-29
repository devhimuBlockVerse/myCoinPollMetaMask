
import 'dart:math';

final List<Map<String, dynamic>> activityData = List.generate(40, (index) {
  final rand = Random();
  final day = (1 + rand.nextInt(28)).toString().padLeft(2, '0');
  final months = ['May', 'June', 'July', 'August'];
  final actions = [
    'Milestone Start',
    'Reached 50% Target',
    'User Claimed Bonus',
    'Achieved Record',
    'Missed Deadline',
    'Exceeded Target',
    'Bonus Unlocked',
    'Halfway Milestone',
  ];

  return {
    'SL': (index + 1).toString().padLeft(2, '0'),
    'Date': '$day ${months[rand.nextInt(months.length)]}',
    'Action': actions[rand.nextInt(actions.length)],
    'Achieved Sales': (10 + rand.nextInt(90)).toString(),
    'Target Sales': (100 + rand.nextInt(200)).toString(),
  };
});
