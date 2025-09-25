import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

class SoundLevelFormField extends FormField<int> {
  final int? activeValue;
  final void Function(int?) onChanged;
  final String? fieldName;
  final TextStyle? fieldNameStyle;

  final double? width;
  final double? height;
  final double? spacing;
  final Color? activeColor;
  final Color? color;
  final BorderRadiusGeometry? radius;

  final CustomFormFieldThemeData? theme;
  final String? themeName;

  SoundLevelFormField({
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
  }) : super(
          initialValue: activeValue,
          builder: (field) {
            void onChangedHandler(int? value) {
              field.didChange(value);
              onChanged(value);
            }

            final themeData = loadThemeData(theme, themeName ?? "input_field",
                () => const CustomFormFieldThemeData())!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fieldName != null) ...[
                  Text(
                    fieldName,
                    style: fieldNameStyle ??
                        themeData.fieldNameStyle ??
                        const TextStyle(
                            color: Color(0xFF02132B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                  ),
                  sh(13),
                ],
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        onChangedHandler(0);
                      },
                      child: Container(
                        width: width ?? formatWidth(47),
                        height: height ?? formatWidth(47),
                        decoration: BoxDecoration(
                          borderRadius:
                              radius ?? BorderRadius.circular(formatWidth(47)),
                          color: activeValue == 0
                              ? activeColor ?? Colors.black
                              : color ?? Colors.white,
                          border: Border.all(
                              width: 1, color: activeColor ?? Colors.black),
                        ),
                        child: Center(
                            child: SvgPicture.asset("assets/svg/ic_sound_1.svg",
                                colorFilter: ColorFilter.mode(activeValue == 0
                                    ? color ?? Colors.white
                                    : activeColor ?? Colors.black, BlendMode.srcIn))),
                      ),
                    ),
                    sw(spacing ?? 27),
                    InkWell(
                      onTap: () {
                        onChangedHandler(1);
                      },
                      child: Container(
                        width: width ?? formatWidth(47),
                        height: height ?? formatWidth(47),
                        decoration: BoxDecoration(
                          borderRadius:
                              radius ?? BorderRadius.circular(formatWidth(47)),
                          color: activeValue == 1
                              ? activeColor ?? Colors.black
                              : color ?? Colors.white,
                          border: Border.all(
                              width: 1, color: activeColor ?? Colors.black),
                        ),
                        child: Center(
                            child: SvgPicture.asset("assets/svg/ic_sound_2.svg",
                                colorFilter: ColorFilter.mode(activeValue == 1
                                    ? color ?? Colors.white
                                    : activeColor ?? Colors.black, BlendMode.srcIn))),
                      ),
                    ),
                    sw(spacing ?? 27),
                    InkWell(
                      onTap: () {
                        onChangedHandler(2);
                      },
                      child: Container(
                        width: width ?? formatWidth(47),
                        height: height ?? formatWidth(47),
                        decoration: BoxDecoration(
                          borderRadius:
                              radius ?? BorderRadius.circular(formatWidth(47)),
                          color: activeValue == 2
                              ? activeColor ?? Colors.black
                              : color ?? Colors.white,
                          border: Border.all(
                              width: 1, color: activeColor ?? Colors.black),
                        ),
                        child: Center(
                            child: SvgPicture.asset("assets/svg/ic_sound_3.svg",
                                colorFilter: ColorFilter.mode(activeValue == 2
                                    ? color ?? Colors.white
                                    : activeColor ?? Colors.black, BlendMode.srcIn))),
                      ),
                    ),
                  ],
                ),
                sh(12),
                field.isValid
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(
                          field.errorText ?? "",
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 13.0,
                          ),
                        ),
                      ),
              ],
            );
          },
        );

  @override
  SoundLevelFormFieldState createState() => SoundLevelFormFieldState();
}

class SoundLevelFormFieldState extends FormFieldState<int> {
  @override
  SoundLevelFormField get widget => super.widget as SoundLevelFormField;
}
