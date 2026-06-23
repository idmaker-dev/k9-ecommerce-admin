import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../data/repositories/audit/audit_repository.dart';
import '../../models/audit_log_model.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: _AuditLogsView(),
      tablet: _AuditLogsView(),
      mobile: _AuditLogsView(),
    );
  }
}

class _AuditLogsView extends StatefulWidget {
  const _AuditLogsView();

  @override
  State<_AuditLogsView> createState() => _AuditLogsViewState();
}

class _AuditLogsViewState extends State<_AuditLogsView> {
  final _repo = Get.put(AuditRepository());
  bool _loading = true;
  List<AuditLogModel> _rows = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await _repo.getAuditLogs();
    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loading = false;
    });
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
            Text('Auditoría', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),
            Expanded(
              child: _rows.isEmpty
                  ? const Center(child: Text('No hay eventos de auditoría'))
                  : ListView.separated(
                      itemCount: _rows.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final row = _rows[index];
                        return ListTile(
                          title: Text('${row.action} · ${row.entityType}'),
                          subtitle: Text('Actor: ${row.actorRole ?? '-'} · Empresa: ${row.companyId ?? '-'}'),
                          trailing: Text(row.createdAt?.toIso8601String().replaceFirst('T', ' ').substring(0, 19) ?? '-'),
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
