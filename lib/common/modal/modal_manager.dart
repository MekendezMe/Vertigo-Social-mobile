import 'dart:ui';

class ModalManager {
  static final ModalManager _instance = ModalManager._internal();
  factory ModalManager() => _instance;
  ModalManager._internal();

  bool _isCommentsModalOpen = false;
  VoidCallback? _onBackPressed;

  bool get isCommentsModalOpen => _isCommentsModalOpen;

  void openCommentsModal(VoidCallback onClose) {
    _isCommentsModalOpen = true;
    _onBackPressed = onClose;
  }

  void closeCommentsModal() {
    _isCommentsModalOpen = false;
    _onBackPressed = null;
  }

  bool handleBackPress() {
    if (_isCommentsModalOpen && _onBackPressed != null) {
      _onBackPressed!();
      return true;
    }
    return false;
  }
}

final modalManager = ModalManager();
