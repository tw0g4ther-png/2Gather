import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

/// Alternative à keyboard_attachable pour Flutter 3.29.0
/// Fournit un layout avec footer qui s'adapte au clavier
class FooterLayout extends StatelessWidget {
  final Widget child;
  final Widget footer;
  final Duration animationDuration;

  const FooterLayout({
    super.key,
    required this.child,
    required this.footer,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Column(
          children: [
            Expanded(child: child),
            AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              child: footer,
            ),
          ],
        );
      },
    );
  }
}

/// Widget qui s'attache au clavier avec animation
class KeyboardAttachable extends StatelessWidget {
  final Widget child;
  final Duration animationDuration;

  const KeyboardAttachable({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          child: child,
        );
      },
    );
  }
}
