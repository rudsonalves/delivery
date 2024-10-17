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

import '../../stores/common/store_func.dart';

class AddressCard extends StatelessWidget {
  final ZipStatus zipStatus;
  final String? addressString;

  const AddressCard({
    super.key,
    required this.zipStatus,
    this.addressString,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (zipStatus == ZipStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (zipStatus == ZipStatus.error) {
      return Card(
        color: colorScheme.tertiaryContainer,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 64,
            vertical: 12,
          ),
          child: Text('Endereço inválido'),
        ),
      );
    } else if (zipStatus == ZipStatus.success) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(addressString ?? '- * -'),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
