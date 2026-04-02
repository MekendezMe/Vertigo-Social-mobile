import 'package:flutter/widgets.dart';

class CustomToast {
  static const _dismissDuration = Duration(milliseconds: 300);

  static late BuildContext _overlayContext;

  static OverlayEntry? _lastOverlay;
  static Widget? _lastBody;

  static void init(BuildContext overlayContext) {
    _overlayContext = overlayContext;
  }

  static void show(Widget body, {Duration? dismissAfter}) {
    if (dismissAfter != null) {
      Future.delayed(dismissAfter, () {
        dismiss();
      });
    }

    _lastBody = body;
    var overlay = _buildOverlay(
      content: body,
      beginOpacity: 1,
      endOpacity: 1,
      animationDuration: Duration.zero,
    );
    _showOverlay(overlay);
  }

  static void _showOverlay(OverlayEntry overlay) {
    if (!_overlayContext.mounted) {
      return;
    }
    if (_lastOverlay?.mounted == true) {
      _lastOverlay?.remove();
    }
    _lastOverlay = overlay;

    Overlay.of(_overlayContext).insert(overlay);
  }

  static void cleanup() {
    _lastBody = null;
    if (_lastOverlay?.mounted == true) {
      _lastOverlay?.remove();
    }
    _lastOverlay = null;
  }

  static void dismiss() {
    if (_lastOverlay == null || _lastBody == null) {
      _lastOverlay = null;
      _lastBody = null;
      return;
    }

    var dismissingOverlay = _buildOverlay(
      content: _lastBody!,
      beginOpacity: 1,
      endOpacity: 0,
      animationDuration: _dismissDuration,
    );
    _showOverlay(dismissingOverlay);

    _lastOverlay = null;
    _lastBody = null;

    Future.delayed(_dismissDuration, () {
      if (dismissingOverlay.mounted) {
        dismissingOverlay.remove();
      }
    });
  }

  static OverlayEntry _buildOverlay({
    required Widget content,
    required double beginOpacity,
    required double endOpacity,
    required Duration animationDuration,
  }) {
    return OverlayEntry(
      builder: (context) => _ToastOverlayWidget(
        content: content,
        beginOpacity: beginOpacity,
        endOpacity: endOpacity,
        animationDuration: animationDuration,
      ),
    );
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  final Widget content;
  final double beginOpacity;
  final double endOpacity;
  final Duration animationDuration;

  const _ToastOverlayWidget({
    required this.content,
    required this.beginOpacity,
    required this.endOpacity,
    required this.animationDuration,
  });

  @override
  _ToastOverlayWidgetState createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget> {
  late double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = widget.beginOpacity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = widget.endOpacity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      curve: Curves.easeInOut,
      duration: widget.animationDuration,
      child: widget.content,
    );
  }
}
