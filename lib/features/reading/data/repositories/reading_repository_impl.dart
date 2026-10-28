import 'package:injectable/injectable.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/reading/data/datasources/remote_reading_data_source.dart';
import 'package:clean_architecture/features/reading/data/mappers/reading_mapper.dart';
import 'package:clean_architecture/features/reading/data/model/create_reading_request.dart';
import 'package:clean_architecture/features/reading/data/model/reading_basic_info_response.dart';
import 'package:clean_architecture/features/reading/data/model/reading_response.dart';
import 'package:clean_architecture/features/reading/data/model/update_reading_request.dart';
import 'package:clean_architecture/features/reading/domain/entities/reading.dart';
import 'package:clean_architecture/features/reading/domain/entities/reading_result.dart';
import 'package:clean_architecture/features/reading/domain/repositories/reading_repository.dart';

@LazySingleton(as: ReadingRepository)
class ReadingRepositoryImpl implements ReadingRepository {
  final RemoteReadingDataSource dataSource;

  ReadingRepositoryImpl(this.dataSource);

  @override
  FutureData<List<Reading>> getReadingInfo(String cadastralKey) async {
    try {
      final dto = await dataSource.getReadingInfo(cadastralKey);
      return SuccessState(data: dto.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return FailureState(message: e.message, errorType: ErrorType.serverError);
    } catch (e) {
      return FailureState(message: e.toString(), errorType: ErrorType.unknown);
    }
  }

  @override
  FutureData<List<Reading>> findBasicReading(String catastralCode) async {
    try {
      final dtos = await dataSource.findBasicReading(catastralCode);
      return SuccessState(
        data: dtos.map((dto) => _mapBasicInfoToEntity(dto)).toList(),
      );
    } on ServerException catch (e) {
      return FailureState(message: e.message, errorType: ErrorType.serverError);
    } catch (e) {
      return FailureState(message: e.toString(), errorType: ErrorType.unknown);
    }
  }

  @override
  FutureData<ReadingResult> updateCurrentReading(
    String readingId,
    UpdateReadingRequest request,
  ) async {
    try {
      final dto = await dataSource.updateCurrentReading(readingId, request);
      return SuccessState(data: _mapResponseToEntity(dto));
    } on ServerException catch (e) {
      return FailureState(message: e.message, errorType: ErrorType.serverError);
    } catch (e) {
      return FailureState(message: e.toString(), errorType: ErrorType.unknown);
    }
  }

  @override
  FutureData<ReadingResult> createReading(CreateReadingRequest request) async {
    try {
      final dto = await dataSource.createReading(request);
      return SuccessState(data: _mapResponseToEntity(dto));
    } on ServerException catch (e) {
      return FailureState(message: e.message, errorType: ErrorType.serverError);
    } catch (e) {
      return FailureState(message: e.toString(), errorType: ErrorType.unknown);
    }
  }

  // Mappers (could be moved to separate mapper files)
  Reading _mapBasicInfoToEntity(ReadingBasicInfoResponse dto) {
    return Reading(
      readingId: dto.readingId,
      previousReadingDate: dto.previousReadingDate != null
          ? DateTime.tryParse(dto.previousReadingDate!)
          : null,
      cadastralKey: dto.cadastralKey,
      cardId: dto.cardId,
      clientName: dto.clientName,
      address: dto.address,
      previousReading: dto.previousReading?.toString(),
      currentReading: dto.currentReading?.toString(),
      sector: dto.sector,
      account: dto.account,
      readingValue: dto.readingValue?.toString(),
      averageConsumption: dto.averageConsumption?.toString(),
      meterNumber: dto.meterNumber,
      rateId: dto.rateId,
      rateName: dto.rateName,
    );
  }

  ReadingResult _mapResponseToEntity(ReadingResponse dto) {
    return ReadingResult(
      readingId: dto.readingId,
      connectionId: dto.connectionId,
      readingDate: dto.readingDate != null
          ? DateTime.parse(dto.readingDate!)
          : null,
      readingTime: dto.readingTime,
      sector: dto.sector,
      account: dto.account,
      cadastralKey: dto.cadastralKey,
      readingValue: dto.readingValue,
      sewerRate: dto.sewerRate,
      previousReading: dto.previousReading,
      currentReading: dto.currentReading,
      rentalIncomeCode: dto.rentalIncomeCode,
      novelty: dto.novelty,
      incomeCode: dto.incomeCode,
    );
  }
}
