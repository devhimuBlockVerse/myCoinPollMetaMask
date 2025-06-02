import '../../domain/model/ReferralUserListModel.dart';

final List<ReferralUserListModel> referralUserListData = List.generate(10, (index) {
   final String date = '12/10/25';
  final String name = 'Jane Cooper';
  final String userId = '5320127';

   String status;
  if (index == 0 || index == 4 || index == 5 || index == 7 || index == 8 || index == 9) {
    status = 'Inactive';
  } else {
    status = 'Active';
  }

  return ReferralUserListModel(
    sl: (index + 1).toString().padLeft(2, '0'),
    date: date,
    name: name,
    userId: userId,
    status: status,
  );
});