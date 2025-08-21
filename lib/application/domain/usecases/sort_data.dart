import '../../../framework/utils/date_parser.dart';
import '../../../framework/utils/enums/sort_option.dart';
import '../../presentation/models/get_referral_user.dart';
import '../../presentation/models/get_staking_history.dart';
import '../model/PurchaseLogModel.dart';
import '../model/ReferralUserListModel.dart';
import 'package:intl/intl.dart';

class SortDataUseCase {
  List<StakingHistoryModel> call(List<StakingHistoryModel> data, SortOption option) {
    final sorted = List<StakingHistoryModel>.from(data);

    sorted.sort((a, b) {
      switch (option) {
        case SortOption.dateLatest:

          DateTime aDate = _parseDate(a.createdAtFormatted);
          DateTime bDate = _parseDate(b.createdAtFormatted);
          return bDate.compareTo(aDate);
        case SortOption.dateOldest:

          DateTime aDate = _parseDate(a.createdAtFormatted);
          DateTime bDate = _parseDate(b.createdAtFormatted);
          return aDate.compareTo(bDate);

      }
    });

    return sorted;
  }
  DateTime _parseDate(String formattedDate) {
    try {
      return DateParser.fromReadableFormat(formattedDate);
    } catch (_) {
       return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

}

class SortTransactionDataUseCase {
  List<Map<String, dynamic>> call(
      List<Map<String, dynamic>> data,
      SortTransactionHistoryOption option,
      ) {
    final sorted = List<Map<String, dynamic>>.from(data);
    sorted.sort((a, b) {
      switch (option) {
        case SortTransactionHistoryOption.amountAsc:
          return (double.tryParse(a['Amount']?.toString() ?? '0') ?? 0)
              .compareTo(double.tryParse(b['Amount']?.toString() ?? '0') ?? 0);
        case SortTransactionHistoryOption.amountDesc:
          return (double.tryParse(b['Amount']?.toString() ?? '0') ?? 0)
              .compareTo(double.tryParse(a['Amount']?.toString() ?? '0') ?? 0);
      }
    });
    return sorted;
  }
}

class SortPurchaseLogUseCase {
  List<PurchaseLogModel> call(
      List<PurchaseLogModel> data,
      SortPurchaseLogOption option,
      ) {
    final sorted = List<PurchaseLogModel>.from(data);

    sorted.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt) ?? DateTime.now();
      final bDate = DateTime.tryParse(b.createdAt) ?? DateTime.now();

      switch (option) {
        case SortPurchaseLogOption.dateLatest:
          return bDate.compareTo(aDate);
        case SortPurchaseLogOption.dateOldest:
          return aDate.compareTo(bDate);
        case SortPurchaseLogOption.amountHighToLow:
          return b.amount.compareTo(a.amount);
        case SortPurchaseLogOption.amountLowToHigh:
          return a.amount.compareTo(b.amount);
      }
    });

    return sorted;
  }
}

class SortReferralUseListUseCase {
  List<ReferralUserListModel> call(
      List<ReferralUserListModel> data,
      SortReferralUserListOption option,
      ) {
    final sorted = List<ReferralUserListModel>.from(data);
    final DateFormat parser = DateFormat('MM/dd/yy');

    sorted.sort((a, b) {
      switch (option) {

        case SortReferralUserListOption.statusAsc:

          if (a.status == 'Active' && b.status == 'Inactive') return -1;
          if (a.status == 'Inactive' && b.status == 'Active') return 1;
          return a.status.compareTo(b.status);

        case SortReferralUserListOption.statusDesc:
          if (a.status == 'Inactive' && b.status == 'Active') return -1;
          if (a.status == 'Active' && b.status == 'Inactive') return 1;
          return b.status.compareTo(a.status);

      }
    });

    return sorted;
  }
}
