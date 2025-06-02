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



enum SortReferralUserListOption {
  dateAsc,      // Oldest to Latest (consistent with standard ascending date sort)
  dateDesc,     // Latest to Oldest
  nameAsc,      // A-Z
  nameDesc,     // Z-A
  statusAsc,    // Active then Inactive (or alphabetical)
  statusDesc,   // Inactive then Active (or reverse alphabetical)
  slAsc,        // SL 01, 02...
  slDesc,       // SL 10, 09...
  userIdAsc,    // User ID ascending
  userIdDesc,   // User ID descending
}


