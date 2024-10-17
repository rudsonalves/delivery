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
