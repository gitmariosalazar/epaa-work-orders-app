import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/reading/data/model/create_reading_request.dart';
import 'package:clean_architecture/features/reading/data/model/update_reading_request.dart';
import 'package:clean_architecture/features/reading/domain/entities/reading.dart';
import 'package:clean_architecture/features/reading/domain/entities/reading_result.dart';

abstract class ReadingRepository {
  FutureData<List<Reading>> getReadingInfo(String cadastralKey);
  FutureData<List<Reading>> findBasicReading(String catastralCode);
  FutureData<ReadingResult> updateCurrentReading(
    String readingId,
    UpdateReadingRequest request,
  );
  FutureData<ReadingResult> createReading(CreateReadingRequest request);
}
