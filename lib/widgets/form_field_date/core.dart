import 'package:core_kosmos/core_package.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

class DateTimeFormField extends FormField<dz.Tuple2<DateTime?, DateTime?>> {
  final dz.Tuple2<DateTime?, DateTime?>? activeValue;
  final void Function(dz.Tuple2<DateTime?, DateTime?>?) onChanged;
  final String? fieldName;
  final TextStyle? fieldNameStyle;
  final String? hint;
  final TextStyle? hintStyle;

  final double? width;
  final double? height;
  final double? spacing;
  final Color? activeColor;
  final Color? color;
  final BorderRadiusGeometry? radius;

  final CustomFormFieldThemeData? theme;
  final String? themeName;

  DateTimeFormField({
    super.key,
    this.activeValue,
    required this.onChanged,
    super.validator,
    this.activeColor,
    this.color,
    this.height,
    this.width,
    this.spacing,
    this.radius,
    this.fieldName,
    this.fieldNameStyle,
    this.theme,
    this.themeName,
    this.hint,
    this.hintStyle,
  }) : super(
          initialValue: activeValue,
          builder: (field) {
            return Container();
          },
        );

  @override
  DateTimeFormFieldState createState() => DateTimeFormFieldState();
}

class DateTimeFormFieldState
    extends FormFieldState<dz.Tuple2<DateTime?, DateTime?>> {
  @override
  DateTimeFormField get widget => super.widget as DateTimeFormField;

  @override
  Widget build(BuildContext context) {
    void onChangedHandler(dz.Tuple2<DateTime?, DateTime?>? value) {
      didChange(value);
      widget.onChanged(value);
    }

    final themeData = loadThemeData(
        widget.theme,
        widget.themeName ?? "input_field",
        () => const CustomFormFieldThemeData())!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.fieldName != null) ...[
          Text(
            widget.fieldName!,
            style: widget.fieldNameStyle ??
                themeData.fieldNameStyle ??
                const TextStyle(
                    color: Color(0xFF02132B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
          ),
          sh(6),
        ],
        Container(
          width: double.infinity,
          height: widget.height ?? formatHeight(54),
          decoration: BoxDecoration(
            borderRadius: widget.radius ?? BorderRadius.circular(7),
            color: themeData.backgroundColor ??
                const Color(0xFF02132B).withValues(alpha: .03),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: formatWidth(35), vertical: formatHeight(7.5)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      initialDate: value?.value1 ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (!context.mounted) return;
                    final hour = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 0, minute: 0),
                    );
                    final finalDate = DateTime(
                      date?.year ?? now.year,
                      date?.month ?? now.month,
                      date?.day ?? now.day,
                      hour?.hour ?? now.hour,
                      hour?.minute ?? now.minute,
                    );
                    onChangedHandler(dz.Tuple2<DateTime?, DateTime?>(
                        finalDate, value?.value2));
                  },
                  child: Text(
                    value?.value1 != null
                        ? "${value!.value1!.day.toString().padLeft(2, "0")}/${value!.value1!.month.toString().padLeft(2, "0")}/${value!.value1!.year} - ${value!.value1!.hour.toString().padLeft(2, "0")}:${value!.value1!.minute.toString().padLeft(2, "0")}"
                        : "utils.start".tr(),
                    style: TextStyle(
                      color: const Color(0xFF02132B).withValues(alpha: .4),
                      fontSize: sp(13),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              sw(20),
              Container(
                  color: widget.color ?? Colors.black,
                  width: 1,
                  height: double.infinity),
              sw(20),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      initialDate: value?.value1 ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (!context.mounted) return;
                    final hour = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 0, minute: 0),
                    );
                    final finalDate = DateTime(
                      date?.year ?? now.year,
                      date?.month ?? now.month,
                      date?.day ?? now.day,
                      hour?.hour ?? now.hour,
                      hour?.minute ?? now.minute,
                    );
                    onChangedHandler(dz.Tuple2<DateTime?, DateTime?>(
                        value?.value1, finalDate));
                  },
                  child: Text(
                    value?.value2 != null
                        ? "${value!.value2!.day.toString().padLeft(2, "0")}/${value!.value2!.month.toString().padLeft(2, "0")}/${value!.value2!.year} - ${value!.value2!.hour.toString().padLeft(2, "0")}:${value!.value2!.minute.toString().padLeft(2, "0")}"
                        : "utils.end".tr(),
                    style: TextStyle(
                      color: const Color(0xFF02132B).withValues(alpha: .4),
                      fontSize: sp(13),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        isValid
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text(
                  errorText ?? "",
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 13.0,
                  ),
                ),
              ),
      ],
    );
  }
}
