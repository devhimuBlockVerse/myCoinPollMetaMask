
final List<Map<String, String>> stakingData = List.generate(40, (index) {
  final statuses = ['Unstack Now', 'Completed', 'Pending', 'In Progress'];
  return {
    'SL': (index + 1).toString().padLeft(2, '0'),
    'Date': 'May ${10 + (index % 20)}, 2025',
    'Duration': '${180 + (index % 5) * 30} Days',
    'Reward': '\$ ${100 + (index % 5) * 10}',
    'Amount': '\$${10 + (index % 4) * 5}',
    'Status': statuses[index % statuses.length],
  };
});

String monthToNumber(String month) {
  const months = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };
  return months[month] ?? '01';
}
