// ignore_for_file: override_on_non_overriding_member

import 'dart:async';
import 'dart:io';

import 'package:twogather/chat/chatColor.dart';
import 'package:twogather/chat/chatStyle.dart';
import 'package:twogather/chat/mediaViewer/viewer.dart';
import 'package:twogather/chat/riverpods/salon_river.dart';
import 'package:twogather/chat/riverpods/selected_assets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:uuid/uuid.dart';
import 'media_permissions.dart';

var uuid = const Uuid();

Future<void> mediaPick(BuildContext context, WidgetRef ref) async {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Que souhaitez-vous faire ?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Caméra', style: TextStyle(color: Colors.blue)),
            onTap: () async {
              if (!context.mounted) return;
              Navigator.pop(context);
              // Vérifier les permissions de caméra avant d'ouvrir
              final cameraStatus = await Permission.camera.status;
              if (cameraStatus.isDenied) {
                debugPrint("[MediaPick] Permission caméra refusée, demande...");
                final result = await Permission.camera.request();
                if (result.isDenied) {
                  if (context.mounted) {
                    showPermissionDeniedDialog(context, 'caméra');
                  }
                  return;
                }
              } else {
                debugPrint("[MediaPick] Permission caméra déjà accordée");
              }
              if (context.mounted) {
                final AssetEntity? entity = await pickCamera(context, ref);
                if (entity != null && context.mounted) {
                  debugPrint(
                    "[MediaPick] Navigation vers MediaViewer après capture",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaViewer(
                        salonModel: ref
                            .read(messageFirestoreRiver)
                            .currentSalon!,
                      ),
                    ),
                  );
                }
              }
            },
          ),
          ListTile(
            title: const Text('Galerie'),
            onTap: () async {
              if (!context.mounted) return;
              Navigator.pop(context);
              // Vérifier les permissions de stockage avant d'ouvrir
              final storageStatus = await Permission.storage.status;
              if (storageStatus.isDenied) {
                debugPrint(
                  "[MediaPick] Permission stockage refusée, demande...",
                );
                final result = await Permission.storage.request();
                if (result.isDenied) {
                  if (context.mounted) {
                    showPermissionDeniedDialog(context, 'galerie');
                  }
                  return;
                }
              } else {
                debugPrint("[MediaPick] Permission stockage déjà accordée");
              }

              // Pour Android 13+, vérifier aussi les nouvelles permissions
              if (Platform.isAndroid) {
                final photosStatus = await Permission.photos.status;
                if (photosStatus.isDenied) {
                  debugPrint(
                    "[MediaPick] Permission photos refusée, demande...",
                  );
                  final result = await Permission.photos.request();
                  if (result.isDenied) {
                    if (context.mounted) {
                      showPermissionDeniedDialog(context, 'photos');
                    }
                    return;
                  }
                } else {
                  debugPrint("[MediaPick] Permission photos déjà accordée");
                }
              }

              if (!context.mounted) return;

              final List<AssetEntity>? assets = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                  specialPickerType: SpecialPickerType.noPreview,
                  selectedAssets: ref
                      .read(selectedAssets)
                      .mapAssets
                      .values
                      .map((e) => e.assetEntity)
                      .toList(),
                  requestType: RequestType.common,
                  maxAssets: 10,
                  textDelegate: const FrenchAssetPickerTextDelegate(),
                ),
              );
              debugPrint(
                "[MediaPick] Assets sélectionnés: ${assets?.length ?? 0}",
              );
              ref.read(selectedAssets).setAssets(assets);
              if ((assets?.length ?? 0) > 0) {
                if (!context.mounted) return;
                debugPrint("[MediaPick] Navigation vers MediaViewer");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaViewer(
                      salonModel: ref.read(messageFirestoreRiver).currentSalon!,
                    ),
                  ),
                );
              } else {
                debugPrint("[MediaPick] Aucun asset sélectionné");
              }
            },
          ),
          ListTile(
            title: const Text('Fermer', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}

Future<AssetEntity?> pickCamera(BuildContext context, WidgetRef ref) async {
  try {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        textDelegate: FrenchCameraPickerTextDelegateC(),
        enableRecording: true,
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.white),
          primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
          textTheme: Typography(platform: TargetPlatform.iOS).white,
          primaryColor: Colors.blue,
        ),
        maximumRecordingDuration: const Duration(minutes: 2),
      ),
    );

    if (entity != null) {
      debugPrint("[PickCamera] Asset capturé: ${entity.type}");
      ref.read(selectedAssets).setAssets([entity]);
    } else {
      debugPrint("[PickCamera] Aucun asset capturé");
    }

    return entity;
  } catch (e) {
    rethrow;
  }
}

