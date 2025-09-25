import 'package:flutter/material.dart';

/// Widget Badge pour afficher le nombre de notifications non lues
///
/// Affiche un badge rouge avec le nombre de notifications non lues
/// sur le coin supérieur droit du widget enfant.
///
/// Utilisation :
/// ```dart
/// NotificationBadge(
///   count: 5,
///   child: Icon(Icons.notifications),
/// )
/// ```
class NotificationBadge extends StatelessWidget {
  /// Widget enfant sur lequel afficher le badge
  final Widget child;

  /// Nombre de notifications non lues
  final int count;

  /// Couleur de fond du badge (par défaut rouge)
  final Color? backgroundColor;

  /// Couleur du texte du badge (par défaut blanc)
  final Color? textColor;

  /// Taille du badge (par défaut 18)
  final double? size;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.count,
    this.backgroundColor,
    this.textColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.red,
                borderRadius: BorderRadius.circular(100),
              ),
              constraints: BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: count > 99 ? 9.0 : 10.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
