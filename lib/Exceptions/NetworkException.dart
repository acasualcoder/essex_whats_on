import 'BaseException.dart';

class NetworkException extends CoreException {
  NetworkException(String msg) : super(msg);
  String toString() => 'NetworkException: $msg';
}
