// ignore_for_file: unused_field

import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:form_kosmos/form_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormProvider with ChangeNotifier {
  Map<String, dynamic> data = {};

  late double _step;
  double get step => _step;

  late int page;

  int maxLength = 0;

  PageController _controller = PageController();
  PageController get controller => _controller;

  final Ref _ref;

  FormProvider(this._ref);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void init(double firstStep, int length) {
    _step = firstStep;
    page = firstStep.toInt();
    maxLength = length;
    _controller = PageController(initialPage: page);
  }

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

  void initData({required String title, required List<StepModel> steps}) {
    data["type"] = "resumed";
    data["title"] = title;
    data["createdAt"] = DateTime.now();
    data["step"] = [];
    for (final step in steps) {
      var tmp = {};
      tmp["title"] = step.title;
      tmp["can_modify"] = step.canBeModifiedInResumed;
      tmp["index"] = steps.indexOf(step);
      tmp["step"] = step.step;
      tmp["id"] = step.tag;
      tmp["fields"] = [];
      for (final FieldFormModel field in step.fields) {
        var tmpField = {};
        tmpField["title"] = field.fieldName;
        tmpField["required"] = field.requiredForForm;
        tmpField["defaultValueImage"] = field.defaultImageUrl;
        tmpField["id"] = field.tag;
        tmpField["data"] = field.initialValue;
        // Support pour les messages d'erreur personnalisés (à implémenter dans FieldFormModel)
        // tmpField["error_msg"] = field.errorMsg;
        tmp["fields"].add(tmpField);
      }

      data["step"].add(tmp);
    }
    execAfterBuild(() => notifyListeners());
  }

  void updateData(
    String stepId,
    String fieldId,
    dynamic value, [
    int? index,
    String? stepTitle,
    String? defaultImageUrl,
    bool appearIfNull = false,
  ]) {
    for (final step in data["step"]) {
      if (step["id"] == stepId) {
        bool isFinded = false;
        for (final field in step["fields"]) {
          if (field["id"] == fieldId) {
            isFinded = true;
            field["data"] = value;
            if (defaultImageUrl != null) {
              field["defaultValueImage"] = defaultImageUrl;
            }
          }
        }
        if (!isFinded) {
          data["step"]?[index!]?["fields"]?.add({
            "id": fieldId,
            "title": stepTitle,
            "requiredForForm": false,
            "required": false,
            "data": value,
            "appear_if_null": appearIfNull,
            "defaultValueImage": defaultImageUrl,
          });
        }
      }
    }
    execAfterBuild(() {
      notifyListeners();
    });
  }

  bool isActualStep(dynamic actual) => _step == actual;

  void nextPage([bool nextStep = true]) {
    page++;
    if (nextStep) {
      _step++;
    }
    _controller.jumpToPage(page);
    notifyListeners();
  }

  void prevPage() {
    page--;
    _step--;
    _controller.jumpToPage(page);
    notifyListeners();
  }

  void jumpToPage(String id, int step) {
    // final index = data["step"]?.indexWhere((element) => element["id"] == id);
    page = step;
    _step = step.toDouble();
    _controller.jumpToPage(_step.toInt());
    notifyListeners();
  }

  allDataAreValid() {
    for (final step in data["step"]) {
      for (final field in step["fields"]) {
        if (field["required"] == true && field["data"] == null) {
          return false;
        }
      }
    }
    return true;
  }
}
