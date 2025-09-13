import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/Provider/todo_provider.dart';
import 'package:remiender_app/models/todo.dart';
import 'package:remiender_app/utils/constants.dart';
import 'package:remiender_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class TodoService {
  Future<void> addTodo({
    required BuildContext context,
    String? todoId,
    required String content,
    required bool isUpdate,
    DateTime? reminderDate,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      Todos todos = Todos(
        id: todoId ?? '',
        userId: user.id,
        content: content,
        reminderDate: reminderDate,
      );

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(
          context,
          'Authentication token not found. Please login again.',
        );
        return;
      }

      http.Response res;
      if (isUpdate) {
        res = await http.patch(
          Uri.parse('${Constants.uri}/api/todo/$todoId'),
          body: jsonEncode(todos.toJson()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
      } else {
        res = await http.post(
          Uri.parse('${Constants.uri}/api/todo'),
          body: jsonEncode(todos.toJson()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
      }

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, isUpdate ? 'Todo Updated' : 'Todo Saved');
          // The backend sends back the created/updated todo object.
          // We parse it to get the definitive ID for the notification.
          final savedTodo = Todos.fromJson(jsonDecode(res.body));

          if (reminderDate != null && reminderDate.isAfter(DateTime.now())) {
            scheduleNotification(savedTodo.id, content, reminderDate);
          } else if (isUpdate) {
            // If it's an update and the reminder is removed or in the past,
            // cancel any existing notification.
            cancelNotification(savedTodo.id);
          }
          // Refresh the todo list in the provider
          Provider.of<TodoProvider>(
            context,
            listen: false,
          ).fetchtodosForUser(context);
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  Future<List<Todos>> fetchtodos(BuildContext context, String userId) async {
    List<Todos> todos = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;

      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/todo'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Decode the JSON string into a List of dynamic objects.
          final List<dynamic> decodedList = jsonDecode(res.body);

          // Map each item in the list to a Todos object and add them all.
          todos.addAll(
            decodedList.map(
              (item) => Todos.fromJson(item as Map<String, dynamic>),
            ),
          );
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        'Something went wrong during fetching todos: ${e.toString()}',
      );
    }
    return todos;
  }

  Future<void> updateTodoCompletionStatus({
    required BuildContext context,
    required String todoId,
    required bool isCompleted,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;

      if (token.isEmpty) {
        showSnackBar(
          context,
          'Authentication token not found. Please login again.',
        );
        return;
      }

      http.Response res = await http.patch(
        Uri.parse('${Constants.uri}/api/todo/$todoId/complete'),
        body: jsonEncode({'isCompleted': isCompleted}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Todo status updated successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void cancelNotification(String id) async {
    await FlutterLocalNotificationsPlugin().cancel(id.hashCode);
  }

  void scheduleNotification(
    String id,
    String content,
    DateTime reminderDate,
  ) async {
    tz.initializeTimeZones();
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      reminderDate,
      tz.local,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'todo_reminders',
          'Todo Reminders',
          channelDescription: 'Notifications for your todo list reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
        
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().zonedSchedule(
      id.hashCode, // Unique ID for the notification
      'Todo Reminder',
      content,
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents:
          DateTimeComponents.time, // Optional: adjust as needed
    );
  }

  // void showImmediateNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //         'todo_reminders',
  //         'Todo Reminders',
  //         channelDescription: 'Notifications for your todo list reminders',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         ticker: 'ticker',
  //       );
  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //   );
  //   await FlutterLocalNotificationsPlugin().show(
  //     0, // Notification ID
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }

  Future<void> deleteTodo({
    required BuildContext context,
    required String todoId,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(
          context,
          'Authentication token not found. Please login again.',
        );
        return;
      }
      httpErrorHandle(
        response: await http.delete(
          Uri.parse('${Constants.uri}/api/todo'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({'id': todoId}),
        ),
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Todo Deletd!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