Widget inputText(
  BuildContext context,
  WidgetRef ref,
  TextEditingController controller, {
  required VoidCallback clickEmoji,
  required bool emojiVisible,
  required bool isKeyboardVisible,
  required Function onBlurred,
  required ScrollController scrollController,
  required VoidCallback refreshState,
  required FocusNode focusNode,
}) => Row(
  children: [
    Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        radius: const Radius.circular(100),
        child: TextField(
          scrollController: scrollController,
          focusNode: focusNode,

          controller: controller,
          onChanged: (value) {
            refreshState();
          },
          autofocus: false,
          maxLines: 5,
          minLines: 1,
          // controller: _commentController,
          textInputAction: TextInputAction.newline,
          style: ChatStyle.messageInputTextStyle,
          decoration: InputDecoration(
            hintText: 'Message...',
            isDense: true,
            hintStyle: ChatStyle.messageInputHintStyle,
            filled: true,
            fillColor: ChatColor.bottom_input_background_color,
            suffixIcon: ref.read(salonMessagesNotifier).repliedMessage == null
                ? InkWell(
                    onTap: () async {
                      ref.read(selectedAssets).setAssets([]);
                      mediaPick(context, ref);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: SizedBox(
                        height: 20.h,
                        child: SvgPicture.asset(
                          "assets/svg/gallery.svg",
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ChatColor.bottom_input_icon_color,
                            BlendMode.srcIn,
                          ),
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            enabledBorder: ChatStyle.messageInputBorderStyle,
            focusedBorder: ChatStyle.messageInputBorderStyle,
            border: ChatStyle.messageInputBorderStyle,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        ),
      ),
    ),
  ],
);

//---------------------------------ADDED TO HANDLE FRENCH--------------------------//

class FrenchCameraPickerTextDelegate extends CameraPickerTextDelegate {
  @override
  String get confirm => 'Confirmez';

  @override
  String get shootingTips => 'Cliquez pour prendre une photo';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get sActionManuallyFocusHint => 'manually focus';

  @override
  String get sActionPreviewHint => 'preview';

  @override
  String get sActionRecordHint => 'record';

  @override
  String get sActionShootHint => 'take picture';

  @override
  String get sActionShootingButtonTooltip => 'shooting button';

  @override
  String get sActionStopRecordingHint => 'stop recording';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return '${sCameraLensDirectionLabel(value)} camera preview';
  }

  @override
  String sFlashModeLabel(FlashMode mode) => 'Flash mode: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Switch to the ${sCameraLensDirectionLabel(value)} camera';
}

class FrenchCameraPickerTextDelegateC extends CameraPickerTextDelegate {
  @override
  String get confirm => 'Confirmez';

  @override
  String get shootingWithRecordingTips => 'Cliquez pour prendre une photo';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get sActionManuallyFocusHint => 'manually focus';

  @override
  String get sActionPreviewHint => 'preview';

  @override
  String get sActionRecordHint => 'record';

  @override
  String get sActionShootHint => 'take picture';

  @override
  String get sActionShootingButtonTooltip => 'shooting button';

  @override
  String get sActionStopRecordingHint => 'stop recording';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return '${sCameraLensDirectionLabel(value)} camera preview';
  }

  @override
  String sFlashModeLabel(FlashMode mode) => 'Flash mode: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Switch to the ${sCameraLensDirectionLabel(value)} camera';
}
