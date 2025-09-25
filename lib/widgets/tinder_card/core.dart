import 'dart:ui';

import 'package:core_kosmos/core_kosmos.dart';
import 'package:twogather/widgets/tinder_card/theme.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatefulWidget {
  final String? title;
  final String? image;

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  final TinderCardThemeData? theme;
  final String? themeName;

  const TinderCard({
    super.key,

    /// Card data
    this.title,
    this.image,

    /// Theme field
    this.height,
    this.width,
    this.borderRadius,

    /// Custom Theme
    this.theme,
    this.themeName,
  });

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeData = loadThemeData(
      widget.theme,
      widget.themeName ?? "tinder_card",
      () => const TinderCardThemeData(),
    )!;

    return Container(
      width:
          widget.width ?? themeData.width ?? MediaQuery.of(context).size.width,
      height:
          widget.height ??
          themeData.height ??
          MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius:
            widget.borderRadius ??
            themeData.borderRadius ??
            BorderRadius.circular(0),
        image: widget.image != null
            ? DecorationImage(
                image: AssetImage(widget.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width:
                  widget.width ??
                  themeData.width ??
                  MediaQuery.of(context).size.width,
              height: formatHeight(200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black.withValues(alpha: 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () =>
                          printInDebug("Widget [TinderCard] button refuse"),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(formatWidth(80)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: formatWidth(80),
                            height: formatWidth(80),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: .35),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: formatWidth(40),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    sw(10),
                    InkWell(
                      onTap: () =>
                          printInDebug("Widget [TinderCard] button magnet"),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(formatWidth(80)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: formatWidth(80),
                            height: formatWidth(80),
                            color: Colors.redAccent,
                            child: Center(
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: formatWidth(40),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sh(80),
            ],
          ),
        ],
      ),
    );
  }
}
