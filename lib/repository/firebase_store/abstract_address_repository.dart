import '../../common/models/address.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractAddressClientRepository {
  Future<DataResult<AddressModel>> add(AddressModel address);
  Future<DataResult<AddressModel>> update(AddressModel address);
  Future<DataResult<void>> delete(String addressId);
  Future<DataResult<AddressModel?>> get(String addressId);
}
