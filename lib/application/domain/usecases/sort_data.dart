import '../../../framework/utils/date_parser.dart';
import '../../../framework/utils/enums/sort_option.dart';


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
