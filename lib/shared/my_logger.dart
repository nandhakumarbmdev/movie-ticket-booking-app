class MyLogger {
  static void log(String message) {

    final now = DateTime.now();
    final hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final timestamp = '${_two(hour12)}:${_two(now.minute)}:${_two(now.second)} '
        '${now.hour >= 12 ? 'PM' : 'AM'}';
    print('📌  [$timestamp] $message');
  }
  static String _two(int n) => n.toString().padLeft(2, '0');
}
