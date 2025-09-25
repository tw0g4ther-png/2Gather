import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/widgets/multi_item_selector/core.dart';
import 'package:twogather/widgets/multi_item_selector/model/item.dart';
import 'package:twogather/widgets/search_bar/core.dart';
import 'package:twogather/widgets/search_bar/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

class UpdateTagsPage extends StatefulHookConsumerWidget {
  const UpdateTagsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateTagsPageState();
}

class _UpdateTagsPageState extends ConsumerState<UpdateTagsPage> {
  final GlobalKey<MultiItemSelectorState> passionKey =
      GlobalKey<MultiItemSelectorState>();
  final List<MultiItemSelectorItem> passionItem = [
    MultiItemSelectorItem(
      name: 'app.tags.passion.musique'.tr(),
      tag: 'musique',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.theatre'.tr(),
      tag: 'theatre',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.chant'.tr(), tag: 'chant'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.instrument-de-musique'.tr(),
      tag: 'instrument-de-musique',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.festivals'.tr(),
      tag: 'festivals',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.voile'.tr(), tag: 'voile'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.sport-equipe'.tr(),
      tag: 'sport-equipe',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.yoga'.tr(), tag: 'yoga'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.arts-martiaux'.tr(),
      tag: 'arts-martiaux',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.art'.tr(), tag: 'art'),
    MultiItemSelectorItem(name: 'app.tags.passion.danse'.tr(), tag: 'danse'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.droit-LGBTQ+'.tr(),
      tag: 'droit-LGBTQ+',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.ecriture'.tr(),
      tag: 'ecriture',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.films'.tr(), tag: 'films'),
    MultiItemSelectorItem(name: 'app.tags.passion.series'.tr(), tag: 'series'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.cuisine'.tr(),
      tag: 'cuisine',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.automobile'.tr(),
      tag: 'automobile',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.nature'.tr(), tag: 'nature'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.politique'.tr(),
      tag: 'politique',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.sneakers'.tr(),
      tag: 'sneakers',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.gaming'.tr(), tag: 'gaming'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.salle-de-sport'.tr(),
      tag: 'salle-de-sport',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.sports-extremes'.tr(),
      tag: 'sports-extremes',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.tatouages'.tr(),
      tag: 'tatouages',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.rugby'.tr(), tag: 'rugby'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.volleyball'.tr(),
      tag: 'volleyball',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.photographie'.tr(),
      tag: 'photographie',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.meditation'.tr(),
      tag: 'meditation',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.voyages'.tr(),
      tag: 'voyages',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.musees'.tr(), tag: 'musees'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.business'.tr(),
      tag: 'business',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.ecologie'.tr(),
      tag: 'ecologie',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.peche'.tr(), tag: 'peche'),
    MultiItemSelectorItem(name: 'app.tags.passion.anime'.tr(), tag: 'anime'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.cosplay'.tr(),
      tag: 'cosplay',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.concerts'.tr(),
      tag: 'concerts',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.patisserie'.tr(),
      tag: 'patisserie',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.sport-nautiques'.tr(),
      tag: 'sport-nautiques',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.mode'.tr(), tag: 'mode'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.bricolage'.tr(),
      tag: 'bricolage',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.moto'.tr(), tag: 'moto'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.happy-hour'.tr(),
      tag: 'happy-hour',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.brunch'.tr(), tag: 'brunch'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.jardinage'.tr(),
      tag: 'jardinage',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.tennis'.tr(), tag: 'tennis'),
    MultiItemSelectorItem(name: 'app.tags.passion.ski'.tr(), tag: 'ski'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.snowboard'.tr(),
      tag: 'snowboard',
    ),
    MultiItemSelectorItem(name: 'app.tags.passion.surf'.tr(), tag: 'surf'),
    MultiItemSelectorItem(
      name: 'app.tags.passion.patinage-artistique'.tr(),
      tag: 'patinage-artistique',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.badminton'.tr(),
      tag: 'badminton',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.passion.football'.tr(),
      tag: 'football',
    ),
  ];

  final GlobalKey<MultiItemSelectorState> fiestaKey =
      GlobalKey<MultiItemSelectorState>();
  final List<MultiItemSelectorItem> fiestaItem = [
    MultiItemSelectorItem(name: 'app.tags.fiesta.repas'.tr(), tag: 'repas'),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.deguisee'.tr(),
      tag: 'deguisee',
    ),
    MultiItemSelectorItem(name: 'app.tags.fiesta.soiree'.tr(), tag: 'soiree'),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.jeux-de-cartes'.tr(),
      tag: 'jeux-de-cartes',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.jeux-de-societe'.tr(),
      tag: 'jeux-de-societe',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.soiree-a-theme'.tr(),
      tag: 'soiree-a-theme',
    ),
    MultiItemSelectorItem(name: 'app.tags.fiesta.poker'.tr(), tag: 'poker'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.chill'.tr(), tag: 'chill'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.dj-set'.tr(), tag: 'dj-set'),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.speciale'.tr(),
      tag: 'speciale',
    ),
    MultiItemSelectorItem(name: 'app.tags.fiesta.masquee'.tr(), tag: 'masquee'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.concert'.tr(), tag: 'concert'),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.entre-potes'.tr(),
      tag: 'entre-potes',
    ),
    MultiItemSelectorItem(name: 'app.tags.fiesta.gaming'.tr(), tag: 'gaming'),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.jeux-alcool'.tr(),
      tag: 'jeux-alcool',
    ),
    MultiItemSelectorItem(name: 'app.tags.fiesta.before'.tr(), tag: 'before'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.after'.tr(), tag: 'after'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.rave'.tr(), tag: 'rave'),
    MultiItemSelectorItem(
      name: 'app.tags.fiesta.soiree-match'.tr(),
      tag: 'soiree-match',
    ),
    MultiItemSelectorItem(name: 'app.tags.fiesta.film'.tr(), tag: 'film'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.apero'.tr(), tag: 'apero'),
    MultiItemSelectorItem(name: 'app.tags.fiesta.karaoke'.tr(), tag: 'karaoke'),
  ];

  final GlobalKey<MultiItemSelectorState> musicKey =
      GlobalKey<MultiItemSelectorState>();
  final List<MultiItemSelectorItem> musicItem = [
    MultiItemSelectorItem(name: 'app.tags.music.hip-hop'.tr(), tag: 'hip-hop'),
    MultiItemSelectorItem(name: 'app.tags.music.pop'.tr(), tag: 'pop'),
    MultiItemSelectorItem(name: 'app.tags.music.rock'.tr(), tag: 'rock'),
    MultiItemSelectorItem(name: 'app.tags.music.rap'.tr(), tag: 'rap'),
    MultiItemSelectorItem(name: 'app.tags.music.rap-Fr'.tr(), tag: 'rap-Fr'),
    MultiItemSelectorItem(name: 'app.tags.music.rap-US'.tr(), tag: 'rap-US'),
    MultiItemSelectorItem(name: 'app.tags.music.techno'.tr(), tag: 'techno'),
    MultiItemSelectorItem(name: 'app.tags.music.house'.tr(), tag: 'house'),
    MultiItemSelectorItem(name: 'app.tags.music.jazz'.tr(), tag: 'jazz'),
    MultiItemSelectorItem(name: 'app.tags.music.punk'.tr(), tag: 'punk'),
    MultiItemSelectorItem(name: 'app.tags.music.funk'.tr(), tag: 'funk'),
    MultiItemSelectorItem(
      name: 'app.tags.music.classique'.tr(),
      tag: 'classique',
    ),
    MultiItemSelectorItem(name: 'app.tags.music.r&b'.tr(), tag: 'r&b'),
    MultiItemSelectorItem(name: 'app.tags.music.reggae'.tr(), tag: 'reggae'),
    MultiItemSelectorItem(
      name: 'app.tags.music.reggaeton'.tr(),
      tag: 'reggaeton',
    ),
    MultiItemSelectorItem(name: 'app.tags.music.latino'.tr(), tag: 'latino'),
    MultiItemSelectorItem(
      name: 'app.tags.music.alternative'.tr(),
      tag: 'alternative',
    ),
    MultiItemSelectorItem(name: 'app.tags.music.electro'.tr(), tag: 'electro'),
    MultiItemSelectorItem(name: 'app.tags.music.variete'.tr(), tag: 'variete'),
    MultiItemSelectorItem(
      name: 'app.tags.music.oldschool'.tr(),
      tag: 'oldschool',
    ),
    MultiItemSelectorItem(name: 'app.tags.music.drill'.tr(), tag: 'drill'),
    MultiItemSelectorItem(name: 'app.tags.music.soul'.tr(), tag: 'soul'),
    MultiItemSelectorItem(name: 'app.tags.music.folk'.tr(), tag: 'folk'),
    MultiItemSelectorItem(name: 'app.tags.music.metal'.tr(), tag: 'metal'),
    MultiItemSelectorItem(name: 'app.tags.music.de-tout'.tr(), tag: 'de-tout'),
    MultiItemSelectorItem(name: 'app.tags.music.blues'.tr(), tag: 'blues'),
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
  ];

  final GlobalKey<MultiItemSelectorState> drinkKey =
      GlobalKey<MultiItemSelectorState>();
  final List<MultiItemSelectorItem> drinkItem = [
    MultiItemSelectorItem(name: 'app.tags.drink.beer'.tr(), tag: 'beer'),
    MultiItemSelectorItem(
      name: 'app.tags.drink.vin-rouge'.tr(),
      tag: 'vin-rouge',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.drink.vin-blanc'.tr(),
      tag: 'vin-blanc',
    ),
    MultiItemSelectorItem(name: 'app.tags.drink.rose'.tr(), tag: 'rose'),
    MultiItemSelectorItem(
      name: 'app.tags.drink.champagne'.tr(),
      tag: 'champagne',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.drink.jagermeister'.tr(),
      tag: 'jagermeister',
    ),
    MultiItemSelectorItem(name: 'app.tags.drink.whisky'.tr(), tag: 'whisky'),
    MultiItemSelectorItem(name: 'app.tags.drink.vodka'.tr(), tag: 'vodka'),
    MultiItemSelectorItem(name: 'app.tags.drink.tequila'.tr(), tag: 'tequila'),
    MultiItemSelectorItem(name: 'app.tags.drink.gin'.tr(), tag: 'gin'),
    MultiItemSelectorItem(name: 'app.tags.drink.rhum'.tr(), tag: 'rhum'),
    MultiItemSelectorItem(name: 'app.tags.drink.ricard'.tr(), tag: 'ricard'),
    MultiItemSelectorItem(
      name: 'app.tags.drink.cocktails'.tr(),
      tag: 'cocktails',
    ),
    MultiItemSelectorItem(name: 'app.tags.drink.eau'.tr(), tag: 'eau'),
    MultiItemSelectorItem(name: 'app.tags.drink.redbull'.tr(), tag: 'redbull'),
    MultiItemSelectorItem(
      name: 'app.tags.drink.schweppes'.tr(),
      tag: 'schweppes',
    ),
    MultiItemSelectorItem(name: 'app.tags.drink.oasis'.tr(), tag: 'oasis'),
    MultiItemSelectorItem(name: 'app.tags.drink.jus'.tr(), tag: 'jus'),
    MultiItemSelectorItem(name: 'app.tags.drink.lipton'.tr(), tag: 'lipton'),
    MultiItemSelectorItem(
      name: 'app.tags.drink.fritz-kola'.tr(),
      tag: 'fritz-kola',
    ),
    MultiItemSelectorItem(name: 'app.tags.drink.monster'.tr(), tag: 'monster'),
    MultiItemSelectorItem(name: 'app.tags.drink.fanta'.tr(), tag: 'fanta'),
    MultiItemSelectorItem(
      name: 'app.tags.drink.coca-cola'.tr(),
      tag: 'coca-cola',
    ),
    MultiItemSelectorItem(
      name: 'app.tags.drink.limonade'.tr(),
      tag: 'limonade',
    ),
    MultiItemSelectorItem(name: 'app.tags.drink.suze'.tr(), tag: 'suze'),
    MultiItemSelectorItem(name: 'app.tags.drink.spritz'.tr(), tag: 'spritz'),
  ];

  String? search;

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
              Column(
                children: [
                  sh(12),
                  SizedBox(
                    height: formatHeight(35),
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            "app.my_tags".tr(),
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
                  CustomSearchBar(
                    options: const [],
                    hint: "app.research-passion".tr(),
                    theme: CustomSearchBarThemeData(
                      constraints: BoxConstraints(minWidth: formatWidth(317)),
                    ),
                    onSearchChanged: (p0) => setState(() => search = p0),
                  ),
                  sh(18),
                  MultiItemSelector(
                    key: passionKey,
                    title: "app.passion".tr(),
                    itemRunSpacing: formatHeight(7.3),
                    itemSpacing: formatWidth(8),
                    defaultActive:
                        (ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .favorite
                            ?.passion
                            ?.map((e) => e.toJson())
                            .toList(),
                    items: passionItem
                        .where(
                          (element) => element.name.toLowerCase().contains(
                            search?.toLowerCase() ?? "",
                          ),
                        )
                        .toList(),
                  ),
                  sh(16.5),
                  MultiItemSelector(
                    key: fiestaKey,
                    title: "app.favorite-fiesta".tr(),
                    itemRunSpacing: formatHeight(7.3),
                    itemSpacing: formatWidth(8),
                    defaultActive:
                        (ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .favorite
                            ?.fiesta
                            ?.map((e) => e.toJson())
                            .toList(),
                    items: fiestaItem
                        .where(
                          (element) => element.name.toLowerCase().contains(
                            search?.toLowerCase() ?? "",
                          ),
                        )
                        .toList(),
                  ),
                  sh(16.5),
                  MultiItemSelector(
                    key: musicKey,
                    title: "app.favorite-music".tr(),
                    itemRunSpacing: formatHeight(7.3),
                    itemSpacing: formatWidth(8),
                    defaultActive:
                        (ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .favorite
                            ?.music
                            ?.map((e) => e.toJson())
                            .toList(),
                    items: musicItem
                        .where(
                          (element) => element.name.toLowerCase().contains(
                            search?.toLowerCase() ?? "",
                          ),
                        )
                        .toList(),
                  ),
                  sh(16.5),
                  MultiItemSelector(
                    key: drinkKey,
                    title: "app.favorite-drink".tr(),
                    itemRunSpacing: formatHeight(7.3),
                    itemSpacing: formatWidth(8),
                    defaultActive:
                        (ref.watch(userChangeNotifierProvider).userData!
                                as FiestarUserModel)
                            .favorite
                            ?.drink
                            ?.map((e) => e.toJson())
                            .toList(),
                    items: drinkItem
                        .where(
                          (element) => element.name.toLowerCase().contains(
                            search?.toLowerCase() ?? "",
                          ),
                        )
                        .toList(),
                  ),
                  sh(16.5),
                  CTA.primary(
                    textButton: "utils.save".tr(),
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final map = {};
                      map["passion"] = passionKey.currentState
                          ?.getActiveItems();
                      map["fiesta"] = fiestaKey.currentState?.getActiveItems();
                      map["music"] = musicKey.currentState?.getActiveItems();
                      map["drink"] = drinkKey.currentState?.getActiveItems();
                      final router = AutoRouter.of(context);
                      await FirebaseFirestore.instance
                          .collection(
                            GetIt.I<ApplicationDataModel>().userCollectionPath,
                          )
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({"favorite": map});
                      if (!mounted) return;
                      router.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
