import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
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
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/micro_element/theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class FiestaUpdateFormPage extends StatefulHookConsumerWidget {
  final String fiestaId;

  const FiestaUpdateFormPage({super.key, required this.fiestaId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiestaUpdateFormPageState();
}

class _FiestaUpdateFormPageState extends ConsumerState<FiestaUpdateFormPage> {
  final ValueNotifier<int> _actualPage = ValueNotifier<int>(0);

  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();

  @override
  void dispose() {
    _focusNodeSearch.dispose();
    controller.dispose();
    super.dispose();
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
    "fiestar": true,
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
            builder: (_, int val, _) {
              return ProgressBar(
                max: 3,
                current: val + 1,
                customSmallTitle: "Étape ${val + 1} / 3",
                theme: ProgressBarThemeData(color: AppColor.mainColor),
              );
            },
          ),
          sh(12),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("fiesta")
                .doc(widget.fiestaId)
                .get()
                .then(
                  (value) => FiestaModel.fromJson(
                    value.data()!,
                  ).copyWith(id: value.id),
                ),
            builder: (_, AsyncSnapshot<FiestaModel?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _name.value = snapshot.data!.title;
                _category.value = snapshot.data!.category;
                _soundLevel.value = snapshot.data!.soundLevel?.toInt();
                _desc.value = snapshot.data!.description;
                _address.value = snapshot.data!.address;
                _date = dz.Tuple2<DateTime?, DateTime?>(
                  snapshot.data!.startAt,
                  snapshot.data!.endAt,
                );
                _logistic.value = snapshot.data!.logistic;
                _visibiltyRadius.value = snapshot.data!.visibilityRadius;
                _visibilty.value = snapshot.data!.visibleAfter;
                return ValueListenableBuilder(
                  valueListenable: _actualPage,
                  builder: (_, int val, _) {
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
                );
              }
              return const Center(child: LoaderClassique());
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
            builder: (_, String? val, _) {
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
            builder: (_, String? val, _) {
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
            builder: (_, String? val, _) {
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
            builder: (_, bool? val, _) {
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
          Text(
            "${"app.create-fiesta-form.fiesta-address".tr()}*",
            style: AppTextStyle.black(12, FontWeight.w500),
          ),
          sh(6),
          TypeAheadField<LocationModel>(
            onSelected: (location) {
              _address.value = location;
              controller.text = location.formattedText;
              _focusNodeSearch.unfocus();
            },
            builder: (context, controller, focusNode) {
              return TextField(
                focusNode: _focusNodeSearch,
                controller: controller,
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
              );
            },
            debounceDuration: const Duration(seconds: 0),
            animationDuration: const Duration(seconds: 0),
            hideOnEmpty: true,
            suggestionsCallback: (value) async {
              if (value.length < 3) {
                return [];
              }
              final query = value.replaceAllMapped(' ', (m) => '+');
              final rep = await placeAutocomplete(query, "fr");
              printInDebug(rep);
              return (rep);
            },
            itemBuilder: (context, location) {
              return ListTile(
                title: Text(
                  "${location.mainText ?? ""}, ${location.secondaryText ?? ""}",
                  style: TextStyle(color: Colors.black, fontSize: sp(12)),
                ),
              );
            },
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
            builder: (_, String? val, _) {
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
            builder: (_, double? val, _) {
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
              if (_formKey.currentState?.validate() ?? false) {
                List<String> photos = [];
                for (final e in this.photos) {
                  final url = await StorageController.uploadToStorage(
                    e,
                    "fiesta/${FirebaseAuth.instance.currentUser!.uid}/images/",
                  );
                  if (url == null) return;
                  photos.add(url);
                }

                AppUserModel? host = AppUserModel(
                  id: FirebaseAuth.instance.currentUser!.uid,
                  firstname:
                      (ref.read(userChangeNotifierProvider).userData!
                              as FiestarUserModel)
                          .firstname,
                  lastname:
                      (ref.read(userChangeNotifierProvider).userData!
                              as FiestarUserModel)
                          .lastname,
                  pictures:
                      (ref.read(userChangeNotifierProvider).userData!
                              as FiestarUserModel)
                          .profilImages,
                );

                final rep = await FiestaController.updateFiesta(
                  widget.fiestaId,
                  {
                    "host": host.toJson(),
                    "hostRef": FirebaseFirestore.instance
                        .collection(
                          GetIt.I<ApplicationDataModel>().userCollectionPath,
                        )
                        .doc(FirebaseAuth.instance.currentUser!.uid),
                    "title": _name.value,
                    "category": _category.value,
                    "soundLevel": _soundLevel.value,
                    "tags": _tags.value?.map((e) => e.toJson()).toList(),
                    "description": _desc.value,
                    "visibleAfter": _visibilty.value,
                    "pictures": photos,
                    "address": _address.value?.toMap(),
                    "startAt": _date?.value1,
                    "endAt": _date?.value2,
                    "numberOfParticipant": _nbMaxUser,
                    "logistic": _logistic.value,
                    "thingsToBring": _mustBeBuyed.value
                        ?.map((e) => e.toJson())
                        .toList(),
                    "visibilityRadius": _visibiltyRadius.value,
                    "visibleByFirstCircle": _visibilityData["firstCircle"],
                    "visibleByFiestar": _visibilityData["fiesta"],
                    "visibleByConnexion": _visibilityData["connexion"],
                  },
                  {
                    "title": _name.value,
                    "pictures": photos,
                    "address": _address.value?.toMap(),
                    "startAt": _date?.value1,
                    "endAt": _date?.value2,
                    "visibleAfter": _visibilty.value,
                  },
                );

                if (!context.mounted) return;

                if (rep == true) {
                  NotifBanner.showToast(
                    context: context,
                    fToast: FToast().init(context),
                    subTitle: "app.create-fiesta-error".tr(),
                  );
                  return;
                }

                AutoRouter.of(context).back();
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
