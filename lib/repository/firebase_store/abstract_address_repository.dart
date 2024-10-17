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

import '../../common/models/address.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractAddressClientRepository {
  Future<DataResult<AddressModel>> add(AddressModel address);
  Future<DataResult<AddressModel>> update(AddressModel address);
  Future<DataResult<void>> delete(String addressId);
  Future<DataResult<AddressModel?>> get(String addressId);
}
