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

import 'delivery.dart';

class DeliveryInfoModel {
  String id;
  bool selected;
  String clientId;
  String clientName;
  String clientPhone;
  String clientAddress;

  DeliveryInfoModel({
    required this.id,
    this.selected = false,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.clientAddress,
  });

  @override
  String toString() {
    return 'DeliveryInfoModel(id: $id,'
        ' selected: $selected,'
        ' clientId: $clientId,'
        ' clientName: $clientName,'
        ' clientPhone: $clientPhone,'
        ' shopAddress: $clientAddress)';
  }

  factory DeliveryInfoModel.fromDelivery(DeliveryModel delivery) {
    return DeliveryInfoModel(
      id: delivery.id!,
      clientId: delivery.clientId,
      clientName: delivery.clientName,
      clientPhone: delivery.clientPhone,
      clientAddress: delivery.clientAddress,
    );
  }
}
