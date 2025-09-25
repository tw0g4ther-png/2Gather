import 'dart:async';

import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

class SubPageFormField<T> extends FormField<T> {
  final T? activeValue;
  final void Function(T?) onChanged;
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

  SubPageFormField({
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
    required FutureOr<T?> Function() onTap,
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
                  sh(4),
                ],
                InkWell(
                  onTap: () async {
                    onChangedHandler(await onTap());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          hint ?? "Clic here…",
                          style: hintStyle ??
                              themeData.hintStyle ??
                              TextStyle(
                                color: const Color(0xFF02132B).withValues(alpha: .75),
                                fontWeight: FontWeight.w500,
                                fontSize: sp(13),
                              ),
                        ),
                      ),
                      sw(8),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: const Color(0xFF02132B), size: formatWidth(18))
                    ],
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
                sh(4),
                const Divider(),
              ],
            );
          },
        );

  @override
  SubPageFormFieldState<T> createState() => SubPageFormFieldState<T>();
}

class SubPageFormFieldState<T> extends FormFieldState<T> {
  @override
  SubPageFormField<T> get widget => super.widget as SubPageFormField<T>;
}
