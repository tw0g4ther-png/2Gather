import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:twogather/widgets/search_bar/theme/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final CustomSearchBarThemeData theme;
  final String hint;
  final IconData icons;
  final Function(String)? onSearch;
  final Function(String)? onSearchChanged;
  final List<String> options;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.options,
    this.theme = const CustomSearchBarThemeData(),
    this.hint = "Rechercher..",
    this.icons = Icons.search,
    this.onSearch,
    this.onSearchChanged,
    this.controller,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: widget.theme.constraints,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
        color: widget.theme.backgroundColor,
      ),
      child: Center(
        child: TypeAheadField<String>(
          onSelected: (option) {
            if (widget.controller != null) {
              widget.controller!.text = option;
            } else {
              _controller.text = option;
            }
            if (widget.onSearch != null) widget.onSearch!(option);
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                if (widget.onSearchChanged != null) {
                  widget.onSearchChanged!(value);
                }
              },
              style: DefaultTextStyle.of(
                context,
              ).style.copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                hintMaxLines: 1,
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintStyle: widget.theme.hintStyle,
                hintText: widget.hint,
                prefixIcon: Icon(
                  widget.icons,
                  color: widget.theme.iconColor,
                  size: 24,
                ),
              ),
            );
          },
          suggestionsCallback: (pattern) async {
            return widget.options
                .where(
                  (element) =>
                      element.toLowerCase().contains(pattern.toLowerCase()),
                )
                .toList();
          },
          itemBuilder: (context, suggestion) {
            return Container(
              constraints: widget.theme.constraints,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(children: [Text(suggestion)]),
            );
          },
          errorBuilder: (_, item) {
            return const SizedBox();
          },
          hideOnEmpty: true,
        ),
      ),
    );
  }
}
