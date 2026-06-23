import 'package:get/get.dart';

import '../../services/supabase/supabase_client.dart';
import '../../../features/shop/models/audit_log_model.dart';

class AuditRepository extends GetxController {
  static AuditRepository get instance => Get.find();

  Future<List<AuditLogModel>> getAuditLogs() async {
    final rows = await supabase
        .from('audit_logs')
        .select('*')
        .order('created_at', ascending: false)
        .limit(300);

    return (rows as List)
        .map((e) => AuditLogModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> logAudit({
    required String action,
    required String entityType,
    String? entityId,
    String? companyId,
    Map<String, dynamic>? detail,
  }) async {
    await supabase.rpc('log_audit', params: {
      'p_action': action,
      'p_entity_type': entityType,
      'p_entity_id': entityId,
      'p_company_id': companyId,
      'p_detail': detail ?? <String, dynamic>{},
    });
  }
}
