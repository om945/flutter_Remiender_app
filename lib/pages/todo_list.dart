import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/todo_provider.dart';
import 'package:remiender_app/models/todo.dart';
import 'package:remiender_app/services/todo_service.dart';
import 'package:remiender_app/theme/theme.dart';
import 'package:remiender_app/theme/todo_list_ui.dart';

class TodoList extends StatefulWidget {
  final String? content;
  final String? todoId;
  const TodoList({super.key, this.content, this.todoId});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController toDoController = TextEditingController();
  final TodoService todoService = TodoService();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isSelectionMode = false;
  final Set<String> _selectedTodoIds = {};

  @override
  void initState() {
    super.initState();
    // If content is passed, it means we are editing an existing to-do.
    // Pre-fill the text field with the existing content.
    if (widget.content != null) {
      toDoController.text = widget.content!;
    }
    _loadData(); // Call _loadData here
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: blueColor, // Header background color
              onPrimary: blackColor, // Header text color
              surface: blackColor, // Body background color
              onSurface: whiteColor, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: blueColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: blueColor, // Header background color
              onPrimary: blackColor, // Header text color
              surface: blackColor, // Body background color
              onSurface: whiteColor, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: blueColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _isLoading = false;

  void addTodo() async {
    DateTime? reminderDateTime;
    if (_selectedDate != null && _selectedTime != null) {
      reminderDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    await todoService.addTodo(
      context: context,
      content: toDoController.text.trim(),
      isUpdate: widget.todoId != null && widget.todoId!.isNotEmpty,
      todoId: widget.todoId,
      reminderDate: reminderDateTime,
    );
    if (!mounted) return;
    Navigator.pop(context); // Close the modal after saving
    toDoController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  // ignore: unused_element
  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });
    // Fetch todos using TodoProvider
    await Provider.of<TodoProvider>(
      context,
      listen: false,
    ).fetchtodosForUser(context);

    setState(() {
      _isLoading = false;
    });
  }

