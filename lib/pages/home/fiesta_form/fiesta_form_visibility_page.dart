import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class FiestaFormVisibilityPage extends StatefulHookConsumerWidget {
  final Map<String, dynamic> data;

  const FiestaFormVisibilityPage({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiestaFormVisibilityPageState();
}

class _FiestaFormVisibilityPageState
    extends ConsumerState<FiestaFormVisibilityPage> {
  final ValueNotifier<bool> _firstCircle = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _fiestarCircle = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _connnexionCircle = ValueNotifier<bool>(true);

  late Map<String, dynamic> data;

  @override
  void initState() {
    data = widget.data;
    _fiestarCircle.value = data["fiestar"];
    _connnexionCircle.value = data["connexion"];
    _firstCircle.value = data["firstCircle"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClampingPage(
      useSafeArea: true,
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
                    "app.create-fiesta-form.visibilty-circle".tr(),
                    style: AppTextStyle.black(17),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context, data),
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
          ValueListenableBuilder(
            valueListenable: _firstCircle,
            builder: (context, bool val, child) {
              return ModernDropdownField<bool>(
                fieldName:
                    "${"app.create-fiesta-form.visibility-first-circle".tr()}*",
                value: val,
                onChanged: (p0) => _firstCircle.value = p0!,
                validator: (p0) => p0 == null
                    ? "field.form-validator.all-field-must-have-value".tr()
                    : null,
                items: [
                  DropdownMenuItem(value: true, child: Text("utils.yes".tr())),
                  DropdownMenuItem(value: false, child: Text("utils.no".tr())),
                ],
              );
            },
          ),
          sh(28),
          ValueListenableBuilder(
            valueListenable: _fiestarCircle,
            builder: (context, bool val, child) {
              return ModernDropdownField<bool>(
                fieldName:
                    "${"app.create-fiesta-form.visibility-fiestar-circle".tr()}*",
                value: val,
                onChanged: (p0) => _fiestarCircle.value = p0!,
                validator: (p0) => p0 == null
                    ? "field.form-validator.all-field-must-have-value".tr()
                    : null,
                items: [
                  DropdownMenuItem(value: true, child: Text("utils.yes".tr())),
                  DropdownMenuItem(value: false, child: Text("utils.no".tr())),
                ],
              );
            },
          ),
          sh(28),
          ValueListenableBuilder(
            valueListenable: _connnexionCircle,
            builder: (context, bool val, child) {
              return ModernDropdownField<bool>(
                fieldName:
                    "${"app.create-fiesta-form.visibility-connexion-circle".tr()}*",
                value: val,
                onChanged: (p0) => _connnexionCircle.value = p0!,
                validator: (p0) => p0 == null
                    ? "field.form-validator.all-field-must-have-value".tr()
                    : null,
                items: [
                  DropdownMenuItem(value: true, child: Text("utils.yes".tr())),
                  DropdownMenuItem(value: false, child: Text("utils.no".tr())),
                ],
              );
            },
          ),
          sh(50),
          CTA.primary(
            textButton: "utils.validate".tr(),
            onTap: () {
              data["firstCircle"] = _firstCircle.value;
              data["fiestar"] = _fiestarCircle.value;
              data["connexion"] = _connnexionCircle.value;
              Navigator.of(context).pop(data);
            },
          ),
        ],
      ),
    );
  }
}
