import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';

class AddNotePage extends StatelessWidget {
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.save_alt_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  controller: headlineController,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontFamily: googleFontSemiBold,
                    color: whiteColor,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 30.sp,
                      fontFamily: googleFontSemiBold,
                      color: faintwhiteColor,
                    ),
                    hintText: 'Headline',
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  controller: contentController,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  scrollPhysics: BouncingScrollPhysics(),
                  selectionHeightStyle: BoxHeightStyle.max,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: googleFontNormal,
                    color: whiteColor,
                  ),
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
