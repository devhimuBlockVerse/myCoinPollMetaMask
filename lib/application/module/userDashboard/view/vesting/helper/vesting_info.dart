class IcoVestingInfo {
  int? start;
  int? cliff;
  int? duration;
  int? end;
  double? released;
  double? claimable;

  IcoVestingInfo({
    this.start,
    this.cliff,
    this.duration,
    this.end,
    this.released,
    this.claimable,
  });

  @override
  String toString() {
    return 'VestingInfo(start: $start, cliff: $cliff, duration: $duration end: $end, released: $released, claimable: $claimable)';
  }
}


class ExistingVestingInfo {
  int? start;
  int? cliff;
  int? duration;
  int? end;
  double? released;
  double? claimable;
  double? totalVestingAmount;

  ExistingVestingInfo({
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
    return 'ExistingVestingInfo(start: $start, cliff: $cliff, duration: $duration end: $end, released: $released, claimable: $claimable , totalVestingAmount: $totalVestingAmount)';
  }
}