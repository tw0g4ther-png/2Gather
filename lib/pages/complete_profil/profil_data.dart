import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/complete_profil/complete_profil.dart';
import 'package:twogather/widgets/alert_message/core.dart';
import 'package:twogather/widgets/alert_message/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class ProfilData extends StatefulHookConsumerWidget {
  final Function? onSubmit;

  const ProfilData({super.key, this.onSubmit});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilDataState();
}

class _ProfilDataState extends ConsumerState<ProfilData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<String?> _gender = ValueNotifier<String?>(null);

  String? lastname;
  String? firstname;
  DateTime? birthday;

  @override
  void initState() {
    super.initState();
    
    // Initialiser les variables locales avec les valeurs du provider si elles existent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerData = ref.read(completeProfilProvider).data;
      
      // Initialiser gender
      if (providerData["gender"] != null) {
        _gender.value = providerData["gender"];
      }
      
      // Initialiser lastname
      if (providerData["lastname"] != null) {
        lastname = providerData["lastname"];
      }
      
      // Initialiser firstname
      if (providerData["firstname"] != null) {
        firstname = providerData["firstname"];
      }
      
      // Initialiser birthday
      if (providerData["birthday"] != null) {
        birthday = providerData["birthday"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("app.create-profil".tr(), style: AppTextStyle.black(23)),
        sh(7),
        Text("${"utils.step".tr()} 1", style: AppTextStyle.black(16)),
        sh(22),
        AlertMessage(
          message: "app.warning-data-must-be-identic".tr(),
          type: AlertMessageType.warning,
        ),
        sh(18),
        ValueListenableBuilder(
          valueListenable: _gender,
          builder: (context, String? val, child) {
            return ModernDropdownField<String>(
              fieldName: "utils.sex".tr(),
              isRequired: true,
              value: val ?? ref.watch(completeProfilProvider).data["gender"],
              hintText: "app.select-hint".tr(),
              items: [
                DropdownMenuItem(value: "men", child: Text("utils.men".tr())),
                DropdownMenuItem(
                  value: "woman",
                  child: Text("utils.woman".tr()),
                ),
                DropdownMenuItem(
                  value: "other",
                  child: Text("utils.other".tr()),
                ),
              ],
              onChanged: (String? newValue) {
                _gender.value = newValue;
              },
            );
          },
        ),
        sh(14),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormUpdated.classic(
                fieldName: "${"utils.name".tr()}*",
                hintText: "app.name-example".tr(),
                onChanged: (it) => lastname = it,
                defaultValue: ref
                    .watch(completeProfilProvider)
                    .data["lastname"],
                validator: (it) => it?.isEmpty ?? true
                    ? "field.form-validator.required-field".tr()
                    : null,
              ),
              sh(14),
              TextFormUpdated.classic(
                fieldName: "${"utils.firstname".tr()}*",
                onChanged: (it) => firstname = it,
                hintText: "app.firstname-example".tr(),
                defaultValue: ref
                    .watch(completeProfilProvider)
                    .data["firstname"],
                validator: (it) => it?.isEmpty ?? true
                    ? "field.form-validator.required-field".tr()
                    : null,
              ),
              sh(6),
              Text(
                "app.only-firstname-visible".tr(),
                style: AppTextStyle.darkBlue(12, FontWeight.w400),
              ),
              sh(14),
              TextFormUpdated.dateTime(
                fieldName: "${"utils.birthday".tr()}*",
                onChangedDate: (it) => birthday = it,
                validatorDate: (it) {
                  if (it == null) {
                    return "field.form-validator.required-field".tr();
                  }
                  if (it.isAfter(DateTime.now())) {
                    return "field.form-validator.future-date-not-allowed".tr();
                  }
                  // Vérifier que l'utilisateur a au moins 18 ans
                  final now = DateTime.now();
                  final age = now.year - it.year;
                  final monthDiff = now.month - it.month;
                  final dayDiff = now.day - it.day;

                  final actualAge =
                      monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)
                      ? age - 1
                      : age;

                  if (actualAge < 18) {
                    return "app.age-validation".tr();
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        sh(31),
        CTA.primary(
          textButton: "utils.next".tr(),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            
            final providerData = ref.read(completeProfilProvider).data;
            
            // Vérifier gender (valeur locale ou valeur du provider)
            String? currentGender = _gender.value ?? providerData["gender"];
            
            // Vérifier lastname (valeur locale ou valeur du provider)
            String? currentLastname = lastname ?? providerData["lastname"];
            
            // Vérifier firstname (valeur locale ou valeur du provider)
            String? currentFirstname = firstname ?? providerData["firstname"];
            
            // Vérifier birthday (valeur locale ou valeur du provider)
            DateTime? currentBirthday = birthday ?? providerData["birthday"];
            
            // Valider le formulaire ET le champ gender
            bool isFormValid = _formKey.currentState?.validate() ?? false;
            bool isGenderValid = currentGender != null;
            
            if (!isGenderValid) {
              // Afficher un message d'erreur pour le champ gender
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("field.form-validator.required-field".tr()),
                  backgroundColor: Colors.red,
                ),
              );
            }
            
            if (isFormValid && isGenderValid) {
              ref
                  .read(completeProfilProvider)
                  .addFieldToData("gender", currentGender);
              ref
                  .read(completeProfilProvider)
                  .addFieldToData("lastname", currentLastname);
              ref
                  .read(completeProfilProvider)
                  .addFieldToData("firstname", currentFirstname);
              ref
                  .read(completeProfilProvider)
                  .addFieldToData("birthday", currentBirthday);
              if (widget.onSubmit != null) {
                widget.onSubmit!();
              }
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
