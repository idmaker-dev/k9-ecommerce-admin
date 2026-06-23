import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/company_model.dart';
import '../../models/company_settlement_model.dart';
import '../../../../../data/repositories/settlement/settlement_repository.dart';

class SettlementsScreen extends StatelessWidget {
  const SettlementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: _SettlementsView(),
      tablet: _SettlementsView(),
      mobile: _SettlementsView(),
    );
  }
}

class _SettlementsView extends StatefulWidget {
  const _SettlementsView();

  @override
  State<_SettlementsView> createState() => _SettlementsViewState();
}

class _SettlementsViewState extends State<_SettlementsView> {
  final _repo = Get.put(SettlementRepository());
  bool _loading = true;
  List<CompanySettlementModel> _settlements = const [];
  List<CompanyModel> _companies = const [];
  CompanyModel? _selectedCompany;
  double _pendingAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final settlements = await _repo.getSettlements();
    final role = UserController.instance.user.value.role;
    List<CompanyModel> companies = const [];
    double pending = 0.0;

    if (role == AppRole.admin) {
      companies = await _repo.getActiveCompanies();
      if (companies.isNotEmpty) {
        _selectedCompany = companies.first;
      }
    } else if (role == AppRole.companyAdmin) {
      pending = await _repo.getPendingAmountForMyCompany();
    }

    if (!mounted) return;
    setState(() {
      _settlements = settlements;
      _companies = companies;
      _pendingAmount = pending;
      _loading = false;
    });
  }

  Future<void> _buildSettlement() async {
    if (_selectedCompany == null) return;

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    await _repo.buildSettlement(
      companyId: _selectedCompany!.id,
      periodStart: start,
      periodEnd: end,
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final role = UserController.instance.user.value.role;
    final isAdmin = role == AppRole.admin;

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
              isAdmin ? 'Liquidaciones' : 'Mis liquidaciones',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            if (isAdmin)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<CompanyModel>(
                      value: _selectedCompany,
                      items: _companies
                          .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCompany = v),
                      decoration: const InputDecoration(labelText: 'Empresa'),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  ElevatedButton(
                    onPressed: _selectedCompany == null ? null : _buildSettlement,
                    child: const Text('Construir liquidación'),
                  ),
                ],
              )
            else
              Text(
                'Monto pendiente estimado: \$${_pendingAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Expanded(
              child: _settlements.isEmpty
                  ? const Center(child: Text('No hay liquidaciones'))
                  : ListView.separated(
                      itemCount: _settlements.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final row = _settlements[index];
                        return ListTile(
                          title: Text('Periodo ${row.periodStart?.toIso8601String().split('T').first ?? '-'} a ${row.periodEnd?.toIso8601String().split('T').first ?? '-'}'),
                          subtitle: Text('Estado: ${row.status} · Total: \$${row.totalAmount.toStringAsFixed(2)}'),
                          trailing: isAdmin && row.status != 'paid'
                              ? TextButton(
                                  onPressed: () async {
                                    await _repo.markSettlementPaid(row.id);
                                    await _load();
                                  },
                                  child: const Text('Marcar pagada'),
                                )
                              : null,
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
