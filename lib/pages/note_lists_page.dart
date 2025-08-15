import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/pages/add_note_page.dart';
import 'package:remiender_app/theme/custom_ui.dart';
import 'package:remiender_app/theme/theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AddNotePage())),
        child: Icon(Icons.add, color: blackColor, size: 30.sp),
      ),
      body: ListView(children: [CustomUi(), CustomUi()]),
    );
  }
}
