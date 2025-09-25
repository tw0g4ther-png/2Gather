extension DurationAge on Duration {
  String formatToGetAge() {
    return (inDays ~/ 365).toString();
  }
}
