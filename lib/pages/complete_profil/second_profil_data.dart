import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/complete_profil/complete_profil.dart';
import 'package:twogather/widgets/multiple_dropdown_selection/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class SecondProfilData extends StatefulHookConsumerWidget {
  final Function? onSubmit;

  const SecondProfilData({super.key, this.onSubmit});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecondProfilDataState();
}

class _SecondProfilDataState extends ConsumerState<SecondProfilData> {
  String? desc;
  List<String>? nationality;
  List<String>? language;

  final ValueNotifier<String?> _smoker = ValueNotifier<String?>(null);
  final Map<String, String> languageAndCountry = {
    "french": "utils.language.french".tr(),
    "english": "utils.language.english".tr(),
    "german": "utils.language.german".tr(),
    "italian": "utils.language.italian".tr(),
    "portuguese": "utils.language.portuguese".tr(),
    "spanish": "utils.language.spanish".tr(),
    "turkish": "utils.language.turkish".tr(),
    "russian": "utils.language.russian".tr(),
    "arabic": "utils.language.arabic".tr(),
    "chinese": "utils.language.chinese".tr(),
    "japanese": "utils.language.japanese".tr(),
  };

  @override
  void initState() {
    super.initState();
    
    // Initialiser les variables locales avec les valeurs du provider si elles existent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerData = ref.read(completeProfilProvider).data;
      
      // Initialiser nationality
      if (providerData["nationality"] != null) {
        nationality = List<String>.from(providerData["nationality"]);
      }
      
      // Initialiser language
      if (providerData["languages"] != null) {
        language = List<String>.from(providerData["languages"]);
      }
      
      // Initialiser smoker
      if (providerData["smoker"] != null) {
        _smoker.value = providerData["smoker"];
      }
      
      // Initialiser description
      if (providerData["description"] != null) {
        desc = providerData["description"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("app.create-profil".tr(), style: AppTextStyle.black(23)),
        sh(7),
        Text("${"utils.step".tr()} 3", style: AppTextStyle.black(16)),
        sh(22),
        DropDownMultiSelect<String>(
          fieldName: "${"app.nationality".tr()}* max. 3",
          onChanged: (vals) {
            List<String> data = [];
            languageAndCountry.forEach((key, value) {
              if (vals.contains(value)) {
                data.add(key);
              }
            });
            nationality = data;
          },
          options: [...languageAndCountry.values],
          selectedValues:
              ((ref.watch(completeProfilProvider).data["nationality"]
                      as List<dynamic>?)
                  ?.map((e) => languageAndCountry[e] as String)
                  .toList()) ??
              [],
          maxItem: 3,
        ),
        sh(14),
        DropDownMultiSelect<String>(
          fieldName: "${"app.language".tr()}* max. 5",
          onChanged: (vals) {
            List<String> data = [];
            languageAndCountry.forEach((key, value) {
              if (vals.contains(value)) {
                data.add(key);
              }
            });
            language = data;
          },
          options: [...languageAndCountry.values],
          maxItem: 5,
          selectedValues:
              ((ref.watch(completeProfilProvider).data["languages"]
                      as List<dynamic>?)
                  ?.map((e) => languageAndCountry[e] as String)
                  .toList()) ??
              [],
        ),
        sh(14),
        ValueListenableBuilder(
          valueListenable: _smoker,
          builder: (context, String? val, child) {
            return ModernDropdownField<String>(
              fieldName: "${"app.are-you-smoker".tr()}*",
              value: val ?? (ref.read(completeProfilProvider).data["smoker"]),
              hintText: "utils.choose".tr(),
              items: [
                DropdownMenuItem(
                  value: "yes",
                  child: Text("app.smoker-choice.yes".tr()),
                ),
                DropdownMenuItem(
                  value: "no",
                  child: Text("app.smoker-choice.no".tr()),
                ),
                DropdownMenuItem(
                  value: "when-drink",
                  child: Text("app.smoker-choice.when-drink".tr()),
                ),
                DropdownMenuItem(
                  value: "only-fiesta",
                  child: Text("app.smoker-choice.only-fiesta".tr()),
                ),
                DropdownMenuItem(
                  value: "mystery",
                  child: Text("app.smoker-choice.mystery".tr()),
                ),
                DropdownMenuItem(
                  value: "sometimes",
                  child: Text("app.smoker-choice.sometimes".tr()),
                ),
                DropdownMenuItem(
                  value: "what",
                  child: Text("app.smoker-choice.what".tr()),
                ),
              ],
              onChanged: (it) => _smoker.value = it,
            );
          },
        ),
        sh(14),
        TextFormUpdated.textarea(
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          fieldName: "${"utils.desc".tr()}*",
          initialValue: ref.watch(completeProfilProvider).data["description"],
          hintText: "app.desc-hint".tr(),
          onChanged: (it) => desc = it,
        ),
        sh(32),
        CTA.primary(
          textButton: "utils.next".tr(),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            
            // Validation des champs obligatoires
            List<String> errors = [];
            final providerData = ref.read(completeProfilProvider).data;
            
            // Vérifier nationality (valeur locale ou valeur du provider)
            List<String>? currentNationality = nationality ?? 
                (providerData["nationality"] != null ? List<String>.from(providerData["nationality"]) : null);
            
            // Vérifier language (valeur locale ou valeur du provider)
            List<String>? currentLanguage = language ?? 
                (providerData["languages"] != null ? List<String>.from(providerData["languages"]) : null);
            
            // Vérifier smoker (valeur locale ou valeur du provider)
            String? currentSmoker = _smoker.value ?? providerData["smoker"];
            
            // Vérifier description (valeur locale ou valeur du provider)
            String? currentDesc = desc ?? providerData["description"];
            
            if (currentNationality == null || currentNationality.isEmpty) {
              errors.add("app.nationality".tr());
            }
            
            if (currentLanguage == null || currentLanguage.isEmpty) {
              errors.add("app.language".tr());
            }
            
            if (currentSmoker == null) {
              errors.add("app.are-you-smoker".tr());
            }
            
            if (currentDesc == null || currentDesc.trim().isEmpty) {
              errors.add("utils.desc".tr());
            }
            
            if (errors.isNotEmpty) {
              // Afficher un message d'erreur avec les champs manquants
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${"field.form-validator.required-field".tr()}\n${errors.join(", ")}",
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
              return;
            }
            
            // Si toutes les validations passent, sauvegarder les données
            ref
                .read(completeProfilProvider)
                .addFieldToData("nationality", currentNationality);
            ref
                .read(completeProfilProvider)
                .addFieldToData("languages", currentLanguage);
            ref
                .read(completeProfilProvider)
                .addFieldToData("smoker", currentSmoker);
            ref
                .read(completeProfilProvider)
                .addFieldToData("description", currentDesc);
            if (widget.onSubmit != null) {
              widget.onSubmit!();
            }
          },
        ),
        sh(21),
        Text(
          "field.with-mark-required".plural(1),
          style: AppTextStyle.darkBlue(12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
