// ignore_for_file: prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:twogather/controller/fiesta_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/fiesta/fiesta_model.dart';
import 'package:twogather/model/user/app_user/app_user_model.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/widgets/button/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class ChooseDuoPage extends StatefulHookConsumerWidget {
  final String fiestaId;
  final FiestaModel data;

  const ChooseDuoPage({super.key, required this.fiestaId, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChooseDuoPageState();
}

class _ChooseDuoPageState extends ConsumerState<ChooseDuoPage> {
  ValueNotifier<List<AppUserModel?>> _user = ValueNotifier([]);
  late Future<List<AppUserModel>> _users;

  @override
  void initState() {
    _users = FiestaController.getFriendUserForSameFiesta(
      FirebaseAuth.instance.currentUser!.uid,
      widget.fiestaId,
      ref.read(userChangeNotifierProvider).userData! as FiestarUserModel,
      widget.data,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColor.mainColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: formatWidth(29)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh(12),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      width: formatWidth(47),
                      height: formatWidth(47),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFF02132B).withValues(alpha: .13),
                      ),
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                sh(34),
                Expanded(
                  child: FutureBuilder(
                    future: _users,
                    builder: (_, AsyncSnapshot<List<AppUserModel>?> snap) {
                      if (snap.hasData && snap.data != null) {
                        printInDebug(snap.data);
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "${snap.data!.length} fiestars veulent aller à cet événement",
                              style: AppTextStyle.white(27, FontWeight.bold),
                            ),
                            sh(7),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: formatWidth(20),
                              ),
                              child: Text(
                                "${snap.data!.length} fiestars ont liké cet événement.\nAvec qui souhaiterais-tu y aller ?",
                                style: AppTextStyle.white(13, FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            sh(14),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: formatWidth(14),
                                      height: formatWidth(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFDB12),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                    sw(6),
                                    Text(
                                      "1er Cercle",
                                      style: AppTextStyle.white(
                                        12,
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: formatWidth(14),
                                      height: formatWidth(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5FEC69),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                    sw(6),
                                    Text(
                                      "Mes fiestars",
                                      style: AppTextStyle.white(
                                        12,
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: formatWidth(14),
                                      height: formatWidth(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5C81FF),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                    sw(6),
                                    Text(
                                      "Mes connexions",
                                      style: AppTextStyle.white(
                                        12,
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            sh(30),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Fiestars",
                                style: AppTextStyle.white(14, FontWeight.w600),
                              ),
                            ),
                            sh(3),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                primary: true,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...snap.data!.map(
                                      (e) => _buildFiestarsBox(context, e),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(child: LoaderClassique());
                    },
                  ),
                ),
                sh(20),
                CTA.primary(
                  themeName: "primary_white",
                  textButton: "Proposer la partication au Host",
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pop(_user.value.isEmpty ? null : _user.value.first);
                  },
                ),
                sh(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiestarsBox(BuildContext context, AppUserModel user) {
    final friendType =
        (ref.read(userChangeNotifierProvider).userData! as FiestarUserModel)
            .friends
            ?.where((e) => (e["user"] as DocumentReference).id == user.id)
            .first["type"];

    return InkWell(
      onTap: () {
        if (_user.value.contains(user)) {
          _user.value = List<AppUserModel>.from([]);
        } else {
          _user.value = List<AppUserModel>.from([user]);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: formatWidth(12),
          vertical: formatHeight(12),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5).withValues(alpha: .11),
          borderRadius: BorderRadius.circular(7),
        ),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: formatWidth(37),
                    height: formatWidth(37),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Color(
                          friendType == "1_circle"
                              ? 0xFFFFDB12
                              : friendType == "fiestar"
                              ? 0xFF5FEC69
                              : 0xFF5C81FF,
                        ),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: user.pictures!.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  sw(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.firstname!,
                        style: AppTextStyle.white(13, FontWeight.w500),
                      ),
                      sh(3),
                      Text(
                        "Envoyer demande de Lock Duo par tchat",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .65),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            sw(8),
            ValueListenableBuilder(
              valueListenable: _user,
              builder: (context, List<AppUserModel?> data, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: formatWidth(20),
                  height: formatWidth(20),
                  decoration: BoxDecoration(
                    color: data.contains(user)
                        ? Colors.white
                        : Colors.white.withValues(alpha: .28),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: data.contains(user)
                      ? Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColor.mainColor,
                            size: 16,
                          ),
                        )
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
