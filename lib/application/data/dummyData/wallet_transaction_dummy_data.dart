final List<Map<String, String>> walletTransactionData = List.generate(35, (index) {
  final methods = ['Received', 'Staked', 'Withdrawn', 'Transferred'];
  final currencies = ['BTC', 'ETH', 'USDT', 'BNB'];
  final statuses = ['Completed', 'Unstack Now', 'Pending'];
  final amounts = ['+0.25 BTC', '+0.5 ETH', '+100 USDT', '-0.1 BTC', '+0.01 BNB'];

   final day = (index % 28) + 1;
  final month = (index % 12) + 1;
  final year = 2024 + (index % 2);

  return {
    'SL': (index + 1).toString().padLeft(2, '0'),
    'Date': '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year.toString().substring(2)}', // Formats as DD/MM/YY
    'Method': methods[index % methods.length],
    'Currency': currencies[index % currencies.length],
    'Status': statuses[index % statuses.length],
    'Amount': amounts[index % amounts.length],
  };
});