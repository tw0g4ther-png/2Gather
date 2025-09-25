import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';

class ImageListSwipe extends StatefulWidget {
  final List<String> images;
  final Size? size;
  final int activeImage;

  const ImageListSwipe({
    super.key,
    required this.images,
    this.size,
    this.activeImage = 0,
  });

  @override
  State<ImageListSwipe> createState() => ImageListSwipeState();
}

class ImageListSwipeState extends State<ImageListSwipe> {
  @override
  Widget build(BuildContext context) {
    // Vérifier si la liste d'images est vide ou si l'index actuel est invalide
    if (widget.images.isEmpty) {
      return Container(
        width: widget.size?.width ?? double.infinity,
        height: widget.size?.height ?? double.infinity,
        decoration: const BoxDecoration(color: Colors.grey),
        child: const Center(
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
      );
    }

    // S'assurer que l'index actuel est valide
    final safeActiveImage = widget.activeImage.clamp(
      0,
      widget.images.length - 1,
    );

    return Container(
      width: widget.size?.width ?? double.infinity,
      height: widget.size?.height ?? double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(widget.images[safeActiveImage]),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          sh(15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: formatWidth(19)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (int i = 0; i < widget.images.length; i++) ...[
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: safeActiveImage >= i
                            ? Colors.white
                            : Colors.white.withValues(alpha: .2),
                      ),
                    ),
                  ),
                  if (i < widget.images.length - 1) sw(7),
                ],
              ],
            ),
          ),
          sh(10),
        ],
      ),
    );
  }
}
