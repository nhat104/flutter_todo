import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  EditTodoCubit(TodosRepository todosRepository, Todo? initialTodo)
      : _todosRepository = todosRepository,
        super(
          EditTodoState(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            description: initialTodo?.description ?? '',
          ),
        );

  final TodosRepository _todosRepository;

  void onTitleChanged(String title) => emit(state.copyWith(title: title));

  void onDescriptionChanged(String description) =>
      emit(state.copyWith(description: description));

  Future<void> onSubmitted() async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
