import 'package:social_network_flutter/common/authentication/user/repository/user_repository.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';

class UserService {
  final UserRepository userRepository;

  User? _currentUser;

  UserService({required this.userRepository});

  User? get currentUser => _currentUser;

  int get currentUserId {
    if (_currentUser == null) {
      throw AuthException(message: 'UserService: пользователь не загружен');
    }
    return _currentUser!.id;
  }

  bool get isAuthenticated => _currentUser != null;

  Future<void> loadCurrentUser() async {
    try {
      final response = await userRepository.getCurrentUser();
      _currentUser = response.user;
    } catch (e) {
      rethrow;
    }
  }

  void setUser(User user) {
    _currentUser = user;
  }

  void clear() {
    _currentUser = null;
  }
}
