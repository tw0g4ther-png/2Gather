import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';
import 'package:ui_kosmos_v4/form/form.dart';

class UpdateDescription extends StatefulHookConsumerWidget {
  const UpdateDescription({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateDescriptionState();
}

class _UpdateDescriptionState extends ConsumerState<UpdateDescription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _description;

  @override
  void initState() {
    _description =
        (ref.read(userChangeNotifierProvider).userData! as FiestarUserModel)
            .description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh(12),
              SizedBox(
                height: formatHeight(35),
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "utils.desc".tr(),
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
              TextFormUpdated.textarea(
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(7),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(7),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(7),
                ),
                fieldName: "app.update-description".tr(),
                initialValue:
                    (ref.watch(userChangeNotifierProvider).userData!
                            as FiestarUserModel)
                        .description,
                onChanged: (val) => _description = val,
              ),
              sh(30),
              CTA.primary(
                width: double.infinity,
                textButton: "utils.save".tr(),
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final router = AutoRouter.of(context);
                    await FirebaseFirestore.instance
                        .collection(
                          GetIt.I<ApplicationDataModel>().userCollectionPath,
                        )
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"description": _description});
                    if (!mounted) return;
                    router.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
