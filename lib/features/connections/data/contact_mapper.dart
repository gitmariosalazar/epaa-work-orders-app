import 'package:clean_architecture/features/connections/domain/entities/contact.dart';
import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/connection_with_properties_response.dart'
    as dto;

extension PhoneDtoMapper on dto.Phone {
  PhoneEntity toEntity() {
    return PhoneEntity(telefonoid ?? 0, numero ?? '');
  }
}

extension EmailDtoMapper on dto.Email {
  EmailEntity toEntity() {
    return EmailEntity(correoid ?? 0, email ?? '');
  }
}
