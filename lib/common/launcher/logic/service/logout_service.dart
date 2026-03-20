import 'dart:async';

class LogoutService {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void logout() {
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
