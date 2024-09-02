import 'package:flutter/material.dart';

class StateLoading extends StatelessWidget {
  const StateLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: Container(
        color: colorScheme.surface.withOpacity(0.7),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
