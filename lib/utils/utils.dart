import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remiender_app/theme/theme.dart';

void showSnackBar(BuildContext context, String text) {
  Get.snackbar(
    'Message',
    text,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: blueColor,
    colorText: blackColor,
    snackStyle: SnackStyle.FLOATING,
  );
}

String _getErrorMessage(http.Response response) {
  try {
    final decodedBody = jsonDecode(response.body);
    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody.containsKey('msg') && decodedBody['msg'] is String) {
        return decodedBody['msg'];
      }
      if (decodedBody.containsKey('error') && decodedBody['error'] is String) {
        return decodedBody['error'];
      }
    }
  } catch (e) {
    // If jsonDecode fails, it's not a JSON response, or the format is unexpected.
    // Fallback to raw body.
  }
  return response.body; // Fallback to raw response body
}

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, _getErrorMessage(response));
      break;
    case 500:
      showSnackBar(context, _getErrorMessage(response));
      break;
    default:
      showSnackBar(context, _getErrorMessage(response));
  }
}
