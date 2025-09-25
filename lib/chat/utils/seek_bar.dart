import 'dart:math';

import '../chatColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final bool meSender;
  final String? durationString;
  final Duration position;
  final Color trackColor;
  final Color thumbColor;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final ValueChanged<double>? onChangedStart;

  const SeekBar({
    super.key,
    required this.duration,
    this.durationString,
    required this.meSender,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.onChangedStart,
    required this.thumbColor,
    required this.trackColor,
  });

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Container(
          //   child: SliderTheme(
          //     data: _sliderThemeData.copyWith(
          //       thumbShape: HiddenThumbComponentShape(),
          //       activeTrackColor: Colors.transparent,
          //       inactiveTrackColor: Colors.grey.shade300,
          //     ),
          //     child: ExcludeSemantics(
          //       child: Slider(
          //         min: 0.0,
          //         max: widget.duration.inMilliseconds.toDouble(),
          //         value: min(widget.bufferedPosition.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
          //         onChanged: (value) {
          //           setState(() {
          //             _dragValue = value;
          //           });
          //           if (widget.onChanged != null) {
          //             widget.onChanged!(Duration(milliseconds: value.round()));
          //           }
          //         },
          //         onChangeEnd: (value) {
          //           if (widget.onChangeEnd != null) {
          //             widget.onChangeEnd!(Duration(milliseconds: value.round()));
          //           }
          //           _dragValue = null;
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 130.w,
            height: 30.h,
            child: SliderTheme(
              data: _sliderThemeData.copyWith(
                inactiveTrackColor: const Color(0XFF000000).withValues(alpha: 0.07),
                activeTrackColor: widget.trackColor,
                thumbColor: widget.thumbColor,
                trackShape: CustomTrackShape(),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                onChangeStart: widget.onChangedStart,
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                    _dragValue ?? widget.position.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),
          Positioned(
            left: -12.w,
            bottom: -10.h,
            child: Text(
                widget.durationString ??
                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_remaining")
                        ?.group(1) ??
                    '$_remaining',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: widget.meSender
                        ? ChatColor.buuble_audio_right_duration
                        : ChatColor.buuble_audio_left_duration)),
          ),
        ],
      ),
    );
  }

  Duration get _remaining => widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
