class VestingInfo {
  int? start;
  int? cliff;
  int? duration;
  int? end;
  double? released;
  double? claimable;

  VestingInfo({
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