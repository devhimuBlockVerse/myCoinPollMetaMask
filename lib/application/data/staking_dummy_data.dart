
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
