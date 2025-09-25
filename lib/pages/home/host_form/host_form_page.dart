import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/controller/host_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/micro_element/theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

@RoutePage()
class HostFormPage extends StatefulHookConsumerWidget {
  const HostFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HostFormPageState();
}

class _HostFormPageState extends ConsumerState<HostFormPage> {
  int currentPage = 0;

  final ValueNotifier<double?> _alreadyInviteValue = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> _frequencyInviteValue = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> _goodStateInviteValue = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> _handleEventInviteValue = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> _problemWithneighbourValue =
      ValueNotifier<double?>(null);
  final ValueNotifier<double?> _problemWithPolicyValue = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> _trustValue = ValueNotifier<double?>(null);
  final ValueNotifier<double?> _createFrequencyValue = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> _wantHelpValue = ValueNotifier<double?>(null);
  final ValueNotifier<double?> _allGoodLegalyValue = ValueNotifier<double?>(
    null,
  );

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
                    "utils.eligibilty".tr(),
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
          ProgressBar(
            max: 2,
            current: currentPage + 1,
            customSmallTitle: "Étape ${currentPage + 1} / 2",
            theme: ProgressBarThemeData(color: AppColor.mainColor),
          ),
          sh(12),
          SizedBox(
            width: double.infinity,
            child: Text(
              "app.became-host".tr(),
              style: AppTextStyle.darkBlue(20, FontWeight.w600),
            ),
          ),
          sh(21),
          if (currentPage == 0)
            _buildForm(context)
          else if (currentPage == 1)
            _buildChart(context),
          sh(50),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: _alreadyInviteValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.already-invite-someone".tr(),
              value: val ?? 0,
              onChanged: (p1) => _alreadyInviteValue.value = p1,
              items: [
                DropdownMenuItem(value: 0, child: Text("utils.yes".tr())),
                DropdownMenuItem(value: 1, child: Text("utils.no".tr())),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _frequencyInviteValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.frequency-invite".tr(),
              value: val,
              onChanged: (p1) => _frequencyInviteValue.value = p1,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text("utils.lower-than-one-per-month".tr()),
                ),
                DropdownMenuItem(
                  value: .6,
                  child: Text("utils.one-per-month".tr()),
                ),
                DropdownMenuItem(
                  value: .4,
                  child: Text("utils.more-than-one-per-month".tr()),
                ),
                DropdownMenuItem(
                  value: 0,
                  child: Text("utils.every-week".tr()),
                ),
                DropdownMenuItem(
                  value: -.2,
                  child: Text("utils.more-than-one-per-week".tr()),
                ),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _goodStateInviteValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.all-good".tr(),
              value: val,
              onChanged: (p1) => _goodStateInviteValue.value = p1,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text("utils.not-at-all".tr()),
                ),
                DropdownMenuItem(
                  value: .8,
                  child: Text("utils.rather-not".tr()),
                ),
                DropdownMenuItem(
                  value: .6,
                  child: Text("utils.moderatly-well".tr()),
                ),
                DropdownMenuItem(
                  value: .4,
                  child: Text("utils.pretty-good".tr()),
                ),
                DropdownMenuItem(
                  value: .2,
                  child: Text("utils.very-good".tr()),
                ),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _handleEventInviteValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.already-invite-someone".tr(),
              value: val,
              onChanged: (p1) => _handleEventInviteValue.value = p1,
              items: [
                DropdownMenuItem(value: .6, child: Text("utils.in-group".tr())),
                DropdownMenuItem(value: .2, child: Text("utils.alone".tr())),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _problemWithneighbourValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.neighboor-problem".tr(),
              value: val,
              onChanged: (p1) => _problemWithneighbourValue.value = p1,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text("app.host-form.never".tr()),
                ),
                DropdownMenuItem(
                  value: .5,
                  child: Text("app.host-form.one-time".tr()),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("app.host-form.rarely".tr()),
                ),
                DropdownMenuItem(
                  value: 100,
                  child: Text("app.host-form.often".tr()),
                ),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _problemWithPolicyValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.policy-problem".tr(),
              value: val,
              onChanged: (p1) => _problemWithPolicyValue.value = p1,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text("app.host-form.never".tr()),
                ),
                DropdownMenuItem(
                  value: .5,
                  child: Text("app.host-form.one-time".tr()),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text("app.host-form.rarely".tr()),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("app.host-form.often".tr()),
                ),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _trustValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.confident-to-handle".tr(),
              value: val,
              onChanged: (p1) => _trustValue.value = p1,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text("utils.not-at-all".tr()),
                ),
                DropdownMenuItem(
                  value: .8,
                  child: Text("utils.rather-not".tr()),
                ),
                DropdownMenuItem(
                  value: .6,
                  child: Text("utils.moderatly-well".tr()),
                ),
                DropdownMenuItem(
                  value: .4,
                  child: Text("utils.pretty-good".tr()),
                ),
                DropdownMenuItem(
                  value: .2,
                  child: Text("utils.very-good-exp".tr()),
                ),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _createFrequencyValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.frequency-create".tr(),
              value: val,
              onChanged: (p1) => _createFrequencyValue.value = p1,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text("utils.lower-than-one-per-month".tr()),
                ),
                DropdownMenuItem(
                  value: .6,
                  child: Text("utils.one-per-month".tr()),
                ),
                DropdownMenuItem(
                  value: .4,
                  child: Text("utils.more-than-one-per-month".tr()),
                ),
                DropdownMenuItem(
                  value: 0,
                  child: Text("utils.every-week".tr()),
                ),
                DropdownMenuItem(
                  value: -.2,
                  child: Text("utils.more-than-one-per-week".tr()),
                ),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _wantHelpValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.want-help".tr(),
              value: val,
              onChanged: (p1) => _wantHelpValue.value = p1,
              items: [
                DropdownMenuItem(value: 0, child: Text("utils.yes".tr())),
                DropdownMenuItem(value: .1, child: Text("utils.no".tr())),
              ],
            );
          },
        ),
        sh(13),
        ValueListenableBuilder(
          valueListenable: _allGoodLegalyValue,
          builder: (context, double? val, child) {
            return ModernDropdownField<double>(
              fieldName: "app.host-form.legaly-good".tr(),
              value: val,
              onChanged: (p1) => _allGoodLegalyValue.value = p1,
              items: [
                DropdownMenuItem(value: 0, child: Text("utils.yes".tr())),
                DropdownMenuItem(value: 100, child: Text("utils.no".tr())),
              ],
            );
          },
        ),
        sh(34),
        CTA.primary(
          textButton: "utils.next".tr(),
          onTap: () async {
            final rep = await _checkIfCanBecomeHost();
            if (rep) {
              if (!context.mounted) return;
              AutoRouter.of(context).back();
              return;
            }
            setState(() {
              currentPage++;
            });
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
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(1, "Lorem Ipsum"),
        sh(16),
        _buildSection(2, "Lorem Ipsum"),
        sh(16),
        _buildSection(3, "Lorem Ipsum"),
        sh(16),
        _buildSection(4, "Lorem Ipsum"),
        sh(16),
        _buildSection(5, "Lorem Ipsum"),
        sh(16),
        _buildSection(6, "Lorem Ipsum"),
        sh(16),
        _buildSection(7, "Lorem Ipsum"),
        sh(16),
        _buildSection(8, "Lorem Ipsum"),
        sh(16),
        _buildSection(9, "Lorem Ipsum"),
        sh(16),
        _buildSection(10, "Lorem Ipsum"),
        sh(34),
        CTA.primary(
          textButton: "app.accept-and-become-host".tr(),
          onTap: () async {
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            AutoRouter.of(context).back();
          },
        ),
      ],
    );
  }

  Widget _buildSection(int number, String message) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: formatWidth(20),
          height: formatWidth(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.mainColor,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: AppTextStyle.white(13, FontWeight.w600),
            ),
          ),
        ),
        sw(12),
        Expanded(child: Text(message, style: AppTextStyle.darkGray(13))),
      ],
    );
  }

  Future<bool> _checkIfCanBecomeHost() async {
    double val = 0;
    val += _alreadyInviteValue.value ?? 0;
    val += _frequencyInviteValue.value ?? 0;
    val += _goodStateInviteValue.value ?? 0;
    val += _handleEventInviteValue.value ?? 0;
    val += _problemWithneighbourValue.value ?? 0;
    val += _problemWithPolicyValue.value ?? 0;
    val += _trustValue.value ?? 0;
    val += _createFrequencyValue.value ?? 0;
    val += _wantHelpValue.value ?? 0;
    val += _allGoodLegalyValue.value ?? 0;

    if (val > 8) {
      NotifBanner.showToast(
        context: context,
        fToast: FToast().init(context),
        subTitle: "app.become-host-error".tr(),
      );
      return true;
    }

    await HostController.setToHost(FirebaseAuth.instance.currentUser!.uid);
    return false;
  }
}
