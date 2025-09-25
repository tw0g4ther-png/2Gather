import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/passion/passion_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/pages/home/fiesta_form/fiesta_form_tags_page.dart';
import 'package:twogather/pages/home/fiesta_form/fiesta_form_thinng_page.dart';
import 'package:twogather/pages/home/fiesta_form/fiesta_form_visibility_page.dart';
import 'package:twogather/services/storage.dart';
import 'package:twogather/widgets/form_field_date/core.dart';
import 'package:twogather/widgets/form_field_ios_number_picker/core.dart';
import 'package:twogather/widgets/form_field_sound/core.dart';
import 'package:twogather/widgets/form_field_sub_page/core.dart';
import 'package:twogather/widgets/multi_image_picker.dart/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/micro_element/theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class FiestaFormPage extends StatefulHookConsumerWidget {
  const FiestaFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiestaFormPageState();
}

class _FiestaFormPageState extends ConsumerState<FiestaFormPage> {
  final ValueNotifier<int> _actualPage = ValueNotifier<int>(0);

  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();

  @override
  void dispose() {
    _focusNodeSearch.dispose();
    controller.dispose();
    _suggestions.dispose();
    _showSuggestions.dispose();
    super.dispose();
  }

  /// Méthode pour rechercher des suggestions
  Future<void> _searchSuggestions(String query) async {
    if (query.length < 3) {
      _suggestions.value = [];
      _showSuggestions.value = false;
      return;
    }

    try {
      final formattedQuery = query.replaceAllMapped(' ', (m) => '+');
      final results = await placeAutocomplete(formattedQuery, "fr");
      _suggestions.value = results;
      _showSuggestions.value = results.isNotEmpty;
    } catch (e) {
      _suggestions.value = [];
      _showSuggestions.value = false;
    }
  }

  /// FirstStep
  final ValueNotifier<String?> _name = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _category = ValueNotifier<String?>(null);
  final ValueNotifier<int?> _soundLevel = ValueNotifier<int?>(null);
  final ValueNotifier<List<PassionModel>?> _tags =
      ValueNotifier<List<PassionModel>?>(null);
  final ValueNotifier<String?> _desc = ValueNotifier<String?>(null);
  final ValueNotifier<bool?> _visibilty = ValueNotifier<bool?>(null);

  /// SecondStep
  final GlobalKey<MultiImagePickerState> _imageKey =
      GlobalKey<MultiImagePickerState>();

