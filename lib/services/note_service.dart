import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/models/notes.dart';
import 'package:remiender_app/utils/constants.dart';
import 'package:remiender_app/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NoteService {
  void addNote({
    required BuildContext context,
    required String headline,
    required String content,
  }) async {
    try {
      final user = Provider.of<UserProvideer>(context, listen: false).user;
      Notes notes = Notes(
        id: '',
        userId: user.id,
        headline: headline,
        content: content,
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

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/notes'),
        body: jsonEncode(notes.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Note Saved!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
