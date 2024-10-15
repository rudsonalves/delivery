import 'package:delivery/components/widgets/custom_app_bar/custom_app_bar_controller.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.bottom,
    this.elevation,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  final ctrl = CustomAppBarController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title,
      elevation: widget.elevation,
      centerTitle: widget.centerTitle,
      actions: [
        if (widget.actions != null) ...widget.actions!,
        ValueListenableBuilder(
          valueListenable: ctrl.app.brightnessNotifier,
          builder: (context, value, _) => IconButton(
            isSelected: value == Brightness.dark,
            onPressed: ctrl.app.toogleBrightness,
            icon: const Icon(Icons.light_mode),
            selectedIcon: const Icon(Icons.dark_mode),
          ),
        ),
      ],
      bottom: widget.bottom,
    );
  }
}
