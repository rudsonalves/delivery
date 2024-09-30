import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../models/user.dart';

extension UserRoleExtensions on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.business:
        return 'Comerciante';
      case UserRole.delivery:
        return 'Entregador';
      case UserRole.manager:
        return 'Gerente';
    }
  }

  IconData get iconData {
    switch (this) {
      case UserRole.admin:
        return Symbols.admin_panel_settings_rounded;
      case UserRole.business:
        return Symbols.business;
      case UserRole.delivery:
        return Icons.delivery_dining_rounded;
      case UserRole.manager:
        return Symbols.manage_accounts_rounded;
    }
  }
}
