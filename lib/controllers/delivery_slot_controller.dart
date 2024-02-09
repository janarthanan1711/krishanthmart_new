import 'package:get/get.dart';
import 'package:krishanthmart_new/repositories/payment_repositories.dart';

import '../models/delivery_slot_model.dart';

class DeliverySlotController extends GetxController{

  var deliveryTimeSlot = <TimeDelivery>[].obs;
  var deliveryIndex = 0.obs;
  var deliveryData = ''.obs;

  @override
  void onInit(){
    getDeliveryTimeSlot();
    super.onInit();
  }
  @override
  void onRemove(){
    deliveryTimeSlot.clear();
  }


  getDeliveryTimeSlot() async {
    var timeSlotResponse = await PaymentRepository().deliverySlotRepository();
    // deliveryTimeSlot.add(timeSlotResponse.data);
    deliveryTimeSlot.assignAll(timeSlotResponse);
  }
  storeValuestoApi(index){
    deliveryData.value = deliveryTimeSlot[index].transitTime!;
    deliveryIndex.value = index;
  }
}