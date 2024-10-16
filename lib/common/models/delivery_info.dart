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
