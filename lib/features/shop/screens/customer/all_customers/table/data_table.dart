import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../controllers/customer/customer_controller.dart';
import 'table_source.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return Obx(
      () {
        // Customers & Selected Rows are Hidden => Just to update the UI => Obx => [ProductRows]
        Visibility(visible: false, child: Text(controller.filteredItems.length.toString()));
        Visibility(visible: false, child: Text(controller.selectedRows.length.toString()));

        // Table
        return TPaginatedDataTable(
          minWidth: 700,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(label: const Text('Clientes'), onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending)),
            const DataColumn2(label: Text('Correo')),
            const DataColumn2(label: Text('Teléfono')),
            const DataColumn2(label: Text('Fecha de registro')),
            const DataColumn2(label: Text('Acción'), fixedWidth: 100),
          ],
          source: CustomerRows(),
        );
      },
    );
  }
}
