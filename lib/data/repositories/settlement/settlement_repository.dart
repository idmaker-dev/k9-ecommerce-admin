import 'package:get/get.dart';

import '../../services/supabase/supabase_client.dart';
import '../../../features/shop/models/company_model.dart';
import '../../../features/shop/models/company_settlement_model.dart';

class SettlementRepository extends GetxController {
  static SettlementRepository get instance => Get.find();

  Future<List<CompanySettlementModel>> getSettlements() async {
    final rows = await supabase
        .from('company_settlements')
        .select('*')
        .order('created_at', ascending: false);

    return (rows as List)
        .map((e) => CompanySettlementModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getSettlementOrders(String settlementId) async {
    final rows = await supabase
        .from('company_settlement_orders')
        .select('order_id, amount')
        .eq('settlement_id', settlementId);

    return (rows as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<String> buildSettlement({
    required String companyId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    final result = await supabase.rpc('build_settlement', params: {
      'p_company_id': companyId,
      'p_start': periodStart.toIso8601String().split('T').first,
      'p_end': periodEnd.toIso8601String().split('T').first,
    });

    try {
      await supabase.rpc('log_audit', params: {
        'p_action': 'settlement.build',
        'p_entity_type': 'settlement',
        'p_entity_id': result.toString(),
        'p_company_id': companyId,
        'p_detail': {
          'period_start': periodStart.toIso8601String().split('T').first,
          'period_end': periodEnd.toIso8601String().split('T').first,
        },
      });
    } catch (_) {}

    return result.toString();
  }

  Future<void> markSettlementPaid(String settlementId) async {
    await supabase
        .from('company_settlements')
        .update({'status': 'paid', 'paid_at': DateTime.now().toIso8601String()})
        .eq('id', settlementId);

    try {
      await supabase.rpc('log_audit', params: {
        'p_action': 'settlement.paid',
        'p_entity_type': 'settlement',
        'p_entity_id': settlementId,
      });
    } catch (_) {}
  }

  Future<List<CompanyModel>> getActiveCompanies() async {
    final rows = await supabase
        .from('companies')
        .select('id, name, legal_name, description, logo_url, status, commission_rate')
        .eq('status', 'active')
        .order('name', ascending: true);

    return (rows as List)
        .map((e) => CompanyModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<double> getPendingAmountForMyCompany() async {
    final rows = await supabase
        .from('orders')
        .select('company_amount')
        .isFilter('settlement_id', null)
        .eq('payment_status', 'paid');

    return (rows as List)
        .map((e) => (e['company_amount'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (sum, value) => sum + value);
  }
}
