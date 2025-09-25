import 'dart:async';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twogather/chat/freezed/salon/salonModel.dart' as salon;
import 'package:twogather/chat/widgets/messages/locked_demand.dart';
import 'package:twogather/controller/friend_controller.dart';
import 'package:twogather/model/color.dart';
import 'package:twogather/model/user/fiestar_model.dart';
import 'package:twogather/widgets/alert/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

import '../freezed/userState/userState.dart';
import '../widgets/chatPage/helper.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'shareContent.dart';
import '../freezed/userAction/userAction.dart';

import '../riverpods/me_notifier.dart';
import '../services/firestore/index.dart';
import '../services/realtimeDatabse/database_service.dart';
import '../widgets/chatPage/selected.dart';
import 'package:shimmer/shimmer.dart';
import '../enum/enumMessage.dart';
import '../freezed/message/messageModel.dart';
import '../riverpods/animations_notifier.dart';
import '../riverpods/salon_messages_notifier.dart';
import '../widgets/bottomInput/slide_to_delete.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../riverpods/salon_river.dart';
import '../widgets/bottomInput/text_input_field.dart';
import '../widgets/messages/image_message.dart';
import '../widgets/messages/text_message.dart';
import '../widgets/messages/video_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/keyboard_footer_layout.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class IndexChatPage extends ConsumerStatefulWidget {
  final String salonId;
  final String meId;
  final SalonType salonType;

  const IndexChatPage({
    super.key,
    required this.salonId,
    required this.meId,
    required this.salonType,
  });

  @override
  IndexChatPageState createState() => IndexChatPageState();
}

