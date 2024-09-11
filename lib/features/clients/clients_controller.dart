import '../../locator.dart';
import '../../repository/firebase_store/abstract_client_repository.dart';

class ClientsController {
  final clientRepository = locator<AbstractClientRepository>();

  void init() {}
}
