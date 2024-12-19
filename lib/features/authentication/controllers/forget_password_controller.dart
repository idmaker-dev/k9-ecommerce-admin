import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

/// Controller for handling forget password functionality
class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Text editing controller for email field
  final email = TextEditingController();

  /// Form key for forget password form
  final forgetPasswordFormKey = GlobalKey<FormState>();

  /// Sends a password reset email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);
      Get.offNamed(TRoutes.resetPassword, arguments: email.text.trim());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Resends a password reset email
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show success message
      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
