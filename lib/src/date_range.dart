class DateRange {
  DateTime startTime;
  DateTime endTime;

  DateRange(this.startTime, this.endTime) {
    assert(startTime.isBefore(endTime) || startTime == endTime);
  }

  bool isBefore(DateTime time) {
    return endTime.isBefore(time) || endTime == time;
  }

  bool isAfter(DateTime time) {
    return startTime.isAfter(time) || startTime == time;
  }
}
