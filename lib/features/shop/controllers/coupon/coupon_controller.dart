import 'package:cwt_ecommerce_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:cwt_ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/coupon_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CouponController extends TBaseController<Coupon> {
  static CouponController get instance => Get.find();

  final _userRepository = Get.put(UserRepository());
  final _customerRepository = Get.put(UserRepository());

  RxList<UserModel> users = <UserModel>[].obs;
  Rxn<UserModel> selectedUser = Rxn<UserModel>();
  RxList<Coupon> couponStats = <Coupon>[].obs;
  final RxBool loading = false.obs;

  Future<void> fetchItemsV2() async {
    final userList = await _customerRepository.getAllUsers();
    if (users.isEmpty) {
      users.assignAll(userList);
    }
  }

  Future<void> fetchCouponsByUser(String userId) async {
    print('fetchOrdersMyCoupon $userId');
    couponStats.value = [];

    if (userId.isEmpty) {
      loading.value = false;
      couponStats.refresh();
      return;
    }

    loading.value = true;
    try {
      var couponStatsResult =
          await _userRepository.fetchAllCouponByUser(userId);

      print('couponStatsResult $couponStatsResult');

      couponStats.assignAll(couponStatsResult);
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Error', message: 'No se pudieron cargar los datos: $e');
    } finally {
      loading.value = false;
      couponStats.refresh();
    }
  }

  limpiarUser() {
    selectedUser.value = null;
    fetchCouponsByUser('');
  }

  @override
  Future<List<Coupon>> fetchItems() async {
    sortAscending.value = false;
    return await _userRepository.fetchAllCoupons();
  }

  @override
  Future<void> deleteItem(Coupon item) async {
    ;
  }

  @override
  bool containsSearchQuery(Coupon item, String query) {
    return false;
  }
}
