import 'package:flutter/material.dart';

import '../../common/models/address.dart';
import '../../stores/pages/common/store_func.dart';

class AddressCard extends StatelessWidget {
  final ZipStatus zipStatus;
  final AddressModel? address;

  const AddressCard({
    super.key,
    required this.zipStatus,
    this.address,
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
            child: Text((address != null) ? address!.addressString() : '- * -'),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