  /// ThirdStep
  final ValueNotifier<LocationModel?> _address = ValueNotifier<LocationModel?>(
    null,
  );
  final ValueNotifier<List<LocationModel>> _suggestions =
      ValueNotifier<List<LocationModel>>([]);
  final ValueNotifier<bool> _showSuggestions = ValueNotifier<bool>(false);
  dz.Tuple2<DateTime?, DateTime?>? _date;
  int? _nbMaxUser = 2;
  final ValueNotifier<String?> _logistic = ValueNotifier<String?>(null);
  final ValueNotifier<List<PassionModel>?> _mustBeBuyed =
      ValueNotifier<List<PassionModel>?>(null);
  final ValueNotifier<List<String>?> _visibiltyForPerson =
      ValueNotifier<List<String>?>(null);
  final ValueNotifier<double?> _visibiltyRadius = ValueNotifier<double?>(null);
  Map<String, dynamic> _visibilityData = {
    "firstCircle": true,
    "fiestar": true, // Correction : "fiesta" → "fiestar" pour cohérence
    "connexion": false,
  };
  List<File> photos = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScrollingPage(
      useSafeArea: true,
      safeAreaBottom: false,
      child: Column(
        children: [
          sh(20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: formatHeight(30),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "app.create-fiesta-title".tr(),
                    style: AppTextStyle.black(16),
                  ),
                ),
                CTA.back(
                  onTap: () => AutoRouter.of(context).back(),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          sh(12),
          ValueListenableBuilder(
            valueListenable: _actualPage,
            builder: (context, int val, child) {
              return ProgressBar(
                max: 3,
                current: val + 1,
                customSmallTitle: "Étape ${val + 1} / 3",
                theme: ProgressBarThemeData(color: AppColor.mainColor),
              );
            },
          ),
          sh(12),
          ValueListenableBuilder(
            valueListenable: _actualPage,
            builder: (context, int val, child) {
              final str = val == 0
                  ? "basic-info"
                  : val == 1
                  ? "add-photo"
                  : "complementary-info";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "app.create-fiesta-form.$str".tr(),
                      style: AppTextStyle.darkBlue(20, FontWeight.w600),
                    ),
                  ),
                  sh(21),
                  val == 0
                      ? _buildFirstStep(context)
                      : val == 1
                      ? _buildSecondStep(context)
                      : _buildThirdStep(context),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFirstStep(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: _name,
            builder: (context, String? val, child) {
              return TextFormUpdated.classic(
                fieldName: "${"app.create-fiesta-form.name".tr()}*",
                hintText: "app.create-fiesta-form.name-hint".tr(),
                defaultValue: val,
                onChanged: (p0) => _name.value = p0,
                validator: (p0) {
                  return p0?.isEmpty ?? true
                      ? "field.form-validator.all-field-must-have-value".tr()
                      : null;
                },
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _category,
            builder: (context, String? val, child) {
              return ModernDropdownField<String?>(
                fieldName: "${"app.create-fiesta-form.category".tr()}*",
                value: val,
                validator: (p0) {
                  return p0?.isEmpty ?? true
                      ? "field.form-validator.all-field-must-have-value".tr()
                      : null;
                },
                onChanged: (p0) => _category.value = p0,
                items: [
                  DropdownMenuItem(
                    value: 'repas',
                    child: Text('app.tags.fiesta.repas'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'deguisee',
                    child: Text('app.tags.fiesta.deguisee'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'soiree',
                    child: Text('app.tags.fiesta.soiree'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'jeux-de-cartes',
                    child: Text('app.tags.fiesta.jeux-de-cartes'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'jeux-de-societe',
                    child: Text('app.tags.fiesta.jeux-de-societe'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'soiree-a-theme',
                    child: Text('app.tags.fiesta.soiree-a-theme'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'poker',
                    child: Text('app.tags.fiesta.poker'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'chill',
                    child: Text('app.tags.fiesta.chill'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'dj-set',
                    child: Text('app.tags.fiesta.dj-set'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'speciale',
                    child: Text('app.tags.fiesta.speciale'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'masquee',
                    child: Text('app.tags.fiesta.masquee'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'concert',
                    child: Text('app.tags.fiesta.concert'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'entre-potes',
                    child: Text('app.tags.fiesta.entre-potes'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'gaming',
                    child: Text('app.tags.fiesta.gaming'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'jeux-alcool',
                    child: Text('app.tags.fiesta.jeux-alcool'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'before',
                    child: Text('app.tags.fiesta.before'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'after',
                    child: Text('app.tags.fiesta.after'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'rave',
                    child: Text('app.tags.fiesta.rave'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'soiree-match',
                    child: Text('app.tags.fiesta.soiree-match'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'film',
                    child: Text('app.tags.fiesta.film'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'apero',
                    child: Text('app.tags.fiesta.apero'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'karaoke',
                    child: Text('app.tags.fiesta.karaoke'.tr()),
                  ),
                ],
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _soundLevel,
            builder: (_, int? val, _) {
              return SoundLevelFormField(
                validator: (p0) {
                  return p0 == null
                      ? "field.form-validator.all-field-must-have-value".tr()
                      : null;
                },
                fieldName: "${"app.create-fiesta-form.sound-level".tr()}*",
                activeValue: val,
                onChanged: (int? val) {
                  _soundLevel.value = val;
                },
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _tags,
            builder: (_, List<PassionModel>? val, _) {
              final length = val?.length ?? 0;
              return SubPageFormField<List<PassionModel>?>(
                fieldName: "${"app.create-fiesta-form.tags".tr()}*",
                hint: "app.create-fiesta-form.tags-hint".plural(
                  length,
                  namedArgs: {"count": length.toString()},
                ),
                onTap: () async {
                  final t = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FiestaFormTagsPage(tags: val),
                    ),
                  );
                  _tags.value = t;
                  return null;
                },
                // ignore: avoid_returning_null_for_void
                onChanged: (p1) => null,
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _desc,
            builder: (context, String? val, child) {
              return TextFormUpdated.textarea(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                fieldName: "${"app.create-fiesta-form.description".tr()}*",
                hintText: "app.create-fiesta-form.description-hint".tr(),
                initialValue: val,
                onChanged: (p0) => _desc.value = p0,
                validator: (p0) => p0?.isEmpty ?? true
                    ? "field.form-validator.all-field-must-have-value".tr()
                    : null,
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _visibilty,
            builder: (context, bool? val, child) {
              return ModernDropdownField<bool>(
                fieldName: "${"app.create-fiesta-form.visible-after".tr()}*",
                value: val,
                validator: (p0) {
                  return p0 == null
                      ? "field.form-validator.all-field-must-have-value".tr()
                      : null;
                },
                onChanged: (p0) => _visibilty.value = p0,
                items: [
                  DropdownMenuItem(value: true, child: Text("utils.yes".tr())),
                  DropdownMenuItem(value: false, child: Text("utils.no".tr())),
                ],
              );
            },
          ),
          sh(26),
          CTA.primary(
            textButton: "utils.next".tr(),
            width: double.infinity,
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                _actualPage.value++;
              }
            },
          ),
          sh(21),
          SizedBox(
            width: double.infinity,
            child: Text(
              "field.with-mark-required".plural(2),
              style: AppTextStyle.gray(12),
              textAlign: TextAlign.center,
            ),
          ),
          sh(40),
        ],
      ),
    );
  }

  Widget _buildSecondStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: MultiImagePicker(
            key: _imageKey,
            fieldName: "${"app.create-fiesta-form.required-one-photo".tr()}*",
            maxItem: 4,
          ),
        ),
        sh(26),
        CTA.primary(
          textButton: "utils.next".tr(),
          width: double.infinity,
          onTap: () {
            if (_imageKey.currentState?.getPickedImages().isEmpty ?? true) {
              NotifBanner.showToast(
                context: context,
                fToast: FToast().init(context),
                subTitle: "Tu dois choisir au moins une photo pour ta Fiesta.",
              );
              return;
            }
            photos = _imageKey.currentState!.getPickedImages();
            _actualPage.value++;
          },
        ),
        sh(21),
        SizedBox(
          width: double.infinity,
          child: Text(
            "field.with-mark-required".plural(2),
            style: AppTextStyle.gray(12),
            textAlign: TextAlign.center,
          ),
        ),
        sh(40),
      ],
    );
  }

  Widget _buildThirdStep(BuildContext context) {
    final themeData = loadThemeData(
      null,
      "input_field",
      () => const CustomFormFieldThemeData(),
    )!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColor.mainColor, size: 16),
              sw(4),
              Text(
                "${"app.create-fiesta-form.fiesta-address".tr()}*",
                style: AppTextStyle.black(12, FontWeight.w500),
              ),
            ],
          ),
          sh(6),
          // Widget de suggestions manuel en alternative
          Column(
            children: [
              TextField(
                focusNode: _focusNodeSearch,
                controller: controller,
                onChanged: (value) {
                  _searchSuggestions(value);
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 12, height: 0),
                  filled: true,
                  fillColor:
                      themeData.backgroundColor ??
                      const Color(0xFF02132B).withValues(alpha: 0.03),
                  contentPadding:
                      themeData.contentPadding ??
                      const EdgeInsets.fromLTRB(9.5, 17.5, 9.5, 17.5),
                  focusedErrorBorder:
                      themeData.focusedErrorBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 0.5,
                        ),
                      ),
                  errorBorder:
                      themeData.errorBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        ),
                      ),
                  focusedBorder: themeData.focusedBorder,
                  border:
                      themeData.border ??
                      UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                  hintText: "utils.address-hint".tr(),
                  hintStyle:
                      themeData.hintStyle ??
                      const TextStyle(
                        color: Color(0xFF9299A4),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              // Affichage des suggestions manuelles
              ValueListenableBuilder(
                valueListenable: _showSuggestions,
                builder: (context, bool show, child) {
                  if (!show) return const SizedBox.shrink();

                  return ValueListenableBuilder(
                    valueListenable: _suggestions,
                    builder: (context, List<LocationModel> suggestions, child) {
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              final location = suggestions[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: AppColor.mainColor,
                                    size: 20,
                                  ),
                                  title: Text(
                                    location.mainText ?? "",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: sp(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: location.secondaryText != null
                                      ? Text(
                                          location.secondaryText!,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: sp(12),
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    _address.value = location;
                                    controller.text = location.formattedText;
                                    _showSuggestions.value = false;
                                    _focusNodeSearch.unfocus();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),

          sh(6),
          Center(
            child: Text(
              "app.create-fiesta-form.fiesta-address-hint".tr(),
              style: AppTextStyle.darkGray(10),
            ),
          ),
          sh(14),
          DateTimeFormField(
            fieldName: "${"utils.date".tr()}*",
            color: AppColor.mainColor,
            radius: BorderRadius.circular(100),
            validator: (p0) {
              return p0 == null
                  ? "field.form-validator.all-field-must-have-value".tr()
                  : null;
            },
            activeValue: _date,
            onChanged: (val) => _date = val,
          ),
          sh(14),
          CupertinoPickerFormField<int>(
            fieldName:
                "${"app.create-fiesta-form.number-participant-max".tr()}*",
            onChanged: (val) => _nbMaxUser = val,
            activeValue: _nbMaxUser,
            values: [for (var i = 2; i < 100; i++) i],
          ),
          sh(8),
          ValueListenableBuilder(
            valueListenable: _logistic,
            builder: (context, String? val, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModernDropdownField<String>(
                    fieldName:
                        "${"app.create-fiesta-form.logistic.title".tr()}*",
                    value: val,
                    onChanged: (p0) => _logistic.value = p0,
                    validator: (p0) => p0 == null
                        ? "field.form-validator.all-field-must-have-value".tr()
                        : null,
                    items: [
                      DropdownMenuItem(
                        value: "everyone",
                        child: Text(
                          "app.create-fiesta-form.logistic.everyone-come-with-something"
                              .tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "open-bar",
                        child: Text(
                          "app.create-fiesta-form.logistic.open-bar-text".tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "payed",
                        child: Text(
                          "app.create-fiesta-form.logistic.payed".tr(),
                        ),
                      ),
                    ],
                  ),
                  if (val == "everyone") ...[
                    sh(14),
                    ValueListenableBuilder(
                      valueListenable: _mustBeBuyed,
                      builder: (_, List<PassionModel>? val, _) {
                        return SubPageFormField<List<PassionModel>?>(
                          fieldName:
                              "${"app.create-fiesta-form.list-things-to-bring-back".tr()}*",
                          hint: "app.create-fiesta-form.tags-hint".plural(
                            val?.length ?? 0,
                          ),
                          onTap: () async => await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FiestaFormThingsPage(tags: val),
                            ),
                          ),
                          // validator: (value) => value == null ? "field.form-validator.all-field-must-have-value".tr() : null,
                          onChanged: (p1) => _mustBeBuyed.value = p1,
                        );
                      },
                    ),
                  ],
                ],
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _visibiltyForPerson,
            builder: (_, List<String>? val, _) {
              return SubPageFormField<Map<String, dynamic>>(
                fieldName: "${"app.create-fiesta-form.who-see-fiesta".tr()}*",
                hint: "app.create-fiesta-form.who-see-fiesta-hint".tr(),
                onTap: () async => await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        FiestaFormVisibilityPage(data: _visibilityData),
                  ),
                ),
                onChanged: (p1) {
                  if (p1 != null) _visibilityData = p1;
                },
              );
            },
          ),
          sh(14),
          ValueListenableBuilder(
            valueListenable: _visibiltyRadius,
            builder: (context, double? val, child) {
              return CustomSlider.slider(
                value: val,
                fieldName:
                    "${"app.create-fiesta-form.visibility-radius".tr()}*",
                onChanged: (p0) => _visibiltyRadius.value = p0,
                customSliderThumbShape: CustomSliderThumbShape(
                  stringNumber: "${val?.toInt() ?? 0} km",
                ),
                theme: SliderThemeData(
                  trackHeight: 2,
                  trackShape: const RectangularSliderTrackShape(),
                  activeTrackColor: AppColor.mainColor,
                  inactiveTrackColor: const Color(0xFFBFC3C9),
                  thumbColor: AppColor.mainColor,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                  thumbShape: const CustomSliderThumbShape(
                    elevation: 0,
                    pressedElevation: 0,
                  ),
                ),
              );
            },
          ),
          sh(45),
          CTA.primary(
            textButton: "app.create-fiesta-form.create-fiesta".tr(),
            width: double.infinity,
            onTap: () async {
              // Validation complète de tous les champs obligatoires
              if (!(_formKey.currentState?.validate() ?? false)) {
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Champs manquants",
                  subTitle: "Veuillez remplir tous les champs obligatoires.",
                );
                return;
              }

              // Vérifier les champs non couverts par le formulaire
              if (_address.value == null) {
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Adresse manquante",
                  subTitle:
                      "Veuillez sélectionner une adresse pour votre fiesta.",
                );
                return;
              }

              if (_date == null) {
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Date manquante",
                  subTitle: "Veuillez sélectionner une date pour votre fiesta.",
                );
                return;
              }

              if (_visibiltyRadius.value == null) {
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Rayon de visibilité manquant",
                  subTitle: "Veuillez définir le rayon de visibilité.",
                );
                return;
              }

              if (photos.isEmpty) {
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Photos manquantes",
                  subTitle: "Veuillez ajouter au moins une photo.",
                );
                return;
              }

              List<String> uploadedPhotos = [];
              for (final e in photos) {
                final url = await StorageController.uploadToStorage(
                  e,
                  "fiesta/${FirebaseAuth.instance.currentUser!.uid}/images/",
                );
                if (url == null) {
                  if (!context.mounted) return;
                  NotifBanner.showToast(
                    context: context,
                    fToast: FToast().init(context),
                    title: "Erreur d'upload",
                    subTitle: "Impossible d'uploader une des photos.",
                  );
                  return;
                }
                uploadedPhotos.add(url);
              }

              printInDebug("[FiestaForm] Début de la création de fiesta");

              // Vérifier que l'utilisateur est authentifié
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null) {
                if (!context.mounted) return;
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Erreur d'authentification",
                  subTitle: "Vous devez être connecté pour créer une fiesta.",
                );
                return;
              }

              // Vérifier que les données utilisateur sont disponibles
              final userData = ref.read(userChangeNotifierProvider).userData;
              if (userData == null) {
                if (!context.mounted) return;
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Données utilisateur manquantes",
                  subTitle: "Impossible de récupérer vos informations.",
                );
                return;
              }

              final fiestarUserData = userData as FiestarUserModel;

              AppUserModel host = AppUserModel(
                id: currentUser.uid,
                firstname: fiestarUserData.firstname,
                lastname: fiestarUserData.lastname,
                pictures: fiestarUserData.profilImages,
              );

              final rep = await FiestaController.createNewFiesta(
                {
                  "host": host.toJson(),
                  "hostRef": FirebaseFirestore.instance
                      .collection(
                        GetIt.I<ApplicationDataModel>().userCollectionPath,
                      )
                      .doc(currentUser.uid),
                  "title": _name.value!,
                  "category": _category.value!,
                  "soundLevel": _soundLevel.value!,
                  "tags": _tags.value?.map((e) => e.toJson()).toList() ?? [],
                  "description": _desc.value!,
                  "visibleAfter": _visibilty.value!,
                  "pictures": uploadedPhotos,
                  "address": _address.value!.toMap(),
                  "startAt": _date!.value1,
                  "endAt": _date!.value2,
                  "numberOfParticipant": _nbMaxUser!,
                  "logistic": _logistic.value!,
                  "thingsToBring":
                      _mustBeBuyed.value?.map((e) => e.toJson()).toList() ?? [],
                  "visibilityRadius": _visibiltyRadius.value!,
                  "visibleByFirstCircle":
                      _visibilityData["firstCircle"] ?? true,
                  "visibleByFiestar": _visibilityData["fiestar"] ?? true,
                  "visibleByConnexion": _visibilityData["connexion"] ?? false,
                  "isEnd": false, // Ajout du champ manquant
                  "createdAt": DateTime.now(),
                },
                {
                  "title": _name.value,
                  "pictures": uploadedPhotos,
                  "address": _address.value?.toMap(),
                  "startAt": _date?.value1,
                  "endAt": _date?.value2,
                  "visibleAfter": _visibilty.value,
                },
              );

              if (!context.mounted) return;

              // Correction de la logique inversée
              if (rep == true) {
                // rep = true signifie ERREUR
                printInDebug(
                  "[FiestaForm] Erreur lors de la création de fiesta",
                );
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Erreur de création",
                  subTitle:
                      "Impossible de créer votre fiesta. Veuillez réessayer.",
                );
                return;
              } else {
                // rep = false signifie SUCCÈS
                printInDebug("[FiestaForm] Fiesta créée avec succès");
                NotifBanner.showToast(
                  context: context,
                  fToast: FToast().init(context),
                  title: "Fiesta créée !",
                  subTitle: "Votre fiesta a été créée avec succès.",
                  backgroundColor: const Color(
                    0xFF30DE8F,
                  ), // Couleur verte pour le succès
                );

                // Attendre un peu pour que l'utilisateur voie le message de succès
                await Future.delayed(const Duration(milliseconds: 1500));

                if (context.mounted) {
                  AutoRouter.of(context).back();
                }
              }
            },
          ),

          sh(21),
          SizedBox(
            width: double.infinity,
            child: Text(
              "field.with-mark-required".plural(2),
              style: AppTextStyle.gray(12),
              textAlign: TextAlign.center,
            ),
          ),
          sh(40),
        ],
      ),
    );
  }
}
