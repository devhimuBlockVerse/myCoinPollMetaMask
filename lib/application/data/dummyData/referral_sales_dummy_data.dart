import 'dart:math';


final List<Map<String, String>> referralSalesData = List.generate(40, (index) {
  final names = ['Leslie Alexander', 'Brooklyn Simmons', 'Courtney Henry', 'Devon Lane'];
  return {
    'SL': (index + 1).toString().padLeft(2, '0'),
    'Name': names[index % names.length],
    'ECMPurchased': '${(index % 5 + 1) * 1000} ECM',
    'Date': '${(7 + index % 20).toString().padLeft(2, '0')}/10/2024',
  };
});
