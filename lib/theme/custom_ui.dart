import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:remiender_app/theme/theme.dart';

class CustomUi extends StatefulWidget {
  const CustomUi({super.key});

  @override
  State<CustomUi> createState() => _CustomUiState();
}

class _CustomUiState extends State<CustomUi> {
  @override
  Widget build(BuildContext context) {
    // final screeenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: googleFontSemiBold,
                color: whiteColor,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(
                    fontFamily: googleFontFaintNormal,
                    color: faintwhiteColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    ' Create a Java method validateAge(int age) that: Throws an unchecked exception if age is less than 18.Catches the exception in the main method and displays "Not Eligible to Vote".',
                    style: TextStyle(
                      fontFamily: googleFontFaintNormal,
                      color: faintwhiteColor,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
