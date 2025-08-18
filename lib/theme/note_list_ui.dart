import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/pages/add_note_page.dart';
import 'package:remiender_app/theme/theme.dart';

class NotesListUi extends StatelessWidget {
  final String headline;
  final String content;
  final String date;
  final String noteId;
  const NotesListUi({
    super.key,
    required this.headline,
    required this.content,
    required this.date,
    required this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddNotePage(
              noteId: noteId,
              headline: headline.toString(),
              content: content.toString(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline.isEmpty ? content : headline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                  date,
                  style: TextStyle(
                    fontFamily: googleFontFaintNormal,
                    color: faintwhiteColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontFamily: googleFontFaintNormal,
                      color: faintwhiteColor,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
