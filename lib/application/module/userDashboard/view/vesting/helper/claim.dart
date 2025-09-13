
class Claim {
  final String amount;
  final String dateTime;
  final String walletAddress;
  final String hash;

  Claim({
    required this.amount,
    required this.dateTime,
    required this.walletAddress,
    required this.hash,
  });
}
