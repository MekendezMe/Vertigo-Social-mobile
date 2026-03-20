import 'package:social_network_flutter/common/launcher/logic/service/logout_service.dart';

abstract class IServerLogoutHandler {
  Future<void> logout();
}

abstract class ILogoutHandler {
  void onLogout();
}

class LogoutHandler implements ILogoutHandler {
  final LogoutService logoutService;

  LogoutHandler({required this.logoutService});

  @override
  void onLogout() {
    logoutService.logout();
  }
}
