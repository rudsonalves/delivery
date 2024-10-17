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

import 'package:intl/intl.dart';

extension NumberExtension on num {
  String formatMoney() {
    return NumberFormat('R\$ ###,##0.00', 'pt-BR').format(this);
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateFormat('dd/MM/yyy HH:mm', 'pt-BR').format(this);
  }
}

extension StringExtension on String {
  String onlyNumbers() {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}
