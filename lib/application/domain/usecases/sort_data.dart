import '../../../framework/utils/date_parser.dart';
import '../../../framework/utils/enums/milestone_status.dart';
import '../../../framework/utils/enums/sort_option.dart';
import '../../data/dummyData/referral_transaction_dummy_data.dart';
import '../../presentation/models/get_staking_history.dart';
import '../model/PurchaseLogModel.dart';
import '../model/ReferralUserListModel.dart';
import '../model/TicketListModel.dart';
import '../model/milestone_list_models.dart';
import 'package:intl/intl.dart';

// class SortDataUseCase {
//   List<Map<String, dynamic>> call(
//       List<Map<String, dynamic>> data,
//       SortOption option,
//       ) {
//     final sorted = List<Map<String, dynamic>>.from(data);
//     sorted.sort((a, b) {
//       switch (option) {
//         case SortOption.dateLatest:
//           return DateParser.fromReadableFormat(b['Date']!)
//               .compareTo(DateParser.fromReadableFormat(a['Date']!));
//         case SortOption.dateOldest:
//           return DateParser.fromReadableFormat(a['Date']!)
//               .compareTo(DateParser.fromReadableFormat(b['Date']!));
//         case SortOption.statusAsc:
//           return (a['Status'] ?? '').compareTo(b['Status'] ?? '');
//         case SortOption.statusDesc:
//           return (b['Status'] ?? '').compareTo(a['Status'] ?? '');
//
//
//       }
//     });
//     return sorted;
//   }
// }
class SortDataUseCase {
  List<StakingHistoryModel> call(List<StakingHistoryModel> data, SortOption option) {
    final sorted = List<StakingHistoryModel>.from(data);

    sorted.sort((a, b) {
      switch (option) {
        case SortOption.dateLatest:
          return DateParser.fromReadableFormat(b.createdAtFormatted)
              .compareTo(DateParser.fromReadableFormat(a.createdAtFormatted));
        case SortOption.dateOldest:
          return DateParser.fromReadableFormat(a.createdAtFormatted)
              .compareTo(DateParser.fromReadableFormat(b.createdAtFormatted));
        case SortOption.statusAsc:
          return a.status.compareTo(b.status);
        case SortOption.statusDesc:
          return b.status.compareTo(a.status);
      }
    });

    return sorted;
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
        case SortTransactionHistoryOption.dateLatest:
          return DateParser.fromReadableFormat(b['DateTime']!)
              .compareTo(DateParser.fromReadableFormat(a['DateTime']!));
        case SortTransactionHistoryOption.dateOldest:
          return DateParser.fromReadableFormat(a['DateTime']!)
              .compareTo(DateParser.fromReadableFormat(b['DateTime']!));
        case SortTransactionHistoryOption.statusAsc:
          return (a['Status'] ?? '').compareTo(b['Status'] ?? '');
        case SortTransactionHistoryOption.statusDesc:
          return (b['Status'] ?? '').compareTo(a['Status'] ?? '');
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


class SortEcmTaskUseCase {

  int _getStatusPriority(EcmTaskStatus taskStatus, SortMilestoneLists sortOption) {
    switch (sortOption) {
      case SortMilestoneLists.active:
        if (taskStatus == EcmTaskStatus.active) return 0;
        if (taskStatus == EcmTaskStatus.ongoing) return 1;
        if (taskStatus == EcmTaskStatus.completed) return 2;
        break;
      case SortMilestoneLists.onGoing:
        if (taskStatus == EcmTaskStatus.ongoing) return 0;
        if (taskStatus == EcmTaskStatus.active) return 1;
        if (taskStatus == EcmTaskStatus.completed) return 2;
        break;
      case SortMilestoneLists.completed:
        if (taskStatus == EcmTaskStatus.completed) return 0;
        if (taskStatus == EcmTaskStatus.active) return 1;
        if (taskStatus == EcmTaskStatus.ongoing) return 2;
        break;
    }
     return 3;
  }

   List<EcmTaskModel> call(
      List<EcmTaskModel> data,
      SortMilestoneLists option,
      ) {
     final sortedList = List<EcmTaskModel>.from(data);

    sortedList.sort((taskA, taskB) {
       final priorityA = _getStatusPriority(taskA.status, option);
      final priorityB = _getStatusPriority(taskB.status, option);

       int comparisonResult = priorityA.compareTo(priorityB);

       if (comparisonResult == 0) {
         return taskA.title.compareTo(taskB.title);
      }

      return comparisonResult;
    });

    return sortedList;
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




class SortReferralTransactionUseCase {
  List<ReferralTransactionModel> call(
      List<ReferralTransactionModel> data,
      SortReferralTransactionOption option,
      ) {
    final sorted = List<ReferralTransactionModel>.from(data);

    sorted.sort((a, b) {
      switch (option) {
        case SortReferralTransactionOption.dateLatest:
          return b.date.compareTo(a.date);
        case SortReferralTransactionOption.dateOldest:
          return a.date.compareTo(b.date);
        case SortReferralTransactionOption.amountHighToLow:
        // Use the new field name purchaseAmountECM
          return b.purchaseAmountECM.compareTo(a.purchaseAmountECM);
        case SortReferralTransactionOption.amountLowToHigh:
        // Use the new field name purchaseAmountECM
          return a.purchaseAmountECM.compareTo(b.purchaseAmountECM);
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
        case SortReferralUserListOption.dateAsc:
           return parser.parse(a.date).compareTo(parser.parse(b.date));
        case SortReferralUserListOption.dateDesc:
          return parser.parse(b.date).compareTo(parser.parse(a.date));
        case SortReferralUserListOption.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case SortReferralUserListOption.nameDesc:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        case SortReferralUserListOption.statusAsc:

          if (a.status == 'Active' && b.status == 'Inactive') return -1;
          if (a.status == 'Inactive' && b.status == 'Active') return 1;
          return a.status.compareTo(b.status);
        case SortReferralUserListOption.statusDesc:
          if (a.status == 'Inactive' && b.status == 'Active') return -1;
          if (a.status == 'Active' && b.status == 'Inactive') return 1;
          return b.status.compareTo(a.status);
        case SortReferralUserListOption.slAsc:
        // Convert SL string to int for numerical sorting
          return int.parse(a.sl).compareTo(int.parse(b.sl));
        case SortReferralUserListOption.slDesc:
          return int.parse(b.sl).compareTo(int.parse(a.sl));
        case SortReferralUserListOption.userIdAsc:
          return a.userId.toLowerCase().compareTo(b.userId.toLowerCase());
        case SortReferralUserListOption.userIdDesc:
          return b.userId.toLowerCase().compareTo(a.userId.toLowerCase());
      }
    });

    return sorted;
  }
}



class SortTableListUseCase {
  List<TicketListModel> call(
      List<TicketListModel> data,
      SortTicketListOption option,
      ) {
    final sorted = List<TicketListModel>.from(data);

    sorted.sort((a, b) {
      switch (option) {
        case SortTicketListOption.dateLatest:
          return DateParser.fromReadableFormat(b.date)
              .compareTo(DateParser.fromReadableFormat(a.date));

        case SortTicketListOption.dateOldest:
          return DateParser.fromReadableFormat(a.date)
              .compareTo(DateParser.fromReadableFormat(b.date));

        case SortTicketListOption.statusAsc:
          return a.status.compareTo(b.status);

        case SortTicketListOption.statusDesc:
          return b.status.compareTo(a.status);
      }
    });

    return sorted;
  }
}
