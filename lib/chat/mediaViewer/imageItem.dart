import 'dart:io';
import 'dart:math';
import '../freezed/assetItem/itemOfassets.dart';
import '../riverpods/selected_assets.dart';
import '../utils/loader_ios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';
import 'package:painter/painter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImageItem extends ConsumerStatefulWidget {
  final ItemOfAssets asset;
  final VoidCallback clearAsset;
  final int index;
  const ImageItem({
    super.key,
    required this.asset,
    required this.clearAsset,
    required this.index,
  });
  @override
  ConsumerState<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends ConsumerState<ImageItem> {
  bool showColorPicker = false;
  late PainterController _controller;
  void setController({Color? color = Colors.blue}) {
    _controller = PainterController();
    _controller.thickness = 3.5;
    _controller.backgroundColor = Colors.transparent;
    _controller.drawColor = color!;

    _controller.addListener(() {});
  }

  @override
  void initState() {
    super.initState();
    setController();
  }

  @override
  void dispose() {
    debugPrint("DISPOSEDDDDD");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: _imageFileBuilder(widget.asset.assetEntity),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ).copyWith(top: 40.h),
          child: Row(
            children: [
              const Spacer(),
              showColorPicker
                  ? AnimatedContainer(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      curve: Curves.easeInCubic,
                      duration: const Duration(milliseconds: 500),
                      width: 40,
                      height: 40,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () => {
                          if (!_controller.isEmpty) _controller.undo(),
                        },
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.undo,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: 10),
              showColorPicker
                  ? AnimatedContainer(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      curve: Curves.easeInCubic,
                      duration: const Duration(milliseconds: 500),
                      width: 40,
                      height: 40,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () => {_controller.clear()},
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: 10),
              AnimatedContainer(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                curve: Curves.easeInCubic,
                duration: const Duration(milliseconds: 500),
                width: 40,
                height: 40,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: widget.clearAsset,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.palette, color: Colors.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: showColorPicker ? Colors.blue : null,
                ),
                curve: Curves.easeInCubic,
                duration: const Duration(milliseconds: 500),
                width: 40,
                height: 40,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: () async {
                    setState(() {
                      showColorPicker = !showColorPicker;
                    });

                    ref.read(selectedAssets).setPainter(showColorPicker);
                  },
                  child: const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          top: 170.h,
          right: !showColorPicker ? -120 : -75.w,
          duration: const Duration(milliseconds: 200),
          child: Transform.rotate(
            angle: pi * 1 / 2,
            child: SizedBox(
              width: 30.w,
              height: 30.h,
              child: HuePicker(
                trackHeight: 10.0,
                initialColor: HSVColor.fromColor(Colors.blue),
                onChanged: (HSVColor color) {
                  setState(() {
                    _controller.drawColor = color.toColor();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageFileBuilder(AssetEntity e) {
    debugPrint("[ImageItem] Chargement de l'image: ${e.id}");
    return FutureBuilder(
      future: e.file,
      builder: (context, AsyncSnapshot<File?> snapshot) {
        debugPrint(
          "[ImageItem] FutureBuilder - hasData: ${snapshot.hasData}, data: ${snapshot.data?.path}",
        );
        if (snapshot.hasData && snapshot.data != null) {
          debugPrint(
            "[ImageItem] Affichage de l'image: ${snapshot.data!.path}",
          );
          return RepaintBoundary(
            key: widget.asset.globalKey,
            child: Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    child: Image.file(
                      snapshot.data!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          "[ImageItem] Erreur d'affichage de l'image: $error",
                        );
                        return const Center(
                          child: Text(
                            'Erreur de chargement de l\'image',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                AbsorbPointer(
                  absorbing: !showColorPicker,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.h),
                    child: Center(child: Painter(_controller)),
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          debugPrint(
            "[ImageItem] Erreur lors du chargement: ${snapshot.error}",
          );
          return const Center(
            child: Text(
              'Erreur de chargement',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        debugPrint("[ImageItem] Affichage du loader");
        return const Center(child: LoaderClassique());
      },
    );
  }
}
