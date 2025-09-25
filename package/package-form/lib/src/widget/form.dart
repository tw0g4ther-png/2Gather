// ignore_for_file: invalid_use_of_protected_member

import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:form_kosmos/form_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:ui_kosmos_v4/micro_element/micro_element.dart';

final formProvider = ChangeNotifierProvider<FormProvider>(
  (ref) => FormProvider(ref),
);

class FormWidget extends StatefulHookConsumerWidget {
  final bool showResumed;
  final bool showCreationDate;
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final Function(dynamic)? onTapLater;

  final List<StepModel> steps;

  final String? themeName;
  final FormWidgetThemeData? theme;

  final TextStyle? titleStyle;
  final TextStyle? laterStyle;

  final bool showUniqlyEndedStepInProgressBar;

  final List<String>? progressbarSteps;

  final Function(Map<String, dynamic>)? onSubmit;
  final String? resumedTitle;

  const FormWidget({
    super.key,
    required this.steps,
    this.onSubmit,
    this.showResumed = true,
    this.showCreationDate = true,
    this.title,
    this.onTapLater,
    this.theme,
    this.themeName,
    this.titleStyle,
    this.laterStyle,
    this.showUniqlyEndedStepInProgressBar = false,
    this.progressbarSteps,
    this.resumedTitle,
    this.icon,
    this.iconColor,
    this.iconSize,
  }) : assert(steps.length > 0);

  @override
  ConsumerState<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends ConsumerState<FormWidget> {
  late final FormWidgetThemeData themeData;

  @override
  void initState() {
    themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "widget_form",
      () => const FormWidgetThemeData(),
    )!;

    ref
        .read(formProvider)
        .init(
          0,
          widget.steps
                  .where((element) => element.goToNextStep)
                  .toList()
                  .length +
              (widget.showResumed ? 1 : 0),
        );
    ref
        .read(formProvider)
        .initData(title: widget.title ?? "", steps: widget.steps);

    super.initState();
  }

  // @override
  // void dispose() {
  //   ref.read(formProvider).controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    printInDebug("rebuild form");
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          widget.icon ?? Icons.arrow_back_ios_rounded,
                          color: widget.iconColor ?? Colors.black,
                          size: widget.iconSize ?? formatWidth(20),
                        ),
                      ),
                    ],
                  ),
                ),
                sw(15),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.title ?? 'Formulaire',
                    style:
                        widget.titleStyle ??
                        themeData.titleStyle ??
                        TextStyle(
                          fontSize: sp(16),
                          color: const Color(0xFF02132B),
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                sw(15),
                Expanded(
                  child: Opacity(
                    opacity:
                        ref.watch(formProvider).page <
                            ref.read(formProvider).maxLength
                        ? 1
                        : 0,
                    child: InkWell(
                      onTap: () {
                        if (widget.onTapLater != null) widget.onTapLater!(null);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: formatHeight(6),
                        ),
                        child: Text(
                          "Plus tard",
                          textAlign: TextAlign.end,
                          style:
                              widget.laterStyle ??
                              themeData.laterStyle ??
                              TextStyle(
                                fontSize: sp(15),
                                color: const Color(0xFF02132B),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        sh(12),
        _buildProgressBar(context),
        sh(12),
        Expanded(child: _buildStepForm(context)),
      ],
    );
  }

  Widget _buildStepForm(BuildContext context) {
    return ListView(
      children: [
        ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: ref.read(formProvider).controller,
          children: [
            for (final e in widget.steps) _buildForm(e),
            if (widget.showResumed)
              FormResumed(
                title: widget.resumedTitle,
                data: ref.watch(formProvider).data,
                showCreationDate: widget.showCreationDate,
                onTapModify: (index, step) =>
                    ref.read(formProvider).jumpToPage(index, step as int),
                onSubmit: widget.onSubmit,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(StepModel step) {
    if (step.builder != null) return step.builder!(context);
    return Form(
      key: step.key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (step.title != null)
            Text(
              step.title!,
              style:
                  themeData.titleStyle ??
                  TextStyle(
                    fontSize: sp(20),
                    color: const Color(0xFF02132B),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          sh(16),
          if (step.builder != null)
            step.builder!(context)
          else
            ...step.fields.map(
              (e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormGenerator.generateField(
                    context,
                    e,
                    onChanged: ((p0) =>
                        ref.read(formProvider).updateData(step.tag, e.tag, p0)),
                  ),
                  sh(8),
                ],
              ),
            ),
          sh(20),
          if (widget.steps.last != step || widget.showResumed) ...[
            CTA.primary(
              textButton: "utils.next".tr(),
              onTap: () {
                if (step.key?.currentState?.validate() ?? true) {
                  if (step.onClickNext != null) {
                    printInDebug("on click next");
                    step.onClickNext!(ref.read(formProvider).data);
                  }
                  ref.read(formProvider).nextPage(step.goToNextStep);
                }
              },
            ),
            sh(16),
            Center(
              child: Text(
                "field.required-field".tr(),
                style: TextStyle(
                  color: const Color(0xFF3F3F3F),
                  fontSize: sp(12),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            sh(10),
          ] else ...[
            CTA.primary(
              textButton: "utils.submit".tr(),
              isEnabled: ref.watch(formProvider).allDataAreValid(),
              onTap: () {
                if (step.key?.currentState?.validate() ?? true) {
                  if (widget.onSubmit != null) {
                    widget.onSubmit!(ref.read(formProvider).data);
                  }
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    switch (themeData.progressbarType) {
      case FormScrollBar.percent:
        return ProgressBar(
          max: ref.read(formProvider).maxLength.toDouble(),
          current: ref.watch(formProvider).step,
          theme: themeData.progressbarTheme,
          height: themeData.progressBarHeight,
        );
      case FormScrollBar.step:
        return ProgressBar(
          max: ref.read(formProvider).maxLength.toDouble(),
          current: (ref.watch(formProvider).step.toInt()) + 1,
          customSmallTitle:
              "Étape ${(ref.watch(formProvider).step.toInt()) + (widget.showUniqlyEndedStepInProgressBar ? 0 : 1)} / ${ref.read(formProvider).maxLength}",
          theme: themeData.progressbarTheme,
          height: themeData.progressBarHeight,
        );
      case FormScrollBar.separated:
        return ProgressBar.separated(
          max: ref.read(formProvider).maxLength.toDouble(),
          current: ref.watch(formProvider).step,
          customSmallTitle: "Votre avancée",
          showPercentage: true,
          height: themeData.progressBarHeight,
          items: widget.progressbarSteps,
          theme: themeData.progressbarTheme,
        );
    }
  }
}
