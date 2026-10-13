import 'package:equatable/equatable.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';

abstract class SearchConnectionState extends Equatable {
  const SearchConnectionState();

  @override
  List<Object?> get props => [];
}

class SearchConnectionInitial extends SearchConnectionState {}

class SearchConnectionLoading extends SearchConnectionState {}

class SearchConnectionLoaded extends SearchConnectionState {
  final List<ConnectionEntity> connections;
  const SearchConnectionLoaded(this.connections);

  @override
  List<Object?> get props => [connections];
}

class SearchConnectionError extends SearchConnectionState {
  final String message;
  const SearchConnectionError(this.message);

  @override
  List<Object?> get props => [message];
}
