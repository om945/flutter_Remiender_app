import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';

class NotesListUi extends StatelessWidget {
  final String headline;
  final String content;
  final String date;
  final String noteId;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isFavorite;

  const NotesListUi({
    super.key,
    required this.headline,
    required this.content,
    required this.date,
    required this.noteId,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isSelected ? blueColor.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (isSelectionMode)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) => onTap(),
                  activeColor: blueColor,
                  checkColor: blackColor,
                  side: const BorderSide(color: whiteColor),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    isFavorite
                        ? Icon(Icons.star, color: whiteColor, size: 15.sp)
                        : SizedBox.shrink(),
                    isFavorite ? SizedBox(width: 5.w) : SizedBox.shrink(),
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
                  ],
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
                    SizedBox(width: 15.w),
                    Text(
                      content,
                      style: TextStyle(
                        fontFamily: googleFontFaintNormal,
                        color: faintwhiteColor,
                        fontSize: 15.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
