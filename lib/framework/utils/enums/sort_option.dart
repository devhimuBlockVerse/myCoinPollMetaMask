enum SortOption { dateLatest, dateOldest, statusAsc, statusDesc }

enum SortTransactionHistoryOption { dateLatest, dateOldest, statusAsc, statusDesc, amountAsc, amountDesc, }
enum SortMilestoneLists { active, onGoing, completed }



enum SortPurchaseLogOption {
  dateLatest,
  dateOldest,
  amountHighToLow,
  amountLowToHigh,
}



enum SortReferralTransactionOption {
  dateLatest,
  dateOldest,
  // Renamed ecmAmount to purchaseAmountECM to match the model
  amountHighToLow,
  amountLowToHigh,
}