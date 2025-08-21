import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/models/todo.dart';
import 'package:remiender_app/utils/constants.dart';
import 'package:remiender_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  Future<void> addTodo({
    required BuildContext context,
    String? todoId,
    required String content,
    required bool isUpdate,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      Todos todos = Todos(id: todoId ?? '', userId: user.id, content: content);

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(
          context,
          'Authentication token not found. Please login again.',
        );
        return;
      }
      String endpoint;
      if (isUpdate) {
        endpoint = '${Constants.uri}/api/todo';
      } else {
        endpoint = '${Constants.uri}/api/todo';
      }

      httpErrorHandle(
        response: isUpdate
            ? await http.patch(
                Uri.parse(endpoint),
                body: jsonEncode({...todos.toJson(), 'id': todoId}),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'x-auth-token': token,
                },
              )
            : await http.post(
                Uri.parse(endpoint),
                body: jsonEncode(todos.toJson()),
                headers: <String, String>{
                  'Content-Typ': 'application/json; charset=UTF-8',
                  'x-auth-tokn': token,
                },
              ),
        context: context,
        onSuccess: () {
          showSnackBar(context, isUpdate ? 'Note Updated' : 'Note Saved');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    }
  }
}
