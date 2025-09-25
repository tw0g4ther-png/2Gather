extension UtilsDuration on Duration {
  String format() {
    if (inMinutes < 1) {
      return "${inSeconds}s";
    } else if (inHours < 1) {
      return "${inMinutes}m";
    } else if (inDays < 1) {
      return "${inHours}h";
    } else if (inDays < 365) {
      return "${inDays}j";
    } else {
      return "${inDays / 365}a";
    }
  }
}
