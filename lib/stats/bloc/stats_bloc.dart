import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(TodosRepository todosRepository)
      : _todosRepository = todosRepository,
        super(const StatsState()) {
    on<StatsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));
    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) {
        return state.copyWith(
          status: StatsStatus.success,
          completedTodos: todos.where((todo) => todo.isCompleted).length,
          activeTodos: todos.where((todo) => !todo.isCompleted).length,
        );
      },
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
