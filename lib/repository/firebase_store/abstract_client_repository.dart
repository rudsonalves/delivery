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
  Stream<List<ClientModel>> streamClientByName();
}
