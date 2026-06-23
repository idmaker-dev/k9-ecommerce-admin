import 'package:get/get.dart';

import '../../services/supabase/supabase_client.dart';
import '../../../features/shop/models/inventory_movement_model.dart';

class InventoryRepository extends GetxController {
  static InventoryRepository get instance => Get.find();

  Future<List<InventoryMovementModel>> getMovementsByProduct(String productId) async {
    final rows = await supabase
        .from('inventory_movements')
        .select('*')
        .eq('product_id', productId)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((e) => InventoryMovementModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<int> applyStockMovement({
    required String productId,
    required String type,
    required int quantity,
    String? reference,
  }) async {
    final result = await supabase.rpc('apply_stock_movement', params: {
      'p_product_id': productId,
      'p_type': type,
      'p_quantity': quantity,
      'p_reference': reference,
    });

    try {
      await supabase.rpc('log_audit', params: {
        'p_action': 'inventory.$type',
        'p_entity_type': 'product',
        'p_entity_id': productId,
        'p_detail': {
          'quantity': quantity,
          'reference': reference,
        },
      });
    } catch (_) {}

    return (result as num).toInt();
  }
}