class IndexChatPageState extends ConsumerState<IndexChatPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double? lastScrollLoaded;

  int lastLoaded = 20;
  bool isKeyboardVisible = false;
  Timer? timerStatus;
  bool typing = false;
  FocusNode focusNode = FocusNode();
  late ScrollController scrollController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late AnimationController controller;
  final TextEditingController _controller = TextEditingController();

  void _controllerChange() {
    if (_controller.text.isNotEmpty) {
      RealtimeDatabaseQuery.updateStatus(
        idSalon: widget.salonId,
        actionUser: ActionUser(
          action: UserAction.typing,
          idUser: widget.meId,
          dateTime: DateTime.now(),
        ),
      );
    } else if (_controller.text.isEmpty) {
      RealtimeDatabaseQuery.updateStatus(
        idSalon: widget.salonId,
        actionUser: ActionUser(
          action: UserAction.normal,
          idUser: widget.meId,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  void setTimer() {
    timerStatus = Timer.periodic(const Duration(minutes: 1), (timer) {
      RealtimeDatabaseQuery.updateOnlineOfflineStatus(
        idSalon: widget.salonId,
        userState: UserState(
          idUser: widget.meId,
          state: StateOfUser.online,
          lastUpdate: DateTime.now(),
        ),
      );
    });
  }

  @override
  void initState() {
    setTimer();
    scrollController = ScrollController(initialScrollOffset: 0);
    _controller.addListener(_controllerChange);
    RealtimeDatabaseQuery.updateOnlineOfflineStatus(
      idSalon: widget.salonId,
      userState: UserState(
        idUser: widget.meId,
        state: StateOfUser.online,
        lastUpdate: DateTime.now(),
      ),
    );
    KeyboardVisibilityController().onChange.listen((bool isKeyboardVisible) {
      if (mounted) {
        setState(() {
          isKeyboardVisible = isKeyboardVisible;
        });
      }
    });

    itemPositionsListener.itemPositions.addListener(() {
      if (mounted) {
        int? min, max;

        if (itemPositionsListener.itemPositions.value.isNotEmpty) {
          // Determine the first visible item by finding the item with the
          // smallest trailing edge that is greater than 0.  i.e. the first
          // item whose trailing edge in visible in the viewport.
          min = itemPositionsListener.itemPositions.value
              .where((ItemPosition position) => position.itemTrailingEdge > 0)
              .reduce(
                (ItemPosition min, ItemPosition position) =>
                    position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min,
              )
              .index;
          // Determine the last visible item by finding the item with the
          // greatest leading edge that is less than 1.  i.e. the last
          // item whose leading edge in visible in the viewport.
          max = itemPositionsListener.itemPositions.value
              .where((ItemPosition position) => position.itemLeadingEdge < 1)
              .reduce(
                (ItemPosition max, ItemPosition position) =>
                    position.itemLeadingEdge > max.itemLeadingEdge
                    ? position
                    : max,
              )
              .index;
          if (max == lastLoaded - 5) {
            debugPrint('NEWWWWLOAD');
            setState(() {
              lastLoaded = lastLoaded + 20;
            });
            ref.read(messageFirestoreRiver).loadMore();
          }
          debugPrint("Min:==>$min");
          debugPrint("Min:==>$max");
        }
      }
    });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(animationController).init(this);
      ref.read(salonMessagesNotifier).setBottomBarState(BottomBarState.normal);

      // Reprendre les listeners si nécessaire
      ref.read(messageFirestoreRiver).resumeListeners();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setTimer();
        RealtimeDatabaseQuery.updateOnlineOfflineStatus(
          idSalon: widget.salonId,
          userState: UserState(
            idUser: widget.meId,
            state: StateOfUser.online,
            lastUpdate: DateTime.now(),
          ),
        );

        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        timerStatus?.cancel();

        RealtimeDatabaseQuery.updateOnlineOfflineStatus(
          idSalon: widget.salonId,
          userState: UserState(
            idUser: widget.meId,
            state: StateOfUser.offline,
            lastUpdate: DateTime.now(),
          ),
        );
        RealtimeDatabaseQuery.updateStatus(
          idSalon: widget.salonId,
          actionUser: ActionUser(
            action: UserAction.normal,
            idUser: widget.meId,
            dateTime: DateTime.now(),
          ),
        );
    }
  }

  @override
  void dispose() {
    RealtimeDatabaseQuery.updateOnlineOfflineStatus(
      idSalon: widget.salonId,
      userState: UserState(
        idUser: widget.meId,
        state: StateOfUser.offline,
        lastUpdate: DateTime.now(),
      ),
    );
    RealtimeDatabaseQuery.updateStatus(
      idSalon: widget.salonId,
      actionUser: ActionUser(
        action: UserAction.normal,
        idUser: widget.meId,
        dateTime: DateTime.now(),
      ),
    );

    WidgetsBinding.instance.removeObserver(this);
    timerStatus?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          RealtimeDatabaseQuery.updateOnlineOfflineStatus(
            idSalon: widget.salonId,
            userState: UserState(
              idUser: widget.meId,
              state: StateOfUser.offline,
              lastUpdate: DateTime.now(),
            ),
          );
          ref.read(messageFirestoreRiver).pauseListeners();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: FooterLayout(
            footer: SizedBox(child: _footer()),
            child: Stack(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (focusNode.hasFocus) {
                      focusNode.unfocus();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: Column(
                      children: [
                        // Header avec photo de profil et nom de l'utilisateur distant
                        Container(
                          height: 60,
                          color: Colors.grey[100],
                          child: _buildChatHeader(),
                        ),
                        AnimationLimiter(
                          child: Expanded(
                            child: ScrollablePositionedList.builder(
                              initialScrollIndex: ref
                                  .watch(salonMessagesNotifier)
                                  .getMessages()
                                  .length,
                              itemPositionsListener: itemPositionsListener,
                              addAutomaticKeepAlives: false,
                              itemScrollController: itemScrollController,
                              reverse: true,
                              padding: EdgeInsets.only(
                                bottom: 60
                                    .h, // Plus d'espace pour éviter que la bulle Lock Duo cache les messages
                                top: 20,
                              ),
                              itemCount: ref
                                  .watch(salonMessagesNotifier)
                                  .getMessages()
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                bool useSticker = false;
                                // ignore: unused_local_variable
                                DateTime date = ref
                                    .read(salonMessagesNotifier)
                                    .getMessages()[index]
                                    .createdAt;

                                if (index == 0) {
                                  if (ref
                                          .read(salonMessagesNotifier)
                                          .getMessages()
                                          .length <
                                      2) {
                                    // ignore: unused_local_variable
                                    int diff = ref
                                        .read(salonMessagesNotifier)
                                        .getMessages()[0]
                                        .createdAt
                                        .difference(DateTime.now())
                                        .inDays;

                                    useSticker = true;
                                  } else if ([0, 1].contains(
                                    ref
                                        .read(salonMessagesNotifier)
                                        .getMessages()[0]
                                        .createdAt
                                        .difference(
                                          ref
                                              .read(salonMessagesNotifier)
                                              .getMessages()[1]
                                              .createdAt,
                                        )
                                        .inDays,
                                  )) {
                                    if (ref
                                            .read(salonMessagesNotifier)
                                            .getMessages()[0]
                                            .createdAt
                                            .day !=
                                        ref
                                            .read(salonMessagesNotifier)
                                            .getMessages()[1]
                                            .createdAt
                                            .day) {
                                      useSticker = true;
                                    }
                                  } else if (ref
                                          .read(salonMessagesNotifier)
                                          .getMessages()[0]
                                          .createdAt
                                          .difference(
                                            ref
                                                .read(salonMessagesNotifier)
                                                .getMessages()[1]
                                                .createdAt,
                                          )
                                          .inDays >=
                                      1) {
                                    useSticker = true;
                                  }
                                } else if (index ==
                                    (ref
                                            .read(salonMessagesNotifier)
                                            .getMessages()
                                            .length -
                                        1)) {
                                  useSticker = true;
                                } else {
                                  if (ref
                                          .read(salonMessagesNotifier)
                                          .getMessages()[index]
                                          .createdAt
                                          .day !=
                                      ref
                                          .read(salonMessagesNotifier)
                                          .getMessages()[index + 1]
                                          .createdAt
                                          .day) {
                                    useSticker = true;
                                  }
                                }

                                switch (ref
                                    .watch(salonMessagesNotifier)
                                    .getMessages()[index]
                                    .type) {
                                  case MessageContentType.videoMessage:
                                    return Column(
                                      children: [
                                        useSticker
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                            minWidth: 95.w,
                                                            minHeight: 34.h,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  0,
                                                                ),
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.10,
                                                                ),
                                                            blurRadius: 35,
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9,
                                                            ),
                                                        color: const Color(
                                                          0XFFF6F6F6,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          stickerDate(
                                                            ref
                                                                .watch(
                                                                  salonMessagesNotifier,
                                                                )
                                                                .getMessages()[index]
                                                                .createdAt,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                        selected(
                                          ref: ref,
                                          childId: ref
                                              .watch(salonMessagesNotifier)
                                              .getMessages()[index]
                                              .id!,
                                          child:
                                              AnimationConfiguration.staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                  milliseconds: 375,
                                                ),
                                                child: SlideAnimation(
                                                  horizontalOffset: 0,
                                                  verticalOffset: 50.0,
                                                  child: FadeInAnimation(
                                                    child: SimpleVideo(
                                                      messageModel: ref
                                                          .watch(
                                                            salonMessagesNotifier,
                                                          )
                                                          .getMessages()[index],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ],
                                    );

                                  case MessageContentType.textMessage:
                                    return Column(
                                      children: [
                                        useSticker
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                            minWidth: 95.w,
                                                            minHeight: 34.h,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  0,
                                                                ),
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.10,
                                                                ),
                                                            blurRadius: 35,
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9,
                                                            ),
                                                        color: const Color(
                                                          0XFFF6F6F6,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12.w,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            stickerDate(
                                                              ref
                                                                  .watch(
                                                                    salonMessagesNotifier,
                                                                  )
                                                                  .getMessages()[index]
                                                                  .createdAt,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                        selected(
                                          ref: ref,
                                          childId: ref
                                              .watch(salonMessagesNotifier)
                                              .getMessages()[index]
                                              .id!,
                                          child:
                                              AnimationConfiguration.staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                  milliseconds: 375,
                                                ),
                                                child: SlideAnimation(
                                                  verticalOffset: 100.0,
                                                  child: FlipAnimation(
                                                    child: textMessage(
                                                      ref
                                                          .watch(
                                                            salonMessagesNotifier,
                                                          )
                                                          .getMessages()[index],
                                                      ref,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ],
                                    );

                                  case MessageContentType.imageMessage:
                                    return Column(
                                      children: [
                                        useSticker
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                            minWidth: 95.w,
                                                            minHeight: 34.h,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  0,
                                                                ),
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.10,
                                                                ),
                                                            blurRadius: 35,
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9,
                                                            ),
                                                        color: const Color(
                                                          0XFFF6F6F6,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          stickerDate(
                                                            ref
                                                                .watch(
                                                                  salonMessagesNotifier,
                                                                )
                                                                .getMessages()[index]
                                                                .createdAt,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                        selected(
                                          ref: ref,
                                          childId: ref
                                              .watch(salonMessagesNotifier)
                                              .getMessages()[index]
                                              .id!,
                                          child:
                                              AnimationConfiguration.staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                  milliseconds: 375,
                                                ),
                                                child: SlideAnimation(
                                                  verticalOffset: 100.0,
                                                  child: FadeInAnimation(
                                                    child: SimpleImage(
                                                      messageModel: ref
                                                          .watch(
                                                            salonMessagesNotifier,
                                                          )
                                                          .getMessages()[index],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ],
                                    );

                                  case MessageContentType.lockDemandMessage:
                                    return ref
                                                .watch(salonMessagesNotifier)
                                                .getMessages()[index]
                                                .sender ==
                                            FirebaseAuth
                                                .instance
                                                .currentUser
                                                ?.uid
                                        ? const SizedBox()
                                        : Column(
                                            children: [
                                              useSticker
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                  minWidth:
                                                                      95.w,
                                                                  minHeight:
                                                                      34.h,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        0,
                                                                      ),
                                                                  color: Colors
                                                                      .black
                                                                      .withValues(
                                                                        alpha:
                                                                            0.10,
                                                                      ),
                                                                  blurRadius:
                                                                      35,
                                                                ),
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9,
                                                                  ),
                                                              color:
                                                                  const Color(
                                                                    0XFFF6F6F6,
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                stickerDate(
                                                                  ref
                                                                      .watch(
                                                                        salonMessagesNotifier,
                                                                      )
                                                                      .getMessages()[index]
                                                                      .createdAt,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              LockedMessage(
                                                messageModel: ref
                                                    .watch(
                                                      salonMessagesNotifier,
                                                    )
                                                    .getMessages()[index],
                                              ),
                                            ],
                                          );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (ref.watch(messageFirestoreRiver).currentSalon?.type ==
                    SalonType.oneToOne)
                  Positioned(
                    bottom: 13.h,
                    left: 14.h,
                    child: Stack(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          overlayColor: WidgetStateProperty.resolveWith(
                            (states) => Colors.transparent,
                          ),
                          onTap:
                              (ref
                                      .watch(messageFirestoreRiver)
                                      .currentSalon
                                      ?.lock ==
                                  salon.LockState.sended)
                              ? null
                              : () async {
                                  if ((ref
                                                  .watch(
                                                    userChangeNotifierProvider,
                                                  )
                                                  .userData!
                                              as FiestarUserModel)
                                          .duo !=
                                      null) {
                                    await AlertBox.show(
                                      context: context,
                                      title: "app.end-duo".tr(),
                                      message:
                                          "Souhaites-tu mettre fin au Lock Duo ?",
                                      actions: [
                                        (context) => CTA.primary(
                                          textButton: "Mettre fin au Lock Duo",
                                          themeName: "red_button",
                                          width: formatWidth(207),
                                          textButtonStyle: AppTextStyle.white(
                                            14,
                                            FontWeight.w600,
                                          ),
                                          onTap: () async {
                                            await FriendController.stopLockDuo(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                              (ref
                                                          .read(
                                                            userChangeNotifierProvider,
                                                          )
                                                          .userData!
                                                      as FiestarUserModel)
                                                  .duo!
                                                  .id!,
                                            );
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        (context) => sh(15),
                                        (context) => InkWell(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            "Plus tard",
                                            style: AppTextStyle.mainColor(
                                              14,
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    await AlertBox.show(
                                      context: context,
                                      title: "Lock Duo",
                                      message:
                                          "Souhaites-tu proposer un Lock Duo ?",
                                      actions: [
                                        (context) => CTA.primary(
                                          textButton: "Proposer un Lock Duo",
                                          width: formatWidth(207),
                                          textButtonStyle: AppTextStyle.white(
                                            14,
                                            FontWeight.w600,
                                          ),
                                          onTap: () async {
                                            String otherUserId = ref
                                                .read(messageFirestoreRiver)
                                                .participant
                                                .keys
                                                .firstWhere(
                                                  (user) =>
                                                      user !=
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                );
                                            await FriendController.requestNewLockDuo(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                              otherUserId,
                                              ref
                                                  .read(messageFirestoreRiver)
                                                  .idSalon!,
                                            );
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        (context) => sh(15),
                                        (context) => InkWell(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            "Plus tard",
                                            style: AppTextStyle.mainColor(
                                              14,
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.h),
                            child: SvgPicture.asset(
                              (ref.watch(userChangeNotifierProvider).userData!
                                              as FiestarUserModel)
                                          .duo !=
                                      null
                                  ? "assets/svg/ic_lock.svg"
                                  : "assets/svg/ic_unlock.svg",
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 34.h,
                          height: 34.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0XFFF9A205), Color(0XFFFF6D01)],
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        if (ref
                                .watch(messageFirestoreRiver)
                                .currentSalon
                                ?.lock ==
                            salon.LockState.sended)
                          Container(
                            width: 34.h,
                            height: 34.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    Widget? bloqued;
    if (ref.watch(messageFirestoreRiver).currentSalon?.type ==
        SalonType.oneToOne) {
      if (ref
              .watch(messageFirestoreRiver)
              .currentSalon
              ?.bloquedUser
              ?.isNotEmpty ??
          false) {
        if (ref
                .watch(messageFirestoreRiver)
                .currentSalon
                ?.bloquedUser
                ?.any(
                  (element) =>
                      element != ref.watch(meModelChangeNotifier).myUid,
                ) ??
            false) {
          bloqued = Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.r),
                topRight: Radius.circular(35.r),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ],
              color: Colors.white,
            ),
            child: Center(child: Text("chat.you-blocked".tr())),
          );
        } else {
          bloqued = Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.r),
                topRight: Radius.circular(35.r),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ],
              color: Colors.white,
            ),
            child: Center(child: Text("chat.blocked-you".tr())),
          );
        }
      }
    } else {
      if (ref
              .watch(messageFirestoreRiver)
              .currentSalon
              ?.bloquedUser
              ?.contains(ref.watch(meModelChangeNotifier).myUid) ??
          false) {
        bloqued = Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.r),
              topRight: Radius.circular(35.r),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                offset: const Offset(0, -10),
                color: Colors.black.withValues(alpha: 0.04),
              ),
            ],
            color: Colors.white,
          ),
          child: Center(child: Text("chat.admin-blocked".tr())),
        );
      }
    }

    return bloqued ??
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ref.watch(salonMessagesNotifier).repliedMessage != null
                        ? RepliedWidget()
                        : const SizedBox(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.r),
                          topRight: Radius.circular(35.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            offset: const Offset(0, -10),
                            color: Colors.black.withValues(alpha: 0.04),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      ref
                                              .watch(salonMessagesNotifier)
                                              .bottomBarState ==
                                          BottomBarState.normal
                                      ? inputText(
                                          context,
                                          ref,
                                          _controller,
                                          scrollController: scrollController,
                                          onBlurred: () {
                                            if (isKeyboardVisible) {
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                          emojiVisible: false,
                                          refreshState: () => setState(() {}),
                                          isKeyboardVisible: isKeyboardVisible,
                                          focusNode: focusNode,
                                          clickEmoji: () {},
                                        )
                                      : ref
                                                .watch(salonMessagesNotifier)
                                                .bottomBarState ==
                                            BottomBarState.locked
                                      ? lockedScreen(
                                          ref,
                                          stopRecording: () async {
                                            ref
                                                .read(salonMessagesNotifier)
                                                .setBottomBarState(
                                                  BottomBarState.normal,
                                                );
                                            ref
                                                .read(animationController)
                                                .reset();
                                          },
                                        )
                                      : const SizedBox(),
                                ),
                                SizedBox(width: 10.w),
                                (_controller.text.isNotEmpty ||
                                        ref
                                                .watch(salonMessagesNotifier)
                                                .bottomBarState ==
                                            BottomBarState.locked)
                                    ? sendButton()
                                    : const SizedBox(),
                              ],
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  bottom: 25.h,
                  child:
                      ref.watch(salonMessagesNotifier).bottomBarState ==
                          BottomBarState.locked
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const WhatsAppMicAnimation(),
                            const Text(""),
                          ],
                        )
                      : const SizedBox(),
                ),
                ref.watch(salonMessagesNotifier).bottomBarState !=
                        BottomBarState.normal
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          width: 70,
                          height: 40.h,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(),
                ref.watch(salonMessagesNotifier).bottomBarState ==
                        BottomBarState.normal
                    ? Positioned(
                        right: 25.w,
                        bottom: 50,
                        child: Transform.translate(
                          offset: const Offset(0, -100),
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.black12,
                              direction: ShimmerDirection.btt,
                              highlightColor: Colors.white,
                              child: SvgPicture.asset(
                                "assets/svg/lock.svg",
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        );
  }

  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------Send Button-----------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  Widget _buildChatHeader() {
    final salonModel = ref.watch(messageFirestoreRiver).currentSalon;

    if (salonModel == null || salonModel.users.length < 2) {
      return Center(
        child: Text('chat.header'.tr(), style: const TextStyle(fontSize: 16)),
      );
    }

    // Récupérer l'ID de l'utilisateur distant (celui qui n'est pas l'utilisateur actuel)
    final otherUserId = salonModel.users.firstWhere(
      (userId) => userId != widget.meId,
      orElse: () => salonModel.users.first,
    );

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(otherUserId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data()!;
          final firstname = userData['firstname'] ?? '';
          final lastname = userData['lastname'] ?? '';
          final profilImage = userData['profilImage'];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                // Flèche de retour à gauche
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 8.w),
                // Contenu centré
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: profilImage != null
                            ? CachedNetworkImageProvider(profilImage)
                            : null,
                        child: profilImage == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        firstname.isNotEmpty && lastname.isNotEmpty
                            ? '$firstname ${lastname[0].toUpperCase()}'
                            : '$firstname $lastname'.trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Espace pour équilibrer avec la flèche de retour
                SizedBox(width: 32.w),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'chat.header'.tr(),
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        // Loading state
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              // Flèche de retour à gauche
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 8.w),
              // Contenu centré
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      height: 16.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
              // Espace pour équilibrer avec la flèche de retour
              SizedBox(width: 32.w),
            ],
          ),
        );
      },
    );
  }

  //--------------------------------------------------------------------------------------------------------------------------
  Widget sendButton() => InkWell(
    onTap: () async {
      String content = _controller.text;
      if (_controller.text.trim().isNotEmpty) {
        _controller.clear();
        setState(() {});

        FirestoreQuery.addMessage(
          MessageModel(
            sender: widget.meId,
            replyTo: ref.read(salonMessagesNotifier).repliedMessage,
            createdAt: DateTime.now(),
            type: MessageContentType.textMessage,
            message: content,
          ),
          salonId: widget.salonId,
        );
        ref.read(salonMessagesNotifier).setRepliedMessage(null);
      } else {
        _controller.clear();
      }
    },
    child: Padding(
      padding: EdgeInsets.all(10.0.w),
      child: SizedBox(
        height: 20.h,
        child: SvgPicture.asset(
          "assets/svg/send.svg",
          fit: BoxFit.contain,
          width: 25.w,
          height: 25.h,
        ),
      ),
    ),
  );
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------Record Mic-------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------
}

class AllwaysScrollableFixedPositionScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const AllwaysScrollableFixedPositionScrollPhysics({super.parent});

  @override
  AllwaysScrollableFixedPositionScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AllwaysScrollableFixedPositionScrollPhysics(
      parent: buildParent(ancestor),
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (newPosition.extentBefore == 0) {
      return super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity,
      );
    }
    return newPosition.maxScrollExtent - oldPosition.extentAfter;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}
