import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomToast {
  static const _dismissDuration = Duration(milliseconds: 300);
  static const _fadeDuration = Duration(milliseconds: 200);

  static late BuildContext _overlayContext;
  static OverlayEntry? _currentOverlay;
  static Timer? _dismissTimer;

  static void init(BuildContext overlayContext) {
    _overlayContext = overlayContext;
  }

  static void show(Widget body, {Duration? dismissAfter}) {
    _dismissTimer?.cancel();
    if (_currentOverlay?.mounted == true) {
      _currentOverlay?.remove();
      _currentOverlay = null;
    }

    final overlay = OverlayEntry(
      builder: (context) => _ToastOverlayWidget(
        content: body,
        duration: dismissAfter ?? const Duration(seconds: 2),
        onDismiss: () => _dismiss(),
      ),
    );

    _currentOverlay = overlay;

    if (!_overlayContext.mounted) return;
    Overlay.of(_overlayContext).insert(overlay);
  }

  static void _dismiss() {
    if (_currentOverlay?.mounted == true) {
      _currentOverlay?.remove();
      _currentOverlay = null;
    }
    _dismissTimer?.cancel();
    _dismissTimer = null;
  }

  static void cleanup() {
    _dismissTimer?.cancel();
    if (_currentOverlay?.mounted == true) {
      _currentOverlay?.remove();
    }
    _currentOverlay = null;
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  final Widget content;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastOverlayWidget({
    required this.content,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastOverlayWidget> createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _hide();
      }
    });
  }

  void _hide() {
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Material(
            color: Colors.transparent,
            child: Center(child: widget.content),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
