import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_kosmos/form_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

/// A [Form] that can be used to create a [Kosmos Form] instance.
/// This is the Resumed class of the library.
///
/// Example of a Json data for this:
/// ```json
/// {
///  "type": "resumed", // can be null too
///  "title": "Résumé de la demande", // can be null too
///  "createdAt": "2020-01-01T00:00:00.000Z", // DateTime
///  "description": "A rapid description for the resumed",
///  "step": [
///     {
///       "title": "Étape 1 - Projet",
///       "can_modify": null, // if null, default value is true
///       "id": "etape-1",
///       "fields": [
///         {
///           "title": "Quel est votre projet immobilier ?",
///           "required": null // if null, default value is true,
///           "data": "Value of the field" // is null, and required is true, the field will show error_msg
///           "error_msg": null // if is null, default value is "Le champs est requis"
///         },
///         ...
///       ]
///     },
///     ...
///  ]
/// }
/// ```

class FormResumed extends ConsumerWidget {
  final Map<String, dynamic> data;

  final Function(dynamic, dynamic)? onTapModify;

  final Widget? bottomButton;
  final bool showRequiredField;
  final bool authorizeModify;

  final String buttonText;
  final TextStyle? buttonStyle;
  final Function(Map<String, dynamic> data)? onSubmit;

  final ResumedThemeData? theme;
  final String? themeName;

  final String? title;
  final TextStyle? titleStyle;

  final String? dateFormat;
  final TextStyle? dateStyle;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? modifyStyle;
  final TextStyle? fieldTitleStyle;
  final TextStyle? fieldStyle;
  final TextStyle? fieldErrorStyle;

  final EdgeInsets? padding;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final TextStyle? stepTitleStyle;
  final bool showCreationDate;

