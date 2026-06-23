import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';
import '../../models/inventory_movement_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../../../data/repositories/product/product_repository.dart';
import '../../../../../data/repositories/inventory/inventory_repository.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: _InventoryView(),
      tablet: _InventoryView(),
      mobile: _InventoryView(),
    );
  }
}

class _InventoryView extends StatefulWidget {
  const _InventoryView();

  @override
  State<_InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<_InventoryView> {
  final _productRepository = Get.put(ProductRepository());
  final _inventoryRepository = Get.put(InventoryRepository());

  List<ProductModel> _products = const [];
  ProductModel? _selectedProduct;
  List<InventoryMovementModel> _movements = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    final rows = await _productRepository.getAllProducts();
    ProductModel? selected;
    if (rows.isNotEmpty) {
      selected = rows.first;
    }

    List<InventoryMovementModel> movements = const [];
    if (selected != null) {
      movements = await _inventoryRepository.getMovementsByProduct(selected.id);
    }

    if (!mounted) return;
    setState(() {
      _products = rows;
      _selectedProduct = selected;
      _movements = movements;
      _loading = false;
    });
  }

  Future<void> _loadMovements() async {
    final product = _selectedProduct;
    if (product == null) return;

    final rows = await _inventoryRepository.getMovementsByProduct(product.id);
    if (!mounted) return;
    setState(() => _movements = rows);
  }

  Future<void> _openAdjustmentDialog() async {
    final product = _selectedProduct;
    if (product == null) return;

    final quantityController = TextEditingController();
    final referenceController = TextEditingController();
    String movementType = 'adjustment';

    await Get.dialog(
      AlertDialog(
        title: const Text('Registrar movimiento de inventario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: movementType,
              items: const [
                DropdownMenuItem(value: 'entry', child: Text('Entrada')),
                DropdownMenuItem(value: 'adjustment', child: Text('Ajuste')),
              ],
              onChanged: (v) {
                if (v != null) movementType = v;
              },
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextFormField(
              controller: referenceController,
              decoration: const InputDecoration(labelText: 'Referencia (opcional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final qty = int.tryParse(quantityController.text.trim()) ?? 0;
              if (qty <= 0) return;

              await _inventoryRepository.applyStockMovement(
                productId: product.id,
                type: movementType,
                quantity: qty,
                reference: referenceController.text.trim().isEmpty ? null : referenceController.text.trim(),
              );

              if (!mounted) return;
              Get.back();
              await _loadMovements();
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompanyAdmin = UserController.instance.user.value.role.name == 'companyAdmin';

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCompanyAdmin ? 'Mi inventario' : 'Inventario por producto',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            DropdownButtonFormField<ProductModel>(
              value: _selectedProduct,
              items: _products
                  .map((p) => DropdownMenuItem<ProductModel>(
                        value: p,
                        child: Text(p.title),
                      ))
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                setState(() => _selectedProduct = value);
                await _loadMovements();
              },
              decoration: const InputDecoration(labelText: 'Producto'),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _openAdjustmentDialog,
                child: const Text('Registrar entrada/ajuste'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Expanded(
              child: _movements.isEmpty
                  ? const Center(child: Text('Sin movimientos de inventario'))
                  : ListView.separated(
                      itemCount: _movements.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final row = _movements[index];
                        return ListTile(
                          title: Text('${row.type} · qty ${row.quantity} · stock ${row.resultingStock}'),
                          subtitle: Text(row.reference ?? '-'),
                          trailing: Text(row.createdAt?.toIso8601String().split('T').first ?? '-'),
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
