class HomeCompanyOption {
  const HomeCompanyOption({
    required this.companyId,
    required this.companyUserId,
    required this.businessName,
  });

  final String companyId;
  final String companyUserId;
  final String businessName;

  factory HomeCompanyOption.fromMap(Map<String, dynamic> map) {
    return HomeCompanyOption(
      companyId: (map['company_id'] ?? '').toString(),
      companyUserId: (map['company_user_id'] ?? '').toString(),
      businessName: (map['business_name'] ?? '').toString(),
    );
  }

  Map<String, String> toMap() {
    return {
      'company_id': companyId,
      'company_user_id': companyUserId,
      'business_name': businessName,
    };
  }
}