  const FormResumed({
    super.key,
    required this.data,
    this.bottomButton,
    this.buttonStyle,
    this.authorizeModify = true,
    this.onTapModify,
    this.showRequiredField = true,
    this.theme,
    this.themeName,
    this.title,
    this.titleStyle,
    this.dateFormat,
    this.dateStyle,
    this.borderRadius,
    this.modifyStyle,
    this.fieldStyle,
    this.fieldTitleStyle,
    this.fieldErrorStyle,
    this.padding,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.stepTitleStyle,
    this.buttonText = "Valider",
    this.onSubmit,
    this.showCreationDate = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "form_resumed_kosmos",
      () => const ResumedThemeData(),
    )!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: (title != null || data["title"] != null)
                  ? Text(
                      title ?? data["title"] ?? "",
                      style:
                          titleStyle ??
                          themeData.titleStyle ??
                          TextStyle(
                            color: const Color(0xFF02132B),
                            fontSize: sp(20),
                          ),
                    )
                  : const SizedBox(),
            ),
            sw(20),
            if (showCreationDate && data["createdAt"] != null)
              Text(
                "Soumis le ${DateFormat(dateFormat ?? themeData.dateFormat ?? "dd/MM/yyyy").format(data["createdAt"])}",
                style:
                    dateStyle ??
                    themeData.titleStyle ??
                    TextStyle(
                      color: const Color(0xFF02132B).withValues(alpha: 0.65),
                      fontSize: sp(14),
                      fontWeight: FontWeight.w500,
                    ),
              ),
          ],
        ),
        sh(themeData.verticalTitleSpacing ?? 13),
        ...((data["step"] as List<dynamic>?)?.map((e) {
              Map<String, dynamic> map = {};
              (e as Map<Object?, Object?>).forEach((key, value) {
                map[key.toString()] = value as dynamic;
              });
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormResumed.buildSection(
                    context,
                    data["id"] ?? "",
                    map,
                    theme: themeData,
                    themeName: themeName,
                    padding: padding,
                    authorizeModify: authorizeModify,
                    borderColor: borderColor,
                    borderRadius: borderRadius,
                    backgroundColor: backgroundColor,
                    stepTitleStyle: stepTitleStyle,
                    modifyStyle: modifyStyle,
                    fieldTitleStyle: fieldTitleStyle,
                    fieldStyle: fieldStyle,
                    fieldErrorStyle: fieldErrorStyle,
                    onTapModify: onTapModify,
                  ),
                  if (e != (data["step"] as List<dynamic>).last)
                    sh(themeData.verticalSectionSpacing ?? 6),
                ],
              );
            }).toList() ??
            []),
        if (bottomButton != null) ...[
          sh((themeData.verticalTitleSpacing ?? 13)),
          bottomButton!,
        ] else ...[
          sh((themeData.verticalTitleSpacing ?? 13)),
          CTA.primary(
            width: double.infinity,
            textButton: buttonText,
            isEnabled: true,
            textButtonStyle:
                buttonStyle ??
                themeData.buttonStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: sp(17),
                  fontWeight: FontWeight.w600,
                ),
            onTap: () async {
              // if (!FormUtils.allFieldAreValid(data)) {
              //   printInDebug("Can't activate button, missing required fields");
              //   printInDebug(data);
              //   return false;
              // }
              printInDebug(onSubmit);
              if (onSubmit != null) await onSubmit!(data);
            },
          ),
        ],
        sh((themeData.verticalTitleSpacing ?? 13)),
        if (showRequiredField) ...[
          Center(
            child: Text(
              "* Le champ marqué est obligatoire",
              style: TextStyle(
                color: const Color(0xFF02132B),
                fontSize: sp(11),
              ),
            ),
          ),
          sh(10),
        ],
      ],
    );
  }

  static Widget buildSection(
    BuildContext context,
    String formId,
    Map<String, dynamic> sectionData, {
    ResumedThemeData? theme,
    bool authorizeModify = true,
    String? themeName,
    EdgeInsets? padding,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    TextStyle? stepTitleStyle,
    BorderRadiusGeometry? borderRadius,
    TextStyle? modifyStyle,
    TextStyle? fieldTitleStyle,
    TextStyle? fieldStyle,
    TextStyle? fieldErrorStyle,
    Function(dynamic, dynamic)? onTapModify,
  }) {
    final themeData = loadThemeData(
      theme,
      themeName ?? "form_resumed_kosmos",
      () => const ResumedThemeData(),
    )!;

    return Container(
      padding:
          padding ??
          themeData.sectionPadding ??
          EdgeInsets.symmetric(
            horizontal: formatWidth(19),
            vertical: formatHeight(11),
          ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              borderColor ??
              themeData.borderColor ??
              const Color(0xFF02132B).withValues(alpha: 0.11),
          width: borderWidth ?? themeData.borderWidth ?? 1,
        ),
        color:
            backgroundColor ?? themeData.backgroundColor ?? Colors.transparent,
        borderRadius:
            borderRadius ?? themeData.borderRadius ?? BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionData["title"] != null ||
              sectionData["can_modify"] != false) ...[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    (sectionData["title"] as String?) ?? "",
                    style:
                        stepTitleStyle ??
                        themeData.stepTitleStyle ??
                        TextStyle(
                          color: const Color(0xFF02132B),
                          fontSize: sp(13),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                sw(20),
                if (sectionData["can_modify"] != false && authorizeModify)
                  InkWell(
                    onTap: () {
                      printInDebug(
                        "modify ${sectionData["id"]} with index ${sectionData["step_index"]}",
                      );
                      if (onTapModify != null) {
                        onTapModify(formId, sectionData["step"] ?? 0);
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          themeData.modifyIconPath ??
                              "assets/svg/ic_modify.svg",
                          package: (themeData.modifyIconPath != null)
                              ? null
                              : "form_kosmos",
                          width: formatWidth(14),
                        ),
                        sw(5),
                        Text(
                          "Modifier",
                          style:
                              modifyStyle ??
                              themeData.modifyTextStyle ??
                              TextStyle(
                                color: const Color(
                                  0xFF64C3BE,
                                ).withValues(alpha: 0.65),
                                fontSize: sp(12),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            sh(4),
          ],
          if (sectionData["fields"] != null) ...[
            ...(sectionData["fields"] as List<dynamic>).map((e) {
              printInDebug(e);
              if (e["data"] == null && e["appear_if_null"] == false) {
                return Container();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${(e["title"] as String?) ?? "EmptyFieldName"}${(e["required"] != false) ? "*" : ""}",
                    style:
                        fieldTitleStyle ??
                        themeData.fieldTitleStyle ??
                        TextStyle(
                          color: const Color(0xFF02132B),
                          fontSize: sp(12),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (e["data"] != null && e["data"] is Timestamp)
                    Text(
                      "${(e["data"] as Timestamp).toDate().day.toString().padLeft(2, "0")}/${(e["data"] as Timestamp).toDate().month.toString().padLeft(2, "0")}/${(e["data"] as Timestamp).toDate().year}",
                      style: e["data"] != null
                          ? fieldTitleStyle ??
                                themeData.fieldTitleStyle ??
                                TextStyle(
                                  color: const Color(
                                    0xFF02132B,
                                  ).withValues(alpha: 0.6),
                                  fontSize: sp(12),
                                  fontWeight: FontWeight.w400,
                                )
                          : fieldErrorStyle ??
                                themeData.fieldErrorStyle ??
                                TextStyle(
                                  color: const Color(0xFFF70000),
                                  fontSize: sp(12),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                    )
                  else if (e["data"] != null && e["data"] is XFile)
                    Container(
                      width: formatWidth(120),
                      height: formatHeight(80),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Image.file(
                        File((e["data"] as XFile).path),
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (e["data"] != null)
                    Text(
                      (e["data"] as Object?)?.toString() ?? "",
                      style:
                          fieldTitleStyle ??
                          themeData.fieldTitleStyle ??
                          TextStyle(
                            color: const Color(
                              0xFF02132B,
                            ).withValues(alpha: 0.6),
                            fontSize: sp(12),
                            fontWeight: FontWeight.w400,
                          ),
                    )
                  else if (e["defaultValueImage"] != null) ...[
                    Container(
                      width: formatWidth(120),
                      height: formatHeight(80),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: e["defaultValueImage"] as String,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ] else if (e["required"] == true)
                    Text(
                      e["error_msg"] ?? "Réponse manquante ou incomplète",
                      style:
                          fieldErrorStyle ??
                          themeData.fieldErrorStyle ??
                          TextStyle(
                            color: const Color(0xFFF70000),
                            fontSize: sp(12),
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                    ),

                  ///
                  if (e != (sectionData["fields"] as List<dynamic>).last) ...[
                    sh(5),
                    const Divider(height: .5),
                    sh(themeData.verticalFieldSpacing ?? 6),
                  ],
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}
