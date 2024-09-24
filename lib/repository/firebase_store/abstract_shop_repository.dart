import '../../common/models/address.dart';
import '../../common/models/shop.dart';
import '../../common/utils/data_result.dart';

abstract class AbstractShopRepository {
  Future<DataResult<ShopModel>> add(ShopModel shop);
  Future<DataResult<ShopModel>> update(ShopModel shop);
  Future<DataResult<void>> delete(String shopId);
  Future<DataResult<ShopModel?>> get(String shopId);
  Future<DataResult<List<AddressModel>>> getAddressesForShop(String shopId);
  Future<DataResult<List<ShopModel>>> getShopByName(String name);
  Future<DataResult<List<ShopModel>>> getShopByManager(String managerId);
  Stream<List<ShopModel>> streamShopByName();
}
