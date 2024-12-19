import 'package:cwt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  /// -- Load customer orders
  Future<void> getCustomerOfCurrentOrder() async {
    try {
      // Show loader while loading categories
      loading.value = true;
      // Fetch customer orders & addresses
      final user = await UserRepository.instance.fetchUserDetails(order.value.userId);

      customer.value = user;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }
}
