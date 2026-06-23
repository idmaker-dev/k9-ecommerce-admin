import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../data/repositories/product/product_repository.dart';
import '../../models/product_model.dart';
import '../../../personalization/controllers/user_controller.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: _MyProductsView(),
      tablet: _MyProductsView(),
      mobile: _MyProductsView(),
    );
  }
}

class _MyProductsView extends StatefulWidget {
  const _MyProductsView();

  @override
  State<_MyProductsView> createState() => _MyProductsViewState();
}

class _MyProductsViewState extends State<_MyProductsView> {
  final _repo = Get.put(ProductRepository());
  bool _loading = true;
  List<ProductModel> _products = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await _repo.getMyProducts();
      if (!mounted) return;
      setState(() {
        _products = rows;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mis productos', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await Get.to(() => const AddProductDialog());
                  await _load();
                },
                child: const Text('Agregar producto'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Expanded(
              child: _products.isEmpty
                  ? const Center(child: Text('No tienes productos. Crea uno para comenzar.'))
                  : ListView.separated(
                      itemCount: _products.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final product = _products[index];
                        return ListTile(
                          title: Text(product.title),
                          subtitle: Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 16),
                                  onPressed: () async {
                                    await Get.to(() => EditProductDialog(product: product));
                                    await _load();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Eliminar'),
                                        content: Text('¿Eliminar "${product.title}"?'),
                                        actions: [
                                          TextButton(onPressed: () => Get.back(result: false), child: const Text('No')),
                                          TextButton(onPressed: () => Get.back(result: true), child: const Text('Sí')),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await _repo.deleteMyProduct(product.id);
                                        await _load();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Producto eliminado')),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: $e')),
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _repo = Get.put(ProductRepository());
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rellena los campos requeridos')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final product = ProductModel(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        stock: 0,
        thumbnail: '',
        productType: 'simple',
        isFeatured: false,
        companyId: UserController.instance.user.value.companyId,
      );

      await _repo.createMyProduct(product);
      if (mounted) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto creado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nombre*'),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio*'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Crear'),
        ),
      ],
    );
  }
}

class EditProductDialog extends StatefulWidget {
  final ProductModel product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  final _repo = Get.put(ProductRepository());
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final updated = ProductModel(
        id: widget.product.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        stock: widget.product.stock,
        thumbnail: widget.product.thumbnail,
        productType: widget.product.productType,
        isFeatured: widget.product.isFeatured,
        companyId: widget.product.companyId,
        sku: widget.product.sku,
        brand: widget.product.brand,
        date: widget.product.date,
        images: widget.product.images,
        discountpercentage: widget.product.discountpercentage,
        categoryId: widget.product.categoryId,
        soldQuantity: widget.product.soldQuantity,
        productAttributes: widget.product.productAttributes,
        productVariations: widget.product.productVariations,
      );

      await _repo.updateMyProduct(updated);
      if (mounted) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'),
        ),
      ],
    );
  }
}
