import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/widgets/multiple_dropdown_selection/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class UpdateSupplyInfo extends StatefulHookConsumerWidget {
  const UpdateSupplyInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateSupplyInfoState();
}

class _UpdateSupplyInfoState extends ConsumerState<UpdateSupplyInfo> {
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

  List<String>? nationality;
  List<String>? language;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              sh(12),
              SizedBox(
                height: formatHeight(35),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "app.supply_info".tr(),
                        style: AppTextStyle.black(17),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).back(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: formatWidth(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sh(50),
              DropDownMultiSelect<String>(
                fieldName: "${"app.nationality".tr()} max. 3",
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
                    (((ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .nationality)
                        ?.map((e) => languageAndCountry[e] as String)
                        .toList()) ??
                    [],
                maxItem: 3,
              ),
              sh(14),
              DropDownMultiSelect<String>(
                fieldName: "${"app.language".tr()} max. 5",
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
                maxItem: 5,
                selectedValues:
                    (((ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .languages)
                        ?.map((e) => languageAndCountry[e] as String)
                        .toList()) ??
                    [],
              ),
              sh(14),
              ValueListenableBuilder(
                valueListenable: _smoker,
                builder: (context, String? val, child) {
                  return ModernDropdownField<String>(
                    fieldName: "app.are-you-smoker".tr(),
                    value:
                        val ??
                        ((ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .smoker),
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
              sh(16.5),
              CTA.primary(
                textButton: "utils.save".tr(),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection(
                        GetIt.I<ApplicationDataModel>().userCollectionPath,
                      )
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                        "nationality":
                            nationality ??
                            ((ref.read(userChangeNotifierProvider).userData!
                                    as FiestarUserModel)
                                .nationality),
                        "languages":
                            language ??
                            ((ref.read(userChangeNotifierProvider).userData!
                                    as FiestarUserModel)
                                .languages),
                        "smoker":
                            _smoker.value ??
                            ((ref.read(userChangeNotifierProvider).userData!
                                    as FiestarUserModel)
                                .smoker),
                      });
                  if (!context.mounted) return;
                  AutoRouter.of(context).back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
