import 'package:cwt_ecommerce_admin_panel/data/repositories/categories/category_repository.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/category_model.dart';
import 'package:cwt_ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  /// Init Data
  void init(CategoryModel category) {
    if (category.parentId.isNotEmpty) {
      selectedParent.value = CategoryController.instance.allItems.where((c) => c.id == category.parentId).single;
    }
    name.text = category.name;
    isFeatured.value = category.isFeatured;
    imageURL.value = category.image;
  }

  /// Method to reset fields
  void resetFields() {
    selectedParent(CategoryModel.empty());
    loading(false);
    isFeatured(false);
    name.clear();
    imageURL.value = '';
  }

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

  /// Register new Category
  Future<void> updateCategory(CategoryModel category) async {
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
      category.image = imageURL.value;
      category.name = name.text.trim();
      category.parentId = selectedParent.value.id;
      category.isFeatured = isFeatured.value;
      category.updatedAt = DateTime.now();

      // Call Repository to Create New User
      await CategoryRepository.instance.updateCategory(category);

      // Update All Data list
      CategoryController.instance.updateItemFromLists(category);

      // Reset Form
      //resetFields();
      Get.back();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      TLoaders.successSnackBar(title: 'Felicidades', message: 'El registro ha sido actualizado.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
