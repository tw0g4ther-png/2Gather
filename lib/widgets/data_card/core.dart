import 'package:flutter/material.dart';

class DataCardWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? widthImage;
  final double? heightImage;
  final BoxConstraints? constraints;
  final Widget? child;
  final Widget? image;
  final Widget? tag;

  const DataCardWidget({
    super.key,
    this.height,
    this.width,
    this.widthImage,
    this.heightImage,
    this.child,
    this.image,
    this.tag,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            clipBehavior: Clip.hardEdge,
            width: widthImage,
            height: heightImage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                image ?? Container(),
                if (tag != null) Positioned(top: 6, right: 7, child: tag!),
              ],
            ),
          ),
          child ?? Container(),
        ],
      ),
    );
  }
}
