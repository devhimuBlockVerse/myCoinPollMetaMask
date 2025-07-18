/// Dummy Data for Staking History
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

/// Dummy Data for Transaction History( Delete later)
final List<Map<String, dynamic>> transactionData = List.generate(50, (index) {
  final statuses = ['In', 'Out'];
  // Sample Txn Hashes
  final txnHashes = [
    '0xac6d8aed85214', '0xac6d8aed8sfss', '0xac6d8aed8sfss', '0xac6d8aed8sfss',
    '0xac6d8aed8sfss', '0xac6d8aed8sfss', '0xac6d8aed8sfss', '0xac6d8aed8sfss',
    '0xac6d8aed8sfss', '0xac6d8aed8sfss'
  ];
  final amounts = [
    '52450.00', '100.00', '100.00', '100.00', '100.00',
    '100.00', '100.00', '100.00', '100.00', '100.00'
  ];
  final dates = [
    'May 12, 2025', 'May 10, 2025', 'May 10, 2025', 'May 10, 2025', 'May 10, 2025',
    'May 10, 2025', 'May 10, 2025', 'May 10, 2025', 'May 10, 2025', 'May 10, 2025'
  ];


  return {
    'SL': (index + 1).toString().padLeft(2, '0'),
    // 'DateTime': dates[index],
    'DateTime': dates[index % dates.length],
    'TxnHash': txnHashes[index % txnHashes.length],
    'Status': statuses[index % statuses.length],
    'Amount': amounts[index % amounts.length],
   };
});


