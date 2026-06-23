/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

enum AppRole { admin, companyAdmin, user }

extension AppRoleX on AppRole {
      String get dbValue => this == AppRole.companyAdmin ? 'company_admin' : name;

      static AppRole fromDb(String? r) {
            switch (r) {
                  case 'admin':
                        return AppRole.admin;
                  case 'company_admin':
                        return AppRole.companyAdmin;
                  default:
                        return AppRole.user;
            }
      }
}

enum TransactionType { buy, sell }

enum ProductType { single, variable }

enum ProductVisibility { published, hidden }

enum TextSizes { small, medium, large }

enum ImageType { asset, network, memory, file }

enum MediaCategory { carpetas, banners, marcas, categorias, productos, usuarios }

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentStatus { pending, paid, rejected, refunded }

enum FulfillmentStatus { pending, preparing, shipped, delivered, cancelled }

enum PaymentMethods { paypal, googlePay, applePay, visa, masterCard, creditCard, paystack, razorPay, paytm }