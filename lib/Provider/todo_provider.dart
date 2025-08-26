import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/models/todo.dart';
import 'package:remiender_app/services/todo_service.dart';
import 'package:remiender_app/utils/utils.dart';

class TodoProvider extends ChangeNotifier {
  List<Todos> _todos = [];
  List<Todos> _pendingTodos = [];
  List<Todos> _completedTodos = [];

  List<Todos> get todos => _todos;
  List<Todos> get pendingTodos => _pendingTodos;
  List<Todos> get completedTodos => _completedTodos;

  void setTodos(List<Todos> todos) {
    todos.sort((a, b) {
      final dateTimeA = a.createdAt;
      final dateTimeB =
          b.createdAt; // Corrected to use b.createdAt for comparison

      if (dateTimeA == null && dateTimeB == null) {
        return 0;
      } else if (dateTimeA == null) {
        return 1;
      } else if (dateTimeB == null) {
        return -1;
      } else {
        return dateTimeB.compareTo(dateTimeA);
      }
    });
    _todos = todos;
    _pendingTodos = todos.where((todo) => todo.isCompleted == false).toList();
    _completedTodos = todos.where((todo) => todo.isCompleted == true).toList();
    notifyListeners();
  }

  Future<void> fetchtodosForUser(BuildContext context) async {
    final todoService = TodoService();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    if (userId.isNotEmpty) {
      final fetchTodos = await todoService.fetchtodos(context, userId);
      setTodos(fetchTodos);
    }
  }

  Future<void> updateTodoCompletionStatus(
    BuildContext context,
    String todoId,
    bool isCompleted,
  ) async {
    try {
      await TodoService().updateTodoCompletionStatus(
        context: context,
        todoId: todoId,
        isCompleted: isCompleted,
      );
      // Update the local state
      final int index = _todos.indexWhere((todo) => todo.id == todoId);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(isCompleted: isCompleted);
        // Call setTodos to re-sort and notify listeners
        setTodos(List.from(_todos));
        // If the todo is marked as complete, cancel its notification
        if (isCompleted) {
          TodoService().cancelNotification(todoId);
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString()); // Pass context here
    }
  }
}
