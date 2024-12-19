import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:cwt_ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/banners/banners_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/banner_model.dart';
import 'banner_controller.dart';

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final RxString targetScreen = AppScreens.allAppScreenItems[0].obs;
  final formKey = GlobalKey<FormState>();

  /// Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;
      // Update the main image using the selectedImage
      imageURL.value = selectedImage.url;
    }
  }

  /// Register new Banner
  Future<void> createBanner() async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Map Data
      final newRecord = BannerModel(
        id: '',
        active: isActive.value,
        imageUrl: imageURL.value,
        targetScreen: targetScreen.value,
      );

      // Call Repository to Create New Banner and update Id
      newRecord.id = await BannerRepository.instance.createBanner(newRecord);

      // Update All Data list
      BannerController.instance.addItemToLists(newRecord);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      TLoaders.successSnackBar(title: 'Felicidades', message: 'El nuevo registro ha sido agergado');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Algo salio mal', message: e.toString());
    }
  }
}
