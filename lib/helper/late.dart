bool isLateInitializationError(dynamic e) {
  return e.toString().contains('LateInitializationError');
}
