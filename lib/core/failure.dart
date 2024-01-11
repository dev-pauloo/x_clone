Future<void> failure(String message, StackTrace st) async {
  FailureClass;
}

class FailureClass {
  final String message;
  final StackTrace stackTrace;
  // final StackTrace stackTrace;
  FailureClass(
    this.message,
    this.stackTrace
  );
}
