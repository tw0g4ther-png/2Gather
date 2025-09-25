import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/form/theme.dart';

enum FormFieldType {
  /// default
  text,
  email,
  textArea,
  phone,

  /// security
  password,

  ///misc
  date,
  dropdown,
  numberplate,
  image,
  imageMultiple,
  file,
  slide,
  range,
  checker,
  number,
}

class FieldModel {
  final String tag;
  final FormFieldType type;
  final String? placeholder;
  final String? fieldName;
  final String? Function(dynamic)? validator;
  final CustomFormFieldThemeData? theme;

  const FieldModel({
    required this.tag,
    required this.type,
    this.fieldName,
    this.placeholder,
    this.validator,
    this.theme,
  });
}

class FieldFormModel {
  final String tag;
  final FormFieldType type;
  final String? Function(dynamic)? validator;
  final String? placeholder;
  final String? fieldName;
  final dynamic initialValue;
  final String? initialValuePicture;
  final VoidCallback? onTapSuffix;
  final VoidCallback? onTap;

  final String? suffix;
  final String? subFieldText;
  final CustomFormFieldThemeData? theme;
  final void Function(dynamic)? onChanged;
  final List<DropdownMenuItem<Object>>? dropdownItems;
  final Widget? child;
  final String? defaultImageUrl;

  /// authorizations
  final bool requiredForForm;
  final bool requiredForNextStep;

  ///Slider
  final double sliderMinValue;
  final double sliderMaxValue;

  const FieldFormModel({
    required this.tag,
    this.type = FormFieldType.text,
    this.validator,
    this.onTap,
    this.fieldName,
    this.placeholder,
    this.initialValue,
    this.initialValuePicture,
    this.suffix,
    this.onTapSuffix,
    this.theme,
    this.subFieldText,
    this.onChanged,
    this.child,
    this.defaultImageUrl,

    ///authorizations
    this.requiredForNextStep = true,
    this.requiredForForm = false,

    ///Slider
    this.sliderMinValue = 0,
    this.sliderMaxValue = 100,

    ///Dropdown
    this.dropdownItems,
  }) : assert(sliderMinValue < sliderMaxValue);
}
