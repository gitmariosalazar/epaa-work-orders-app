import 'package:clean_architecture/features/connections/search/data/model/schemas/dto/response/connection_with_properties_response.dart'
    as dto;
import 'package:clean_architecture/features/connections/domain/entities/last_reading.dart';

extension LastReadingDtoMapper on dto.LastReading {
  LastReadingEntity toEntity() {
    return LastReadingEntity(
      cadastralKey: cadastralKey,
      readingDate: readingDate != null ? DateTime.parse(readingDate!) : null,
      readingTime: readingTime,
      readingMonth: readingMonth,
      readingValueCurrent: readingValueCurrent,
      readingValuePreview: readingValuePreview,
      novelty: novelty,
    );
  }
}
