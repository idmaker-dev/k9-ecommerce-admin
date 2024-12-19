import 'package:flutter/material.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/pricing_calculator.dart';
import '../../../../models/order_model.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final subTotal = order.items.fold(0.0, (previousValue, element) => previousValue + (element.price * element.quantity));
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Articulos', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Items
          ListView.separated(
            shrinkWrap: true,
            itemCount: order.items.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final item = order.items[index];
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        TRoundedImage(
                          backgroundColor: TColors.primaryBackground,
                          imageType: item.image != null ? ImageType.network : ImageType.asset,
                          image: item.image ?? TImages.defaultImage,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (item.selectedVariation != null)
                                Text(item.selectedVariation!.entries.map((e) => ('${e.key} : ${e.value} ')).toString())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  SizedBox(
                      width: TSizes.xl * 2,
                      child: Text('\$${item.price.toStringAsFixed(1)}', style: Theme.of(context).textTheme.bodyLarge)),
                  SizedBox(
                    width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl * 1.4 : TSizes.xl * 2,
                    child: Text(item.quantity.toString(), style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  SizedBox(
                    width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl * 1.4 : TSizes.xl * 2,
                    child: Text('\$${item.totalAmount}', style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Items Total
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: Theme.of(context).textTheme.titleLarge),
                    Text('\$$subTotal', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Descuento', style: Theme.of(context).textTheme.titleLarge),
                    Text('\$0.00', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Envío', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$${order.shippingCost.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Impuesto', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$${order.taxCost.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
