import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';

class TodoListUi extends StatelessWidget {
  final String content;
  final String date;
  final String noteId;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const TodoListUi({
    super.key,
    required this.content,
    required this.date,
    required this.noteId,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
