import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/pages/complete_profil/complete_profil.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:ui_kosmos_v4/form/form.dart';

class TrustCodePage extends StatefulHookConsumerWidget {
  final Function? onSubmit;

  const TrustCodePage({super.key, this.onSubmit});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrustCodePageState();
}

class _TrustCodePageState extends ConsumerState<TrustCodePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? trustCode;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "app.trust-code".tr(),
            style: AppTextStyle.black(23),
            textAlign: TextAlign.center,
          ),
          sh(8),
          Text(
            "app.trust-code-desc".tr(),
            style: AppTextStyle.gray(13),
            textAlign: TextAlign.center,
          ),
          sh(30),
          TextFormUpdated.classic(
            fieldName: "${"app.trust-code".tr()}*",
            hintText: "app.trust-code-hint".tr(),
            defaultValue: ref.watch(completeProfilProvider).data["trustCode"],
            onChanged: (val) => trustCode = val,
            validator: (p0) => p0?.isEmpty ?? true
                ? "field.form-validator.required-field".tr()
                : null,
          ),
          sh(30),
          CTA.primary(
            textButton: "utils.next".tr(),
            loading: _isLoading,
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (_formKey.currentState?.validate() ?? false) {
                // Vérifier que trustCode n'est pas null avant de continuer
                if (trustCode != null) {
                  // Activer le loader
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    // Simple sauvegarde du code sans validation
                    ref
                        .read(completeProfilProvider)
                        .addFieldToData("trustCode", trustCode);
                    ref.read(completeProfilProvider).setTrustCode(trustCode!);

                    printInDebug(
                      "[TrustCodePage] Code de confiance sauvegardé: $trustCode",
                    );

                    if (widget.onSubmit != null) {
                      widget.onSubmit!();
                    }
                  } catch (e) {
                    printInDebug(
                      "[TrustCodePage] Erreur lors de la sauvegarde: $e",
                    );
                  } finally {
                    // Désactiver le loader
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                } else {
                  printInDebug("[TrustCodePage] Erreur: trustCode est null");
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
      ),
    );
  }
}
