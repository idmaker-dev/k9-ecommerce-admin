class CompanyModel {
  final String id;
  final String name;
  final String? legalName;
  final String? description;
  final String? logoUrl;
  final String status;
  final double? commissionRate;

  const CompanyModel({
    required this.id,
    required this.name,
    this.legalName,
    this.description,
    this.logoUrl,
    this.status = 'pending',
    this.commissionRate,
  });

  static CompanyModel empty() => const CompanyModel(id: '', name: '');

  factory CompanyModel.fromJson(Map<String, dynamic> data, {String? id}) {
    if (data.isEmpty && id == null) return CompanyModel.empty();

    return CompanyModel(
      id: id ?? data['id']?.toString() ?? data['Id']?.toString() ?? '',
      name: data['Name']?.toString() ?? data['name']?.toString() ?? '',
      legalName: data['LegalName']?.toString() ?? data['legal_name']?.toString(),
      description: data['Description']?.toString() ?? data['description']?.toString(),
      logoUrl: data['LogoUrl']?.toString() ?? data['logo_url']?.toString(),
      status: data['Status']?.toString() ?? data['status']?.toString() ?? 'pending',
      commissionRate: data['CommissionRate'] != null
          ? (data['CommissionRate'] as num).toDouble()
          : (data['commission_rate'] != null
                ? (data['commission_rate'] as num).toDouble()
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'LegalName': legalName,
      'Description': description,
      'LogoUrl': logoUrl,
      'Status': status,
      'CommissionRate': commissionRate,
    };
  }
}
