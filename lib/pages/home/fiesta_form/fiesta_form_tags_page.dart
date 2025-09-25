import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/passion/passion_model.dart';
import 'package:twogather/widgets/multi_item_selector/core.dart';
import 'package:twogather/widgets/multi_item_selector/model/item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/cta/cta.dart';

class FiestaFormTagsPage extends StatefulHookConsumerWidget {
  final List<PassionModel>? tags;

  const FiestaFormTagsPage({super.key, required this.tags});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiestaFormTagsPageState();
}

class _FiestaFormTagsPageState extends ConsumerState<FiestaFormTagsPage> {
  List<PassionModel>? _tags;

  final GlobalKey<MultiItemSelectorState> passionKey =
      GlobalKey<MultiItemSelectorState>();

  @override
  void initState() {
    _tags = widget.tags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ScrollingPage(
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
                        "app.create-fiesta-form.tags".tr(),
                        style: AppTextStyle.black(17),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () => Navigator.pop(context, _tags),
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
              MultiItemSelector(
                key: passionKey,
                title: "app.passion".tr(),
                itemRunSpacing: formatHeight(7.3),
                itemSpacing: formatWidth(8),
                defaultActive: _tags?.map((e) => e.toJson()).toList(),
                items: [
                  MultiItemSelectorItem(
                    name: 'app.tags.music.hip-hop'.tr(),
                    tag: 'hip-hop',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.pop'.tr(),
                    tag: 'pop',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.rock'.tr(),
                    tag: 'rock',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.rap'.tr(),
                    tag: 'rap',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.rap-Fr'.tr(),
                    tag: 'rap-Fr',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.rap-US'.tr(),
                    tag: 'rap-US',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.techno'.tr(),
                    tag: 'techno',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.house'.tr(),
                    tag: 'house',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.jazz'.tr(),
                    tag: 'jazz',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.punk'.tr(),
                    tag: 'punk',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.funk'.tr(),
                    tag: 'funk',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.classique'.tr(),
                    tag: 'classique',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.r&b'.tr(),
                    tag: 'r&b',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.reggae'.tr(),
                    tag: 'reggae',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.reggaeton'.tr(),
                    tag: 'reggaeton',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.latino'.tr(),
                    tag: 'latino',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.alternative'.tr(),
                    tag: 'alternative',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.electro'.tr(),
                    tag: 'electro',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.variete'.tr(),
                    tag: 'variete',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.oldschool'.tr(),
                    tag: 'oldschool',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.drill'.tr(),
                    tag: 'drill',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.soul'.tr(),
                    tag: 'soul',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.folk'.tr(),
                    tag: 'folk',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.metal'.tr(),
                    tag: 'metal',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.de-tout'.tr(),
                    tag: 'de-tout',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.blues'.tr(),
                    tag: 'blues',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.annees-70'.tr(),
                    tag: 'annees-70',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.annees-80'.tr(),
                    tag: 'annees-80',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.annees-90'.tr(),
                    tag: 'annees-90',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.annees-2000'.tr(),
                    tag: 'annees-2000',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.annees-2010'.tr(),
                    tag: 'annees-2010',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.music.dj'.tr(),
                    tag: 'dj',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.home'.tr(),
                    tag: 'home',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.student'.tr(),
                    tag: 'student',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.balcon'.tr(),
                    tag: 'balcon',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.rooftop'.tr(),
                    tag: 'rooftop',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.pool'.tr(),
                    tag: 'pool',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.terasse'.tr(),
                    tag: 'terasse',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.jacuzzi'.tr(),
                    tag: 'jacuzzi',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.tv'.tr(),
                    tag: 'tv',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.projector'.tr(),
                    tag: 'projector',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.console'.tr(),
                    tag: 'console',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.music'.tr(),
                    tag: 'music',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.fiesta.no-choose'.tr(),
                    tag: 'no-choose',
                  ),
                ],
              ),
              sh(30),
              CTA.primary(
                textButton: "utils.validate".tr(),
                width: double.infinity,
                onTap: () {
                  final passion = passionKey.currentState
                      ?.getActiveItems()
                      .map((e) => PassionModel.fromJson(e))
                      .toList();
                  Navigator.of(context).pop(passion);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
