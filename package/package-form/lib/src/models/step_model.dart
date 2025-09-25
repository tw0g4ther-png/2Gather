import 'package:flutter/material.dart';
import 'package:form_kosmos/form_kosmos.dart';

class StepModel {
  final String tag;
  final String? title;
  final List<FieldFormModel> fields;
  final bool canBeModifiedInResumed;
  final bool goToNextStep;
  final Widget Function(BuildContext)? builder;
  final int step;
  final GlobalKey<FormState>? key;
  final Function(Map<String, dynamic>)? onClickNext;

  const StepModel({
    required this.tag,
    required this.step,
    this.title,
    required this.fields,
    this.canBeModifiedInResumed = true,
    this.goToNextStep = true,
    this.builder,
    this.key,
    this.onClickNext,
  });
}
