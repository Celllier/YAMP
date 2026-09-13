


class Utils {
  static String formatDuration(int seconds) {
    String min = "${(seconds / 60).floor()}";
    int isec = seconds % 60;
    String sec = isec < 10 ? "0$isec" : "$isec";

    return "$min:$sec";
  }
}