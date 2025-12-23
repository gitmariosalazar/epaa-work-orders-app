import 'package:clean_architecture/features/connections/domain/entities/contact.dart';

class CompanyEntity {
  final String ruc;
  final String? address;
  final String? country;
  final String clientId;
  final String? parishId;
  final int companyId;
  final String? businessName;
  final String? commercialName;
  final List<EmailEntity?> emails;
  final List<PhoneEntity?> phones;

  const CompanyEntity({
    required this.ruc,
    this.address,
    this.country,
    required this.clientId,
    this.parishId,
    required this.companyId,
    this.businessName,
    this.commercialName,
    required this.emails,
    required this.phones,
  });
}
