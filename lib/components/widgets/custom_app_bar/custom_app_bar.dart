// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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
