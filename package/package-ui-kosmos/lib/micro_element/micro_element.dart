import 'dart:math' as math;

import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/micro_element/theme.dart';

class LoaderClassique extends StatefulWidget {
  final bool? animating;
  final double? radius;
  final int? tickCount;
  final Color? activeColor;
  final Duration? animationDuration;
  final double relativeWidth;
  final double? startRatio = 0.5;
  final double? endRatio = 1.0;
  final ClassicLoaderThemeData? theme;

  /// Creates a highly customizable activity indicator.
  const LoaderClassique({
    super.key,
    this.animating = true,
    this.radius,
    this.tickCount = 12,
    this.activeColor,
    this.animationDuration,
    this.relativeWidth = 1,
    this.theme,
  });

  @override
  NutsActivityIndicatorState createState() => NutsActivityIndicatorState();
}

class NutsActivityIndicatorState extends State<LoaderClassique>
    with SingleTickerProviderStateMixin {
  late AnimationController? _animationController;
  late final ClassicLoaderThemeData themeData;

  @override
  void initState() {
    super.initState();
    themeData = loadThemeData(
      widget.theme,
      "classic_loader",
      () => const ClassicLoaderThemeData(),
    )!;
    _animationController = AnimationController(
      duration:
          widget.animationDuration ??
          themeData.duration ??
          const Duration(milliseconds: 800),
      vsync: this,
    );
    if (widget.animating!) {
      _animationController!.repeat();
    }
  }

  @override
  void didUpdateWidget(LoaderClassique oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating!) {
        _animationController!.repeat();
      } else {
        _animationController!.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius ?? themeData.radius ?? 30 * 2,
      width: widget.radius ?? themeData.radius ?? 30 * 2,
      child: CustomPaint(
        painter: _NutsActivityIndicatorPainter(
          animationController: _animationController!,
          radius: widget.radius ?? themeData.radius ?? 30,
          tickCount: widget.tickCount!,
          activeColor:
              widget.activeColor ??
              themeData.activeColor ??
              const Color(0xFF02132B),
          relativeWidth: widget.relativeWidth,
          startRatio: widget.startRatio!,
          endRatio: widget.endRatio!,
        ),
      ),
    );
  }
}

class _NutsActivityIndicatorPainter extends CustomPainter {
  final int _halfTickCount;
  final Animation<double> animationController;
  final Color activeColor;

  final double relativeWidth;
  final int tickCount;
  final double radius;
  final RRect _tickRRect;
  final double startRatio;
  final double endRatio;

