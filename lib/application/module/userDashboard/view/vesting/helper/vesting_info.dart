class VestingInfo {
  int? start;
  int? cliff;
  int? duration;
  int? end;
  double? released;
  double? claimable;
  double? totalVestingAmount;

  VestingInfo({
    this.start,
    this.cliff,
    this.duration,
    this.end,
    this.released,
    this.claimable,
    this.totalVestingAmount,
  });

  @override
  String toString() {
    return 'VestingInfo(start: $start, cliff: $cliff, duration: $duration end: $end, released: $released, claimable: $claimable , totalVestingAmount: $totalVestingAmount)';
  }
}