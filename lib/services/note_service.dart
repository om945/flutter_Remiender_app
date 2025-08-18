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
        // Alternative: if your backend expects ID in URL path
        // endpoint = '${Constants.uri}/api/notes/$noteId';
      } else {
        endpoint = '${Constants.uri}/api/notes';
      }

      print('Making ${isUpdate ? "PATCH" : "POST"} request to: $endpoint');
      print('Note ID: $noteId');
      print('Is Update: $isUpdate');

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
      print('Error in addNote: $e');
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
      // final Map<String, dynamic> responseBody = jsonDecode(res.body);
      //   if (responseBody['success'] == true && responseBody['notes'] is List) {
      //     final List<dynamic> responseData = responseBody['notes'];
      //     for (var i = 0; i < responseData.length; i++) {
      //       notes.add(Notes.fromJson(responseData[i]));
      //     }
      //   } else {
      //     showSnackBar(
      //       context,
      //       responseBody['message'] ?? 'Faild to fetch notes',
      //     );

      if (res.statusCode == 200) {
        final dynamic responseBody = jsonDecode(res.body);

        // Handle different possible response structures
        List<dynamic> notesData = [];

        if (responseBody is List) {
          // Backend returns notes directly as an array
          notesData = responseBody;
        } else if (responseBody is Map<String, dynamic>) {
          // Handle wrapped responses if they exist
          if (responseBody['notes'] is List) {
            notesData = responseBody['notes'];
          } else if (responseBody['data'] is List) {
            notesData = responseBody['data'];
          } else {
            showSnackBar(
              context,
              responseBody['message'] ?? 'Invalid response format',
            );
            return notes;
          }
        } else {
          showSnackBar(context, 'Unexpected response format');
          return notes;
        }

        // Parse each note
        for (var noteData in notesData) {
          try {
            if (noteData is Map<String, dynamic>) {
              notes.add(Notes.fromJson(noteData));
            }
          } catch (parseError) {
            showSnackBar(context, parseError.toString());
            // Continue with other notes instead of failing completely
          }
        }
      } else {
        try {
          final errorBody = jsonDecode(res.body);
          showSnackBar(
            context,
            'Failed to fetch notes: ${errorBody['error'] ?? errorBody['message'] ?? 'HTTP ${res.statusCode}'}',
          );
        } catch (parseError) {
          showSnackBar(
            context,
            'Failed to fetch notes: HTTP ${res.statusCode}',
          );
        }
      }
    } catch (e) {
      showSnackBar(context, 'Error fetching notes: ${e.toString()}');
    }
    return notes;
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
          Uri.parse('${Constants.uri}/api/notes/$noteId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
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
