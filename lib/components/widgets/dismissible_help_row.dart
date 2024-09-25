import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DismissibleHelpRow extends StatelessWidget {
  const DismissibleHelpRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Editar'),
              SizedBox(width: 8),
              Icon(Symbols.line_end_arrow_notch_sharp),
            ],
          ),
          Row(
            children: [
              Icon(Symbols.line_start_arrow_notch_sharp),
              SizedBox(width: 8),
              Text('Apagar'),
            ],
          )
        ],
      ),
    );
  }
}
