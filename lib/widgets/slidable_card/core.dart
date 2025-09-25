import 'package:core_kosmos/core_package.dart';
import 'package:twogather/widgets/slidable_card/provider/card_animation_provider.dart';
import 'package:twogather/widgets/slidable_card/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;

final cardAnimationProvider = ChangeNotifierProvider<CardAnimationProvider>((
  ref,
) {
  return CardAnimationProvider();
});

enum SwipingDirection { left, right, none }

class SlidableCard<T> extends StatefulHookConsumerWidget {
  final Size size;
  final Function(SwipingDirection, T)? onSwipe;
  final void Function()? onTapRight;
  final void Function()? onTapLeft;

  final T data;
  final Widget Function(BuildContext, WidgetRef, T) cardBuilder;

  final bool isDraggable;

  /// Theme
  final String? themeName;
  final SlidableCardThemeData? theme;

  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final BoxBorder? border;

  const SlidableCard({
    super.key,
    this.onSwipe,
    this.onTapLeft,
    this.onTapRight,
    required this.size,
    required this.data,
    required this.cardBuilder,
    this.isDraggable = true,
    this.theme,
    this.themeName,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
    this.border,
  });

  @override
  ConsumerState<SlidableCard<T>> createState() => _SlidableCardState<T>();
}

class _SlidableCardState<T> extends ConsumerState<SlidableCard<T>> {
  late final SlidableCardThemeData _themeData;

  @override
  void initState() {
    _themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "slidable_card",
      () => const SlidableCardThemeData(),
    )!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: formatWidth(widget.size.width),
      height: formatHeight(widget.size.height),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: widget.isDraggable ? ref.watch(cardAnimationProvider).dx : 0,
            top: widget.isDraggable ? ref.watch(cardAnimationProvider).dy : 0,
            child: GestureDetector(
              onPanStart: (details) {
                if (widget.isDraggable) {
                  ref
                      .read(cardAnimationProvider)
                      .initDrag(details.localPosition);
                }
              },
              onPanEnd: (details) async {
                if (widget.isDraggable &&
                    (ref.read(cardAnimationProvider).dx >= 90 ||
                        ref.read(cardAnimationProvider).dx <= -90)) {
                  if (widget.onSwipe != null) {
                    widget.onSwipe!(
                      ref.read(cardAnimationProvider).direction,
                      widget.data,
                    );
                  }
                  ref.read(cardAnimationProvider).resetPosition();
                } else if (widget.isDraggable) {
                  ref.read(cardAnimationProvider).resetPosition();
                }
              },
              onPanUpdate: (details) {
                if (widget.isDraggable) {
                  ref
                      .read(cardAnimationProvider)
                      .updatePosition(details.localPosition);
                }
              },
              onPanCancel: () =>
                  ref.read(cardAnimationProvider).resetPosition(),
              child: Transform.rotate(
                angle: widget.isDraggable
                    ? (math.pi / 180) *
                          (ref.watch(cardAnimationProvider).dx / 15)
                    : 0,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: formatWidth(widget.size.width),
                  height: formatHeight(widget.size.height),
                  decoration: BoxDecoration(
                    color:
                        widget.backgroundColor ??
                        _themeData.backgroundColor ??
                        Colors.transparent,
                    borderRadius:
                        widget.borderRadius ??
                        _themeData.borderRadius ??
                        BorderRadius.circular(14),
                    boxShadow: widget.shadows ?? _themeData.shadows,
                    border: widget.border ?? _themeData.border,
                  ),
                  child: widget.cardBuilder(context, ref, widget.data),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