  _NutsActivityIndicatorPainter({
    required this.radius,
    required this.tickCount,
    required this.animationController,
    required this.activeColor,
    required this.relativeWidth,
    required this.startRatio,
    required this.endRatio,
  }) : _halfTickCount = tickCount ~/ 2,
       _tickRRect = RRect.fromLTRBXY(
         -radius * endRatio,
         relativeWidth * radius / 10,
         -radius * startRatio,
         -relativeWidth * radius / 10,
         10,
         10,
       ),
       super(repaint: animationController);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2);
    final activeTick = (tickCount * animationController.value).floor();
    for (int i = 0; i < tickCount; ++i) {
      paint.color = Color.lerp(
        activeColor,
        activeColor.withValues(alpha: 0.2),
        ((i + activeTick) % tickCount) / _halfTickCount,
      )!;
      canvas
        ..drawRRect(_tickRRect, paint)
        ..rotate(-math.pi * 2 / tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_NutsActivityIndicatorPainter oldPainter) {
    return oldPainter.animationController != animationController;
  }
}

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final double? height;
  final Color? color;
  final Color? backColor;
  final Duration? duration;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final String? customSmallTitle;
  final String? customBigTitle;
  final ProgressBarThemeData? theme;
  final bool? showPercentage;
  final TextStyle? percentageStyle;
  final List<String>? items;

  const ProgressBar({
    super.key,
    required this.max,
    required this.current,
    this.backColor,
    this.color,
    this.duration,
    this.borderRadius,
    this.height,
    this.customBigTitle,
    this.customSmallTitle,
    this.textStyle,
    this.theme,
    this.showPercentage,
    this.percentageStyle,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      "progress_bar",
      () => const ProgressBarThemeData(),
    )!;

    return Column(
      crossAxisAlignment: customSmallTitle != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          customSmallTitle ??
              customBigTitle ??
              '${(current / max * 100).toInt()}%',
          style:
              textStyle ??
              themeData.style ??
              const TextStyle(
                color: Color(0xFF02132B),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
        ),
        sh(7),
        LayoutBuilder(
          builder: (_, boxConstraints) {
            var x = boxConstraints.maxWidth;
            var percent = (current / max) * x;
            return Stack(
              children: [
                Container(
                  width: x,
                  height: height ?? themeData.height ?? 10,
                  decoration: BoxDecoration(
                    color:
                        backColor ??
                        themeData.backColor ??
                        const Color(0xFFE2E4E7),
                    borderRadius:
                        borderRadius ??
                        themeData.borderRadius ??
                        BorderRadius.circular(8),
                  ),
                ),
                AnimatedContainer(
                  duration: duration ?? themeData.duration ?? Duration.zero,
                  width: percent,
                  height: height ?? themeData.height ?? 10,
                  decoration: BoxDecoration(
                    color: color ?? themeData.color ?? const Color(0xFF02132B),
                    borderRadius:
                        borderRadius ??
                        themeData.borderRadius ??
                        BorderRadius.circular(8),
                  ),
                ),
                if (showPercentage ?? false)
                  Positioned(
                    left: formatWidth(11),
                    top: 0,
                    bottom: 0,
                    child: Text(
                      "${(current / max * 100).toInt()}%",
                      style:
                          percentageStyle ??
                          themeData.percentageStyle ??
                          TextStyle(
                            color: Colors.white,
                            fontSize: sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  factory ProgressBar.separated({
    required double max,
    required double current,
    double? height,
    Color? color,
    Color? backColor,
    Duration? duration,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    String? customSmallTitle,
    String? customBigTitle,
    ProgressBarThemeData? theme,
    bool? showPercentage,
    TextStyle? percentageStyle,
    List<String>? items,
  }) = _ProgressSeparated;
}

class _ProgressSeparated extends ProgressBar {
  _ProgressSeparated({
    required super.max,
    required super.current,
    super.height,
    super.color,
    super.backColor,
    super.duration,
    super.borderRadius,
    super.textStyle,
    super.customSmallTitle,
    super.customBigTitle,
    super.theme,
    super.showPercentage,
    super.percentageStyle,
    super.items,
  }) {
    assert(items != null ? items!.length == max : true);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      "progress_bar",
      () => const ProgressBarThemeData(),
    )!;

    return Column(
      crossAxisAlignment: customSmallTitle != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          customSmallTitle ??
              customBigTitle ??
              '${(current / max * 100).toInt()}%',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              textStyle ??
              themeData.style ??
              const TextStyle(
                color: Color(0xFF02132B),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
        ),
        sh(7),
        LayoutBuilder(
          builder: (_, boxConstraints) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < max; i++) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: height ?? themeData.height ?? 10,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: height ?? themeData.height ?? 10,
                                      decoration: BoxDecoration(
                                        color:
                                            backColor ??
                                            themeData.backColor ??
                                            const Color(0xFFE2E4E7),
                                        borderRadius:
                                            borderRadius ??
                                            themeData.borderRadius ??
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          duration ??
                                          themeData.duration ??
                                          Duration.zero,
                                      width: current >= i ? double.infinity : 0,
                                      height: height ?? themeData.height ?? 10,
                                      decoration: BoxDecoration(
                                        color:
                                            color ??
                                            themeData.color ??
                                            const Color(0xFF02132B),
                                        borderRadius:
                                            borderRadius ??
                                            themeData.borderRadius ??
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    if ((showPercentage ?? false) &&
                                        current == i)
                                      Positioned(
                                        left: formatWidth(8),
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Text(
                                                "en cours",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: sp(10),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (current > i)
                                      Positioned(
                                        left: formatWidth(8),
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: sp(14),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (items != null) ...[
                          sh(5),
                          Text(
                            items![i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                themeData.style?.copyWith(
                                  fontSize: getResponsiveValue(
                                    context,
                                    defaultValue: sp(12),
                                    phone: sp(9),
                                  ),
                                ) ??
                                TextStyle(
                                  color: const Color(0xFF02132B),
                                  fontSize: getResponsiveValue(
                                    context,
                                    defaultValue: sp(12),
                                    phone: sp(9),
                                  ),
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  sw(8),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

/// SPINKIT CODE
class ThreeBounce extends StatefulWidget {
  const ThreeBounce({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration,
    this.controller,
    this.theme,
  }) : assert(
         !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
             !(itemBuilder == null && color == null),
         'You should specify either a itemBuilder or a color',
       );

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration? duration;
  final AnimationController? controller;
  final ClassicLoaderThemeData? theme;

  @override
  ThreeBounceState createState() => ThreeBounceState();
}

class ThreeBounceState extends State<ThreeBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final ClassicLoaderThemeData themeData;
  @override
  void initState() {
    super.initState();
    themeData = loadThemeData(
      widget.theme,
      "classic_loader",
      () => const ClassicLoaderThemeData(),
    )!;

    _controller =
        (widget.controller ??
              AnimationController(
                vsync: this,
                duration:
                    widget.duration ??
                    themeData.duration ??
                    const Duration(milliseconds: 1400),
              ))
          ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(
                begin: 0.0,
                end: 1.0,
                delay: i * .2,
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size.square(widget.size * 0.5),
                child: _itemBuilder(i),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color ?? themeData.activeColor,
            shape: BoxShape.circle,
          ),
        );
}

class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
