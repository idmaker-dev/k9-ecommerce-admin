import 'package:cwt_ecommerce_admin_panel/features/personalization/models/bank_account_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/coupon_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';
import 'package:flutter/material.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  Rx<Coupon> coupon = Coupon.empty().obs;
  Rx<UserModel> userCoupon = UserModel.empty().obs;
  Rx<BankAccountModel> bankAccount = BankAccountModel.empty().obs;

  /// -- Load customer orders
  Future<void> getCustomerOfCurrentOrder() async {
    try {
      // Show loader while loading categories
      loading.value = true;
      // Fetch customer orders & addresses
      final user =
          await UserRepository.instance.fetchUserDetails(order.value.userId);

      customer.value = user;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  /// -- Load coupon of current order
  Future<void> getCouponOfCurrentOrder() async {
    try {
      // Show loader while loading categories
      loading.value = true;
      // Fetch customer orders & addresses
      final result = await UserRepository.instance
          .fetchCouponByOrderId(order.value.userCouponId!, order.value.id);

      coupon.value = result;

      if (coupon.value.bonusDeliveredType == 2) {
        // Fetch bank account of user coupon

        final bankAccountResult = await UserRepository.instance
            .fetchBankAccount(order.value.userCouponId!);

        if (bankAccountResult != null) {
          bankAccount.value = bankAccountResult;
        } else {
          bankAccount.value = BankAccountModel.empty();
        }
      } else {
        bankAccount.value = BankAccountModel.empty();
      }
    } catch (e) {
      print(e.toString());
      // TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  /// -- Load user of coupon
  Future<void> getUserOfCoupon() async {
    try {
      // Show loader while loading categories
      loading.value = true;
      // Fetch customer orders & addresses
      final result = await UserRepository.instance
          .fetUserCouponDetails(order.value.userCouponId!);

      userCoupon.value = result;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  String getCouponStatus(int status) {
    switch (status) {
      case 0:
        return 'Pendiente';
      case 1:
        return 'En cartera';
      case 2:
        return 'Solicitud a cuenta';
      case 3:
        return 'En cuenta';
      default:
        return 'Desconocido';
    }
  }

  confirmTransaction() {
    //show modal to confirm transaction
    //if yes, call the api to confirm transaction
    //if no, close the modal
    Get.defaultDialog(
      title: 'Confirmar transacción',
      content:
          const Text('¿Está seguro de que desea confirmar esta transacción?'),
      onConfirm: () async {
        try {
          Get.back();
          // Show loader while loading categories
          loading.value = true;
          // Fetch customer orders & addresses
          await UserRepository.instance.setBonusDelivery(
              userCoupon.value.id!, coupon.value.documentId, 3);
          TLoaders.successSnackBar(
              title: 'Éxito', message: 'Transacción confirmada');
          getCouponOfCurrentOrder();
          // cerrar el modal
        } catch (e) {
          TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        } finally {
          loading.value = false;
        }
      },
    );
  }
}
