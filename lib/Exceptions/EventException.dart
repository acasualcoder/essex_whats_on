import 'BaseException.dart';

class EventException extends CoreException {
  EventException(String msg) : super(msg);
  String toString() => 'EventException: $msg';
}
