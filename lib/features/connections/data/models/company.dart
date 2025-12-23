import 'package:clean_architecture/features/connections/data/models/contact.dart';
import 'package:clean_architecture/features/connections/domain/entities/company.dart';
import 'package:clean_architecture/features/connections/domain/entities/contact.dart';

class CompanyModel {
  final String ruc;
  final String? address;
  final String? country;
  final String clientId;
  final String? parishId;
  final int companyId;
  final String? businessName;
  final String? commercialName;
  final List<EmailModel?> emails;
  final List<PhoneModel?> phones;

  const CompanyModel({
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

  factory CompanyModel.fromEntity(CompanyEntity entity) {
    return CompanyModel(
      ruc: entity.ruc,
      address: entity.address,
      country: entity.country,
      clientId: entity.clientId,
      parishId: entity.parishId,
      companyId: entity.companyId,
      businessName: entity.businessName,
      commercialName: entity.commercialName,
      emails: entity.emails
          .map((e) => e == null ? null : new EmailModel(e.correoid, e.email))
          .toList(),
      phones: entity.phones
          .map((e) => e == null ? null : new PhoneModel(e.telefonoid, e.numero))
          .toList(),
    );
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      ruc: json['ruc'] as String? ?? '',
      address: json['address'] as String? ?? '',
      country: json['country'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      parishId: json['parishId'] as String? ?? '',
      companyId: json['companyId'] as int? ?? 0,
      businessName: json['businessName'] as String? ?? '',
      commercialName: json['commercialName'] as String? ?? '',
      emails: (json['emails'] as List<dynamic>)
          .map(
            (e) => e == null
                ? null
                : EmailModel(
                    e['correoid'] as int? ?? 0,
                    e['email'] as String? ?? '',
                  ),
          )
          .toList(),
      phones: (json['phones'] as List<dynamic>)
          .map(
            (e) => e == null
                ? null
                : PhoneModel(
                    e['telefonoid'] as int? ?? 0,
                    e['numero'] as String? ?? '',
                  ),
          )
          .toList(),
    );
  }

  CompanyEntity toEntity() {
    return CompanyEntity(
      ruc: ruc,
      address: address,
      country: country,
      clientId: clientId,
      parishId: parishId,
      companyId: companyId,
      businessName: businessName,
      commercialName: commercialName,
      emails: emails.map((e) => e?.toEntity()).toList(),
      phones: phones.map((e) => e?.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruc': ruc,
      'address': address,
      'country': country,
      'clientId': clientId,
      'parishId': parishId,
      'companyId': companyId,
      'businessName': businessName,
      'commercialName': commercialName,
      'emails': emails
          .map(
            (e) =>
                e == null ? null : {'correoid': e.correoid, 'email': e.email},
          )
          .toList(),
      'phones': phones
          .map(
            (e) => e == null
                ? null
                : {'telefonoid': e.telefonoid, 'numero': e.numero},
          )
          .toList(),
    };
  }

  CompanyEntity toCompanyEntity() {
    return CompanyEntity(
      ruc: ruc,
      address: address,
      country: country,
      clientId: clientId,
      parishId: parishId,
      companyId: companyId,
      businessName: businessName,
      commercialName: commercialName,
      emails: emails.map((e) => e?.toEntity()).toList(),
      phones: phones.map((e) => e?.toEntity()).toList(),
    );
  }
}
