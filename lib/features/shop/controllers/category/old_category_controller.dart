import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/categories/category_repository.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/category_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final _categoryRepository = Get.put(CategoryRepository());
  RxBool isLoading = true.obs;
  RxList<CategoryModel> allItems = <CategoryModel>[].obs;
  RxList<CategoryModel> filteredItems = <CategoryModel>[].obs;

  // Sorting
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;

  // Select Rows
  RxList<bool> selectedRows = <bool>[].obs;

  // Search
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  /// Common method for fetching data.
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      List<CategoryModel> fetchedItems = [];
      if (allItems.isEmpty) {
        fetchedItems = await _categoryRepository.getAllCategories();
      }
      allItems.assignAll(fetchedItems); // Assign fetched items to the allItems list
      filteredItems.assignAll(allItems); // Initially, set filtered items to all items
      selectedRows.assignAll(List.generate(allItems.length, (index) => false)); // Initialize selected rows
    } catch (e) {
      // Handle error (to be implemented in subclasses)
    } finally {
      isLoading.value = false; // Set loading state to false, regardless of success or failure
    }
  }

  /// Common method for searching based on a query
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => item.name.toLowerCase().contains(query.toLowerCase())),
    );
  }

  /// Common method for sorting items by a property
  void sortByProperty(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    this.sortColumnIndex.value = sortColumnIndex;

    filteredItems.sort((a, b) {
      if (ascending) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      }
    });
  }

  /// Method for adding an item to the lists.
  void addItemToLists(CategoryModel item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
  }

  /// Method for updating an item in the lists.
  void updateItemFromLists(CategoryModel item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;
  }

  /// Method for removing an item from the lists.
  void removeItemFromLists(CategoryModel item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
  }

  /// Common method for confirming deletion and performing the deletion.
  Future<void> confirmAndDeleteItem(CategoryModel item) async {
    Get.defaultDialog(
      title: 'Eliminar',
      content: const Text('¿Estás seguro de que quieres eliminar este registro?'),
      confirm: SizedBox(
        width: 60,
        child: ElevatedButton(
          onPressed: () async {
            await deleteOnConfirm(item);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight / 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5)),
          ),
          child: const Text('Ok'),
        ),
      ),
      cancel: SizedBox(
        width: 80,
        child: OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight / 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5)),
          ),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  /// Method to be implemented by subclasses for handling confirmation before deleting an item.
  Future<void> deleteOnConfirm(CategoryModel item) async {
    try {
      // Remove the Confirmation Dialog
      TFullScreenLoader.stopLoading();

      // Start the loader
      TFullScreenLoader.popUpCircular();

      // Delete Firestore Data
      await _categoryRepository.deleteCategory(item.id);

      removeItemFromLists(item);

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Registro eliminado', message: 'El registro ha sido eliminado');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Algo salio mal', message: e.toString());
    }
  }
}
