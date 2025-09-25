import 'package:core_kosmos/core_package.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

class CupertinoPickerFormField<T> extends FormField<T> {
  final T? activeValue;
  final List<T>? values;
  final void Function(T?) onChanged;
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

  CupertinoPickerFormField({
    super.key,
    this.activeValue,
    required this.onChanged,
    required this.values,
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
            void onChangedHandler(T? value) {
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
                SizedBox(
                  height: formatHeight(178),
                  child: CupertinoPicker(
                    itemExtent: formatHeight(30),
                    onSelectedItemChanged: (val) =>
                        onChangedHandler(values![val]),
                    children: values?.map((value) {
                          return Text(
                            value.toString(),
                            // style: themeData.itemStyle ?? const TextStyle(color: Color(0xFF02132B), fontSize: 12, fontWeight: FontWeight.w500),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
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
  CupertinoPickerFormFieldState<T> createState() =>
      CupertinoPickerFormFieldState<T>();
}

class CupertinoPickerFormFieldState<T> extends FormFieldState<T> {
  @override
  CupertinoPickerFormField<T> get widget =>
      super.widget as CupertinoPickerFormField<T>;
}
