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

class FiestaFormThingsPage extends StatefulHookConsumerWidget {
  final List<PassionModel>? tags;

  const FiestaFormThingsPage({super.key, required this.tags});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiestaFormThingsPageState();
}

class _FiestaFormThingsPageState extends ConsumerState<FiestaFormThingsPage> {
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
                    name: 'app.tags.drink.beer'.tr(),
                    tag: 'beer',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.vin-rouge'.tr(),
                    tag: 'vin-rouge',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.vin-blanc'.tr(),
                    tag: 'vin-blanc',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.rose'.tr(),
                    tag: 'rose',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.champagne'.tr(),
                    tag: 'champagne',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.jagermeister'.tr(),
                    tag: 'jagermeister',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.whisky'.tr(),
                    tag: 'whisky',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.vodka'.tr(),
                    tag: 'vodka',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.tequila'.tr(),
                    tag: 'tequila',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.gin'.tr(),
                    tag: 'gin',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.rhum'.tr(),
                    tag: 'rhum',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.ricard'.tr(),
                    tag: 'ricard',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.cocktails'.tr(),
                    tag: 'cocktails',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.redbull'.tr(),
                    tag: 'redbull',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.schweppes'.tr(),
                    tag: 'schweppes',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.oasis'.tr(),
                    tag: 'oasis',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.jus'.tr(),
                    tag: 'jus',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.lipton'.tr(),
                    tag: 'lipton',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.fritz-kola'.tr(),
                    tag: 'fritz-kola',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.monster'.tr(),
                    tag: 'monster',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.fanta'.tr(),
                    tag: 'fanta',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.coca-cola'.tr(),
                    tag: 'coca-cola',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.limonade'.tr(),
                    tag: 'limonade',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.suze'.tr(),
                    tag: 'suze',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.spritz'.tr(),
                    tag: 'spritz',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.apero-sale'.tr(),
                    tag: 'apero-sale',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.apero-sucre'.tr(),
                    tag: 'apero-sucre',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.ingredient'.tr(),
                    tag: 'ingredient',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.fun'.tr(),
                    tag: 'fun',
                  ),
                  MultiItemSelectorItem(
                    name: 'app.tags.drink.nothing'.tr(),
                    tag: 'nothing',
                  ),
                ],
              ),
              sh(30),
              CTA.primary(
                textButton: "utils.validate".tr(),
                width: double.infinity,
                onTap: () {
                  final things = passionKey.currentState
                      ?.getActiveItems()
                      .map((e) => PassionModel.fromJson(e))
                      .toList();
                  Navigator.of(context).pop(things);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
