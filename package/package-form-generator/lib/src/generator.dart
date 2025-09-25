import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/src/model/field.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
import 'package:core_kosmos/core_kosmos.dart';

abstract class FormGenerator {
  static Widget generateField(
    BuildContext context,
    FieldFormModel field, {
    TextEditingController? controller,
    FocusNode? actual,
    FocusNode? next,
    void Function(dynamic)? onChanged,
  }) {
    switch (field.type) {
      case FormFieldType.text:
        return TextFormUpdated.classic(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          fieldPostRedirectionStyle: field.theme?.fieldPostRedirectionStyle,
          onChanged: field.onChanged ?? onChanged,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          controller: controller,
          focusNode: actual,
          nextFocusNode: next,
          textInputType: TextInputType.text,
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          subFieldText: field.subFieldText,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          defaultValue: field.initialValue,
          validator: (String? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
      case FormFieldType.email:
        return TextFormUpdated.classic(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          onChanged: field.onChanged ?? onChanged,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          controller: controller,
          fieldPostRedirectionStyle: field.theme?.fieldPostRedirectionStyle,
          focusNode: actual,
          subFieldText: field.subFieldText,
          nextFocusNode: next,
          textInputType: TextInputType.emailAddress,
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          defaultValue: field.initialValue,
          validator: (String? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
      case FormFieldType.textArea:
        return TextFormUpdated.textarea(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          onChanged: field.onChanged ?? onChanged,
          controller: controller,
          focusNode: actual,
          nextFocusNode: next,
          subFieldText: field.subFieldText,
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding,
          maxLine: field.theme?.maxLine,
          minLine: field.theme?.minLine,
          initialValue: field.initialValue,
          validator: (String? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
      case FormFieldType.password:
        final themeData = loadThemeData(
            null, "input_field", () => const CustomFormFieldThemeData())!;
        return TextFormUpdated.classic(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          onChanged: field.onChanged ?? onChanged,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          controller: controller,
          fieldPostRedirectionStyle: field.theme?.fieldPostRedirectionStyle,
          focusNode: actual,
          obscuringText: true,
          subFieldText: field.subFieldText,
          nextFocusNode: next,
          textInputType: TextInputType.visiblePassword,
          backgroundColor: field.theme?.backgroundColor,
          isUpdatable: true,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          suffixChild: Icon(Icons.remove_red_eye_outlined,
              color: themeData.suffixIconColor ?? Colors.grey),
          suffixChildActive: Icon(Icons.remove_red_eye,
              color: themeData.suffixIconColor ?? Colors.grey),
          defaultValue: field.initialValue,
          validator: (String? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
      case FormFieldType.date:
        return TextFormUpdated.dateTime(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          onChangedDate: field.onChanged ?? onChanged,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          controller: controller,
          focusNode: actual,
          subFieldText: field.subFieldText,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          fieldPostRedirectionStyle: field.theme?.fieldPostRedirectionStyle,
          nextFocusNode: next,
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          defaultDate: field.initialValue,
          validatorDate: (DateTime? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
      case FormFieldType.dropdown:
        return SelectForm(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          onChangedSelect: field.onChanged ?? onChanged,
          backgroundColor: field.theme?.backgroundColor,
          contentPadding: field.theme?.contentPadding,
          value: field.initialValue,
          items: field.dropdownItems,
          subFieldText: field.subFieldText,
        );
      case FormFieldType.numberplate:
        return TextFormUpdated.immatriculation(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          fieldPostRedirection: field.suffix,
          fieldPostRedirectionStyle: field.theme?.fieldPostRedirectionStyle,
          postFieldOnClick: field.onTapSuffix,
          hintTextStyle: field.theme?.hintStyle,
          onChanged: field.onChanged ?? onChanged,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          focusNode: actual,
          nextFocusNode: next,
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          defaultValue: field.initialValue,
          subFieldText: field.subFieldText,
          validator: (String? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
      case FormFieldType.image:
        return Input.image(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          onChanged: field.onChanged ?? onChanged,
          defaultFile: field.initialValue,
          onTap: field.onTap,
          child: field.child,
        );
      case FormFieldType.imageMultiple:
        return Input.image(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          onChanged: field.onChanged ?? onChanged,
          onTap: field.onTap,
          defaultFile: field.initialValue,
          child: field.child,
        ); // Support pour images multiples à implémenter si nécessaire
      case FormFieldType.file:
        return Input.files(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          onMultipleChanged: field.onChanged ?? onChanged,
          defaultFileList: field.initialValue,
        );
      case FormFieldType.slide:
        return CustomSlider.slider(
          min: field.sliderMinValue,
          max: field.sliderMaxValue,
          onChanged: field.onChanged ?? onChanged,
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          value:
              ((field.initialValue ?? field.sliderMinValue) as num).toDouble(),
        );
      case FormFieldType.range:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: formatWidth(20)),
          child: CustomSlider.range(
            min: field.sliderMinValue,
            max: field.sliderMaxValue,
            onChanged: field.onChanged ?? onChanged,
            fieldName:
                "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
            fieldNameStyle: field.theme?.fieldStyle,
            rangeValue: field.initialValue,
          ),
        );
      case FormFieldType.checker:
        return Selector(
          content: field.fieldName,
          onChanged: field.onChanged ?? onChanged,
          defaultChecked: field.initialValue ?? false,
        );
      case FormFieldType.phone:
        return TextFormUpdated.phoneNumber(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          validator: field.validator,
          onInputChanged: field.onChanged ?? onChanged,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          controller: controller,
          focusNode: actual,
          nextFocusNode: next,
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          initialPhoneValue: field.initialValue,
        );
      case FormFieldType.number:
        return TextFormUpdated.classic(
          fieldName:
              "${field.fieldName ?? ""}${field.requiredForForm ? "*" : ""}",
          fieldNameStyle: field.theme?.fieldStyle,
          hintText: field.placeholder,
          hintTextStyle: field.theme?.hintStyle,
          fieldPostRedirectionStyle: field.theme?.fieldPostRedirectionStyle,
          onChanged: field.onChanged ?? onChanged,
          fieldPostRedirection: field.suffix,
          postFieldOnClick: field.onTapSuffix,
          textInputAction:
              next != null ? TextInputAction.next : TextInputAction.done,
          controller: controller,
          focusNode: actual,
          nextFocusNode: next,
          textInputType: const TextInputType.numberWithOptions(),
          backgroundColor: field.theme?.backgroundColor,
          cursorColor: field.theme?.cursorColor,
          contentPadding: field.theme?.contentPadding as EdgeInsets?,
          defaultValue: field.initialValue,
          validator: (String? val) {
            if (field.validator != null) return field.validator!(val);
            return null;
          },
        );
    }
  }

  static Form generateForm(
    BuildContext context, {
    GlobalKey<FormState>? key,
    required List<FieldFormModel> fields,
    List<FocusNode>? nodes,
    List<TextEditingController>? controllers,
  }) {
    return Form(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...fields.map(
            (e) {
              final index = fields.indexOf(e);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  generateField(
                    context,
                    e,
                    controller:
                        controllers != null && controllers.length >= index
                            ? controllers[index]
                            : null,
                    actual: nodes != null && nodes.length > index
                        ? nodes[index]
                        : null,
                    next: nodes != null && nodes.length > index + 1
                        ? nodes[index + 1]
                        : null,
                  ),
                  sh(10),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
