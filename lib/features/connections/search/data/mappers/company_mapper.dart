// lib/features/properties/data/mappers/company_mapper.dart

import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/connection_with_properties_response.dart'
    as dto;
import 'package:clean_architecture/features/connections/domain/entities/company.dart';
import 'contact_mapper.dart';

extension CompanyDtoMapper on dto.Company {
  CompanyEntity toEntity() {
    return CompanyEntity(
      ruc: ruc,
      address: address,
      country: country,
      clientId: clientId,
      parishId: parishId,
      companyId: companyId ?? 0,
      businessName: businessName,
      commercialName: commercialName,
      emails: emails.map((e) => e?.toEntity()).toList(),
      phones: phones.map((e) => e?.toEntity()).toList(),
    );
  }
}
