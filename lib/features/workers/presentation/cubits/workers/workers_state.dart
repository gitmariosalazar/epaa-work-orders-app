import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:equatable/equatable.dart';

sealed class WorkersState extends Equatable {
  const WorkersState();

  @override
  List<Object?> get props => [];
}

class WorkersInitial extends WorkersState {}

class WorkersLoading extends WorkersState {}

class WorkersLoaded extends WorkersState {
  final List<WorkerEntity> workers;

  const WorkersLoaded(this.workers);

  @override
  List<Object?> get props => [workers];
}

class WorkersError extends WorkersState {
  final String message;

  const WorkersError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkersEmpty extends WorkersState {}
