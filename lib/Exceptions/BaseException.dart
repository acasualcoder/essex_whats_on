class CoreException implements Exception {
  final String msg;
  const CoreException(this.msg);
  String toString() => 'CoreException: $msg';
}
