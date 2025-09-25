import 'package:flutter/material.dart';

class PermissionsPageViewCustom extends StatefulWidget {
  const PermissionsPageViewCustom({
    super.key,
    required this.pages,
    required this.pageController,
    this.backgroundColor = Colors.white,
  });

  final List<Widget> pages;
  final PageController pageController;
  final Color backgroundColor;

  @override
  State<PermissionsPageViewCustom> createState() =>
      _PermissionsPageViewCustomState();
}

class _PermissionsPageViewCustomState extends State<PermissionsPageViewCustom> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: widget.pageController,
          children: widget.pages,
        ),
      ),
    );
  }
}
