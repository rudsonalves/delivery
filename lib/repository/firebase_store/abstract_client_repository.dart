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
import '../../common/models/client.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractClientRepository {
  Future<DataResult<ClientModel>> add(ClientModel client);
  Future<DataResult<ClientModel>> update(ClientModel client);
  Future<DataResult<void>> delete(String clientId);
  Future<DataResult<ClientModel?>> get(String clientId);
  Future<List<AddressModel>?> getAddressesForClient(String clientId);
  Future<DataResult<List<ClientModel>>> getClientsByName(String name);
  Stream<List<ClientModel>> streamAllClients();
  Future<DataResult<List<ClientModel>>> getClientsByPhone(String phone);
}
