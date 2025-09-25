// ignore_for_file: unused_element

import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/widgets/multiple_dropdown_selection/theme.dart';
import 'package:flutter/material.dart';
// Remplacé states_rebuilder par ValueNotifier natif
import 'package:ui_kosmos_v4/form/theme.dart';

// Remplacement de states_rebuilder par ValueNotifier
final ValueNotifier<int> _rebuildNotifier = ValueNotifier<int>(0);

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  final BoxDecoration? childActiveDecoration;
  final BoxDecoration? childDecoration;
  final Color? checkedColor;
  final IconData? checkedIcon;
  final TextStyle? childTextStyle;
  final TextStyle? childActiveTextStyle;
  final DropDownMultiSelectThemeData? theme;

  const _SelectRow({
    required this.onChange,
    required this.selected,
    required this.text,
    this.checkedColor,
    this.checkedIcon,
    this.childActiveDecoration,
    this.childActiveTextStyle,
    this.childDecoration,
    this.childTextStyle,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!selected);
        _rebuildNotifier.value++;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: formatWidth(12)),
        decoration: selected
            ? childActiveDecoration ??
                  theme?.childActiveDecoration ??
                  childDecoration ??
                  theme?.childDecoration
            : childDecoration ??
                  theme?.childDecoration ??
                  const BoxDecoration(color: Colors.white),
        height: kMinInteractiveDimension,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                text,
                style: selected
                    ? childActiveTextStyle ??
                          theme?.childActiveTextStyle ??
                          childTextStyle ??
                          theme?.childTextStyle
                    : childTextStyle ?? theme?.childTextStyle,
              ),
            ),
            sw(12),
            Icon(
              checkedIcon ?? theme?.checkedIcon ?? Icons.check_rounded,
              color: selected
                  ? checkedColor ?? theme?.checkedColor ?? Colors.black
                  : Colors.transparent,
              size: formatWidth(18),
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownMultiSelect<T> extends StatefulWidget {
  /// The options form which a user can select
  final List<T> options;

  /// Selected Values
  final List<T> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<T>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration? decoration;

  /// this text is shown when there is no selection
  final String? whenEmpty;

  /// a function to build custom childern
  final Widget Function(List<T> selectedValues)? childBuilder;

  /// a function to build custom menu items
  final Widget Function(T option)? menuItembuilder;

  /// a function to validate
  final String Function(T? selectedOptions)? validator;

  /// defines whether the widget is read-only
  final bool readOnly;

  /// icon shown on the right side of the field
  final Widget? icon;

  /// Textstyle for the hint
  final TextStyle? hintStyle;

  /// hint to be shown when there's nothing else to be shown
  final Widget? hint;

  final int maxItem;

  /// Theme
  final BoxDecoration? childActiveDecoration;
  final BoxDecoration? childDecoration;
  final Color? checkedColor;
  final IconData? checkedIcon;
  final TextStyle? childTextStyle;
  final TextStyle? childActiveTextStyle;
  final String? themeName;
  final DropDownMultiSelectThemeData? theme;

  final bool error;
  final String? errorMessage;
  final TextStyle? fieldNameStyle;
  final TextStyle? fieldPostRedirectionStyle;
  final String? fieldName;
  final String? fieldPostRedirection;
  final VoidCallback? postFieldOnClick;

  const DropDownMultiSelect({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.whenEmpty,
    this.icon,
    this.hint,
    this.hintStyle,
    this.childBuilder,
    this.menuItembuilder,
    this.isDense = true,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.readOnly = false,
    this.checkedColor,
    this.checkedIcon,
    this.childActiveDecoration,
    this.childDecoration,
    this.childTextStyle,
    this.childActiveTextStyle,
    this.theme,
    this.themeName,
    this.maxItem = 100,
    this.error = false,
    this.errorMessage,
    this.fieldNameStyle,
    this.fieldName,
    this.fieldPostRedirection,
    this.postFieldOnClick,
    this.fieldPostRedirectionStyle,
  });

  @override
  State<DropDownMultiSelect<T>> createState() => _DropDownMultiSelectState<T>();
}

class _DropDownMultiSelectState<T> extends State<DropDownMultiSelect<T>> {
  late final DropDownMultiSelectThemeData themeData;
  final CustomFormFieldThemeData inputTheme = loadThemeData(
    null,
    "input_field",
    () => const CustomFormFieldThemeData(),
  )!;

  @override
  void initState() {
    themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "dropdown_multi_select",
      () => const DropDownMultiSelectThemeData(),
    )!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            (widget.error) && (widget.errorMessage != null)
                ? Text(
                    widget.errorMessage ?? "",
                    style:
                        widget.fieldNameStyle?.copyWith(color: Colors.red) ??
                        inputTheme.fieldNameStyle?.copyWith(
                          color: Colors.red,
                        ) ??
                        const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                  )
                : widget.fieldName != null
                ? Text(
                    widget.fieldName!,
                    style:
                        widget.fieldNameStyle ??
                        inputTheme.fieldNameStyle ??
                        const TextStyle(
                          color: Color(0xFF02132B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                : Container(),
            widget.fieldPostRedirection == null
                ? const SizedBox()
                : const Spacer(),
            widget.fieldPostRedirection == null
                ? const SizedBox()
                : InkWell(
                    onTap: widget.postFieldOnClick,
                    child: Text(
                      widget.fieldPostRedirection!,
                      style:
                          widget.fieldPostRedirectionStyle ??
                          inputTheme.fieldPostRedirectionStyle ??
                          const TextStyle(
                            color: Color(0xFF02132B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
          ],
        ),
        sh(7),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _rebuildNotifier,
              builder: (context, value, child) => widget.childBuilder != null
                  ? widget.childBuilder!(widget.selectedValues)
                  : Padding(
                      padding: widget.decoration != null
                          ? widget.decoration!.contentPadding != null
                                ? widget.decoration!.contentPadding!
                                : const EdgeInsets.symmetric(horizontal: 10)
                          : const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "${widget.selectedValues.length} ${"utils.choices".plural(widget.selectedValues.length)}",
                        ),
                      ),
                    ),
            ),
            Theme(
              data: Theme.of(context).copyWith(),
              child: DropdownButtonFormField<T>(
                dropdownColor: Colors.transparent,
                elevation: 0,
                hint: widget.hint,
                style: widget.hintStyle,
                icon: widget.icon,
                validator: widget.validator,
                decoration:
                    widget.decoration ??
                    InputDecoration(
                      errorStyle: const TextStyle(fontSize: 12, height: 0),
                      prefixIconConstraints:
                          inputTheme.prefixChildBoxConstraint,
                      suffixIconConstraints:
                          inputTheme.suffixChildBoxConstraint,
                      filled: true,
                      fillColor:
                          inputTheme.backgroundColor ??
                          const Color(0xFF02132B).withValues(alpha: 0.03),
                      contentPadding:
                          inputTheme.contentPadding ??
                          const EdgeInsets.fromLTRB(9.5, 17.5, 9.5, 17.5),
                      focusedErrorBorder:
                          inputTheme.focusedErrorBorder ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 0.5,
                            ),
                          ),
                      errorBorder:
                          inputTheme.errorBorder ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 0.5,
                            ),
                          ),
                      focusedBorder: inputTheme.focusedBorder,
                      border:
                          inputTheme.border ??
                          UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                    ),
                isDense: widget.isDense,
                onChanged: widget.enabled ? (x) {} : null,
                isExpanded: false,
                initialValue: widget.selectedValues.isNotEmpty
                    ? widget.selectedValues[0]
                    : null,
                selectedItemBuilder: (context) {
                  return widget.options
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Container(color: Colors.transparent),
                        ),
                      )
                      .toList();
                },
                items: widget.options
                    .map(
                      (x) => DropdownMenuItem(
                        value: x,
                        onTap: !widget.readOnly
                            ? () {
                                if (widget.selectedValues.contains(x)) {
                                  var ns = widget.selectedValues;
                                  ns.remove(x);
                                  widget.onChanged(ns);
                                } else {
                                  var ns = widget.selectedValues;
                                  if (ns.length >= widget.maxItem) return;
                                  ns.add(x);
                                  widget.onChanged(ns);
                                }
                              }
                            : null,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _rebuildNotifier,
                          builder: (context, value, child) {
                            return widget.menuItembuilder != null
                                ? widget.menuItembuilder!(x)
                                : _SelectRow(
                                    theme: themeData,
                                    childActiveDecoration:
                                        widget.childActiveDecoration,
                                    childDecoration: widget.childDecoration,
                                    checkedColor: widget.checkedColor,
                                    checkedIcon: widget.checkedIcon,
                                    childTextStyle: widget.childTextStyle,
                                    childActiveTextStyle:
                                        widget.childActiveTextStyle,
                                    selected: widget.selectedValues.contains(x),
                                    text: x.toString(),
                                    onChange: (isSelected) {
                                      if (isSelected) {
                                        var ns = widget.selectedValues;
                                        if (ns.length >= widget.maxItem) return;
                                        ns.add(x);
                                        widget.onChanged(ns);
                                      } else {
                                        var ns = widget.selectedValues;
                                        ns.remove(x);
                                        widget.onChanged(ns);
                                      }
                                    },
                                  );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
