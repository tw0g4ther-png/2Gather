import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/form/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Composant moderne de dropdown qui respecte le thème de l'application 2Gather
///
/// Utilise un design moderne avec :
/// - Bordures arrondies (30px par défaut)
/// - Couleur de fond subtile
/// - Ombre légère
/// - Icône colorée avec la couleur principale
/// - Styles de texte cohérents
class ModernDropdownField<T> extends HookWidget {
  final CustomFormFieldThemeData? theme;
  final String? fieldName;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final TextStyle? fieldNameStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool isRequired;

  const ModernDropdownField({
    super.key,
    this.theme,
    this.fieldName,
    this.hintText,
    this.value,
    this.items,
    this.onChanged,
    this.validator,
    this.fieldNameStyle,
    this.hintTextStyle,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.borderRadius,
    this.contentPadding,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      theme,
      "input_field",
      () => const CustomFormFieldThemeData(),
    )!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldName != null) ...[
          Text(
            isRequired ? "$fieldName*" : fieldName!,
            style:
                fieldNameStyle ??
                themeData.fieldNameStyle ??
                TextStyle(
                  color: const Color(0xFF02132B),
                  fontSize: sp(12),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 7),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            border: Border.all(
              color: borderColor ?? const Color(0xFFE5E7EB),
              width: 1,
            ),
            color:
                backgroundColor ??
                const Color(0xFF02132B).withValues(alpha: 0.03),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            initialValue: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: hintText ?? "Sélectionner",
              hintStyle:
                  hintTextStyle ??
                  TextStyle(
                    color: const Color(0xFF737D8A),
                    fontSize: sp(13),
                    fontWeight: FontWeight.w400,
                  ),
            ),
            style:
                textStyle ??
                TextStyle(
                  color: const Color(0xFF02132B),
                  fontSize: sp(13),
                  fontWeight: FontWeight.w500,
                ),
            icon: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color:
                    iconColor ?? const Color(0xFFEF561D), // AppColor.mainColor
                size: 24,
              ),
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            dropdownColor: Colors.white,
            elevation: 8,
            isExpanded: true,
            items: items ?? [],
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
