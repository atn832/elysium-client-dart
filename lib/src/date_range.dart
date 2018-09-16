class DateRange {
  DateTime startTime;
  DateTime endTime;

  DateRange(this.startTime, this.endTime) {
    assert(startTime.isBefore(endTime) || startTime == endTime);
  }
}
