import '../../../framework/utils/date_parser.dart';
import '../../../framework/utils/enums/milestone_status.dart';
import '../../../framework/utils/enums/sort_option.dart';
import '../model/milestone_list_models.dart';


class SortDataUseCase {
  List<Map<String, dynamic>> call(
      List<Map<String, dynamic>> data,
      SortOption option,
      ) {
    final sorted = List<Map<String, dynamic>>.from(data);
    sorted.sort((a, b) {
      switch (option) {
        case SortOption.dateLatest:
          return DateParser.fromReadableFormat(b['Date']!)
              .compareTo(DateParser.fromReadableFormat(a['Date']!));
        case SortOption.dateOldest:
          return DateParser.fromReadableFormat(a['Date']!)
              .compareTo(DateParser.fromReadableFormat(b['Date']!));
        case SortOption.statusAsc:
          return (a['Status'] ?? '').compareTo(b['Status'] ?? '');
        case SortOption.statusDesc:
          return (b['Status'] ?? '').compareTo(a['Status'] ?? '');


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