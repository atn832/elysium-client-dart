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

  void expand(DateTime time) {
    if (time.isBefore(startTime)) {
      startTime = time;
    } else if (time.isAfter(endTime)) {
      endTime = time;
    }
  }
}
