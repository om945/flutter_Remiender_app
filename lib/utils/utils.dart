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
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
