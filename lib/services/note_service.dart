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
  Future<void> addNote({
    required BuildContext context,
    String? noteId, // Add note ID parameter
    required String headline,
    required String content,
    required bool isUpdate,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      Notes notes = Notes(
        id: noteId ?? '', // Use provided note ID or empty string
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

      // Determine the endpoint based on whether it's an update or create
      String endpoint;
      if (isUpdate) {
        // For updates, use the same endpoint but with PATCH method
        endpoint = '${Constants.uri}/api/notes';
      } else {
        endpoint = '${Constants.uri}/api/notes';
      }
      httpErrorHandle(
        response: isUpdate
            ? await http.patch(
                Uri.parse(endpoint),
                body: jsonEncode({
                  ...notes.toJson(),
                  'id': noteId, // Ensure ID is included in body for updates
                }),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'x-auth-token': token,
                },
              )
            : await http.post(
                Uri.parse(endpoint),
                body: jsonEncode(notes.toJson()),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'x-auth-token': token,
                },
              ),
        context: context,
        onSuccess: () {
          showSnackBar(context, isUpdate ? 'Note Updated!' : 'Note Saved!');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  Future<List<Notes>> fetchnotes(BuildContext context, String userId) async {
    List<Notes> notes = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;

      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/notes'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // The backend returns a direct JSON array of notes.
          final List<dynamic> responseData = jsonDecode(res.body);

          // Use a more functional approach to parse the notes.
          // This is robust against malformed items in the list.
          notes.addAll(
            responseData.whereType<Map<String, dynamic>>().map((noteData) {
              try {
                return Notes.fromJson(noteData);
              } catch (e) {
                // Log or silently ignore individual parsing errors
                // to prevent one bad note from stopping the whole process.
                debugPrint('Could not parse note: $e');
                return null;
              }
            }).whereType<Notes>(), // Filter out any nulls from failed parses
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error fetching notes: ${e.toString()}');
    }
    return notes;
  }

  Future<void> updateFavoriteNote({
    required BuildContext context,
    required String noteId,
    required bool isFavorite,
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
        Uri.parse('${Constants.uri}/api/todo/$noteId/favorite'),
        body: jsonEncode({'isFavorite': isFavorite}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Note status updated successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteNote({
    required BuildContext context,
    required String noteId,
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
          Uri.parse('${Constants.uri}/api/notes'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({'id': noteId}),
        ),
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Note Deleted!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
