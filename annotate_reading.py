import re
import os

files_to_annotate = [
    {
        "path": "lib/features/reading/data/datasources/remote_reading_data_source.dart",
        "pattern": r"class RemoteReadingDataSourceImpl implements RemoteReadingDataSource {",
        "replacement": "import 'package:injectable/injectable.dart';\n\n@LazySingleton(as: RemoteReadingDataSource)\nclass RemoteReadingDataSourceImpl implements RemoteReadingDataSource {"
    },
    {
        "path": "lib/features/reading/data/repositories/reading_repository_impl.dart",
        "pattern": r"class ReadingRepositoryImpl implements ReadingRepository {",
        "replacement": "import 'package:injectable/injectable.dart';\n\n@LazySingleton(as: ReadingRepository)\nclass ReadingRepositoryImpl implements ReadingRepository {"
    },
    {
        "path": "lib/features/reading/domain/usecases/get_reading_info.dart",
        "pattern": r"class GetReadingInfo implements UseCase<List<Reading>, String> {",
        "replacement": "import 'package:injectable/injectable.dart';\n\n@lazySingleton\nclass GetReadingInfo implements UseCase<List<Reading>, String> {"
    },
    {
        "path": "lib/features/reading/domain/usecases/create_reading_usecase.dart",
        "pattern": r"class CreateReadingUseCase implements UseCase<ReadingResult, CreateReadingRequest> {",
        "replacement": "import 'package:injectable/injectable.dart';\n\n@lazySingleton\nclass CreateReadingUseCase implements UseCase<ReadingResult, CreateReadingRequest> {"
    },
    {
        "path": "lib/features/reading/presentation/manually/blocs/reading_manually_bloc.dart",
        "pattern": r"class ReadingManuallyBloc",
        "replacement": "import 'package:injectable/injectable.dart';\n\n@injectable\nclass ReadingManuallyBloc"
    },
    {
        "path": "lib/features/reading/presentation/scan/bloc/reading_scan_bloc.dart",
        "pattern": r"class ReadingScanBloc extends Bloc<ReadingScanEvent, ReadingScanState> {",
        "replacement": "import 'package:injectable/injectable.dart';\n\n@injectable\nclass ReadingScanBloc extends Bloc<ReadingScanEvent, ReadingScanState> {"
    }
]

for item in files_to_annotate:
    with open(item["path"], "r") as f:
        content = f.read()
    
    if "import 'package:injectable/injectable.dart';" not in content:
        new_content = re.sub(item["pattern"], item["replacement"], content, count=1)
        with open(item["path"], "w") as f:
            f.write(new_content)
