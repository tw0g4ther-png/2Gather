// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:core_kosmos/core_package.dart';
import 'package:twogather/widgets/multi_image_picker.dart/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePicker extends StatefulWidget {
  final int maxItem;

  final String? fieldName;
  final TextStyle? fieldNameStyle;
  final List<File>? initialValue;
  final List<String>? initialImageUrls; // URLs des images existantes
  final Function(String imageUrl)?
  onImageDeleted; // Callback pour la suppression

  /// Theme
  final Color? deleteButtonColor;
  final double? itemSpacing;
  final double? itemRunSpacing;
  final EdgeInsetsGeometry? imageBoxPadding;
  final BorderRadiusGeometry? imageBoxBorderRadius;
  final Color? imageBoxColor;
  final double? imageBoxWidth;
  final double? imageBoxHeight;

  final String? themeName;
  final MultiImagePickerThemeData? theme;

  const MultiImagePicker({
    super.key,
    this.maxItem = 8,
    this.themeName,
    this.theme,
    this.deleteButtonColor,
    this.itemRunSpacing,
    this.itemSpacing,
    this.imageBoxBorderRadius,
    this.imageBoxPadding,
    this.imageBoxColor,
    this.imageBoxHeight,
    this.imageBoxWidth,
    this.fieldName,
    this.fieldNameStyle,
    this.initialValue,
    this.initialImageUrls,
    this.onImageDeleted,
  });

  @override
  State<MultiImagePicker> createState() => MultiImagePickerState();
}

class MultiImagePickerState extends State<MultiImagePicker> {
  late final MultiImagePickerThemeData? _themeData;

  List<File> _images = [];
  List<String> _imageUrls = []; // URLs des images existantes

  @override
  void initState() {
    _themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "multi_image_picker",
      (() => const MultiImagePickerThemeData()),
    );
    _images = widget.initialValue ?? [];
    _imageUrls = widget.initialImageUrls ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.fieldName != null) ...[
          Text(
            widget.fieldName!,
            style:
                widget.fieldNameStyle ??
                const TextStyle(
                  color: Color(0xFF02132B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
          sh(12),
        ],
        Wrap(
          spacing:
              widget.itemSpacing ?? _themeData?.itemSpacing ?? formatWidth(25),
          runSpacing:
              widget.itemRunSpacing ??
              _themeData?.itemRunSpacing ??
              formatHeight(15),
          children: [
            for (int i = 0; i < widget.maxItem; i++) _buildImageBox(i),
          ],
        ),
      ],
    );
  }

  Widget _buildImageBox(int index) {
    final File? image = index < _images.length ? _images[index] : null;

    return InkWell(
      onTap: () async {
        if (image == null) {
          final image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
          if (image != null) {
            setState(() {
              _images.add(File(image.path));
            });
          }
        }
      },
      child: Container(
        width:
            widget.imageBoxWidth ??
            _themeData?.imageBoxWidth ??
            formatWidth(142),
        height:
            widget.imageBoxHeight ??
            _themeData?.imageBoxHeight ??
            formatHeight(183),
        padding:
            widget.imageBoxPadding ??
            _themeData?.imageBoxPadding ??
            EdgeInsets.all(formatWidth(6)),
        decoration: BoxDecoration(
          borderRadius:
              widget.imageBoxBorderRadius ??
              _themeData?.imageBoxBorderRadius ??
              BorderRadius.circular(formatWidth(7)),
          color:
              widget.imageBoxColor ??
              _themeData?.imageBoxColor ??
              const Color(0xFFF7F7F8),
        ),
        clipBehavior: Clip.none,
        child: image != null
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width:
                        widget.imageBoxWidth ??
                        _themeData?.imageBoxWidth ??
                        formatWidth(142),
                    height:
                        widget.imageBoxHeight ??
                        _themeData?.imageBoxHeight ??
                        formatHeight(183),
                    decoration: BoxDecoration(
                      borderRadius:
                          widget.imageBoxBorderRadius ??
                          _themeData?.imageBoxBorderRadius ??
                          BorderRadius.circular(formatWidth(7)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(image, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: -7,
                    right: -7,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerUp: (_) async {
                        // Si c'est une image existante (pas une nouvelle), supprimer de Storage
                        if (index < _imageUrls.length &&
                            _imageUrls[index].isNotEmpty) {
                          final imageUrl = _imageUrls[index];
                          // Appeler le callback pour supprimer de Firebase Storage
                          if (widget.onImageDeleted != null) {
                            await widget.onImageDeleted!(imageUrl);
                          }
                          // Supprimer l'URL de la liste locale
                          _imageUrls.removeAt(index);
                        }

                        setState(() {
                          _images.removeAt(index);
                        });
                      },
                      child: AbsorbPointer(
                        child: Container(
                          width: formatWidth(18),
                          height: formatWidth(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEB5353),
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(
                              formatWidth(20),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove_rounded,
                              color: Colors.white,
                              size: formatWidth(13),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Icon(
                  Icons.add_rounded,
                  color: const Color(0xFF9299A4),
                  size: formatWidth(30),
                ),
              ),
      ),
    );
  }

  List<File> getPickedImages() => _images;
}
