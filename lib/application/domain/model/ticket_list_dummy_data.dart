import 'dart:math';

import 'TicketListModel.dart';

final List<String> subjects = [
  'Login issue',
  'Payment not received',
  'Request for feature',
  'Bug in dashboard',
  'Security concern',
  'Unable to reset password',
  'Account locked',
  'App crash on launch',
  'Incorrect invoice',
  'Feature not working',
  'Unable to upload file',
  'Two-factor issue',
  'Email verification failed',
  'Subscription error',
  'Data sync problem',
  'Language not supported',
  'Accessibility issue',
  'Performance lag',
  'Slow response time',
  'User role mismatch',
];

final List<String> statuses = [
  'Open',
  'Pending',
  'In progress',
  'Resolved',
  'Closed',
];

final List<TicketListModel> ticketListData = List.generate(1000, (index) {
  final random = Random();
  final subject = subjects[random.nextInt(subjects.length)];
  final status = statuses[random.nextInt(statuses.length)];
  final ticketNumber = (10000 + index).toString();

  return TicketListModel(
    ticketID: '#$ticketNumber',
    subject: subject,
    date: '12/10/2024',
    status: status,
  );
});