  void _onTodoLongPress(String todoId) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedTodoIds.add(todoId);
      });
    }
  }

  void _onTodoTap(Todos todo) async {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedTodoIds.contains(todo.id)) {
          _selectedTodoIds.remove(todo.id);
        } else {
          _selectedTodoIds.add(todo.id);
        }
        if (_selectedTodoIds.isEmpty) {
          _isSelectionMode = false;
        }
      });
    } else {
      todoField();
      if (mounted) {
        _loadData();
      }
    }
  }

  void _cancelSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedTodoIds.clear();
    });
  }

  Future<void> _deleteSelectedTodos() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Todos',
            style: TextStyle(color: whiteColor, fontFamily: googleFontNormal),
          ),
          content: Text(
            'Are you sure you want to delete ${_selectedTodoIds.length} selected note(s)?',
            style: TextStyle(color: whiteColor, fontFamily: googleFontNormal),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final idsToDelete = Set<String>.from(_selectedTodoIds);
      for (String todoId in idsToDelete) {
        await todoService.deleteTodo(context: context, todoId: todoId);
      }
      _cancelSelectionMode();
      await _loadData();
    }
  }

  void todoField() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24.w,
              right: 24.w,
              top: 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: blueColor,
                          fontFamily: googleFontSemiBold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Text(
                      'New To-Do',
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: googleFontSemiBold,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        addTodo();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: blueColor,
                          fontFamily: googleFontSemiBold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  controller: toDoController,
                  cursorColor: blueColor,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: whiteColor,
                    fontFamily: googleFontFaintNormal,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorWidth: 2.w,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: faintwhiteColor),
                    ),
                    hintText: 'New To-Do',
                    hintStyle: TextStyle(
                      color: faintwhiteColor,
                      fontFamily: googleFontFaintNormal,
                      fontSize: 15.sp,
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 5,
                      borderSide: BorderSide(color: blueColor),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueColor),
                      gapPadding: 5,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                IconButton(
                  onPressed: () async {
                    await _pickDate(context);
                    await _pickTime(context);
                  },
                  icon: const Icon(
                    Icons.notifications_active_rounded,
                    color: blueColor,
                  ),
                ),
                if (_selectedDate != null || _selectedTime != null)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      'Reminder: ${_selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : ''}${_selectedTime != null ? ' at ${_selectedTime!.format(context)}' : ''}',
                      style: TextStyle(
                        color: faintwhiteColor,
                        fontFamily: googleFontFaintNormal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final todos = todoProvider.todos;

        String formatTime(DateTime? dateTime) {
          if (dateTime == null) return 'No date';
          try {
            // Format as 'yyyy-MM-dd'
            return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
          } catch (e) {
            return 'Invalid date';
          }
        }

        if (_isLoading && !_isSelectionMode) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: blueColor)),
          );
        }

        return Scaffold(
          floatingActionButton: _isSelectionMode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: _cancelSelectionMode,
                      heroTag: 'cancel_button',
                      backgroundColor: blueColor,
                      child: const Icon(Icons.close, color: blackColor),
                    ),
                    SizedBox(width: 10.w),
                    FloatingActionButton(
                      heroTag: 'delete_button',
                      onPressed: _selectedTodoIds.isNotEmpty
                          ? _deleteSelectedTodos
                          : null,
                      backgroundColor: _selectedTodoIds.isNotEmpty
                          ? Colors.red
                          : Colors.grey,
                      child: const Icon(Icons.delete, color: whiteColor),
                    ),
                  ],
                )
              : FloatingActionButton(
                  onPressed: () async {
                    todoField();
                    if (mounted) {
                      _loadData();
                    }
                  },
                  backgroundColor: blueColor,
                  child: Icon(Icons.add, color: blackColor, size: 30.sp),
                ),
          body: todos.isEmpty
              ? RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          'No Todos yet',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: googleFontNormal,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {
                      //     TodoService().showImmediateNotification(
                      //       'Test Title',
                      //       'This is an immediate test notification!',
                      //     );
                      //   },
                      //   child: const Text('Show Immediate Notification'),
                      // ),
                      todos
                              .where((todo) => todo.isCompleted == false)
                              .isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: todos
                                    .where((todo) => todo.isCompleted == false)
                                    .length,
                                itemBuilder: (context, index) {
                                  final todo = todos
                                      .where(
                                        (todo) => todo.isCompleted == false,
                                      )
                                      .elementAt(index);
                                  return TodoListUi(
                                    content: todo.content,
                                    date: formatTime(todo.createdAt),
                                    todoId: todo.id,
                                    isSelectionMode: _isSelectionMode,
                                    isSelected: _selectedTodoIds.contains(
                                      todo.id,
                                    ),
                                    isCompleted: todo.isCompleted ?? false,
                                    onTap: () => _onTodoTap(todo),
                                    onLongPress: () =>
                                        _onTodoLongPress(todo.id),
                                    onCompletionChanged: (value) {
                                      if (value != null) {
                                        todoProvider.updateTodoCompletionStatus(
                                          context,
                                          todo.id,
                                          value,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                      todos
                              .where((todo) => todo.isCompleted == false)
                              .isNotEmpty
                          ? SizedBox(height: 20.h)
                          : SizedBox(),
                      todos.where((todo) => todo.isCompleted == true).isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                'Completed Todos (${todos.where((todo) => todo.isCompleted == true).length})',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: googleFontNormal,
                                  color: whiteColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: todos
                              .where((todo) => todo.isCompleted == true)
                              .length,
                          itemBuilder: (context, index) {
                            final todo = todos
                                .where((todo) => todo.isCompleted == true)
                                .elementAt(index);
                            return TodoListUi(
                              content: todo.content,
                              date: formatTime(todo.createdAt),
                              todoId: todo.id,
                              isSelectionMode: _isSelectionMode,
                              isSelected: _selectedTodoIds.contains(todo.id),
                              isCompleted: todo.isCompleted ?? false,
                              onTap: () => _onTodoTap(todo),
                              onLongPress: () => _onTodoLongPress(todo.id),
                              onCompletionChanged: (value) {
                                if (value != null) {
                                  todoProvider.updateTodoCompletionStatus(
                                    context,
                                    todo.id,
                                    value,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
