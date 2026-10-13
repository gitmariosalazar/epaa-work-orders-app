// lib/features/properties/data/mappers/property_mapper.dart

import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/connection_with_properties_response.dart'
    as dto;
import 'package:clean_architecture/features/connections/domain/entities/property.dart';

extension PropertyDtoMapper on dto.Property {
  PropertyEntity toEntity() {
    return PropertyEntity(
      propertyId: propertyId,
      propertySector: propertySector ?? '',
      propertyTypeId: propertyTypeId ?? 0,
      propertyTypeName: propertyTypeName ?? '',
      propertyAddress: propertyAddress ?? '',
      propertyAlleyway: propertyAlleyway ?? '',
      propertyAltitude: propertyAltitude,
      propertyPrecision: propertyPrecision,
      propertyReference: propertyReference,
      propertyCoordinates: propertyCoordinates,
      propertyCadastralKey: propertyCadastralKey ?? '',
      propertyGeometricZone: propertyGeometricZone,
    );
  }
}
