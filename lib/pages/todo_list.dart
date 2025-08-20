import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController toDoController = TextEditingController();
  // ignore: unused_field
  bool _isLoading = false;

  // ignore: unused_element
  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });
  }

  void todoField() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24.w,
              right: 24.w,
              top: 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: blueColor,
                          fontFamily: googleFontSemiBold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Text(
                      'New To-Do',
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: googleFontSemiBold,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: blueColor,
                          fontFamily: googleFontSemiBold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  controller: toDoController,
                  cursorColor: blueColor,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: whiteColor,
                    fontFamily: googleFontFaintNormal,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorWidth: 2.w,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: faintwhiteColor),
                    ),
                    hintText: 'New To-Do',
                    hintStyle: TextStyle(
                      color: faintwhiteColor,
                      fontFamily: googleFontFaintNormal,
                      fontSize: 15.sp,
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 5,
                      borderSide: BorderSide(color: blueColor),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueColor),
                      gapPadding: 5,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_active_rounded,
                    color: blueColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: blueColor)),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: todoField,
        backgroundColor: blueColor,
        child: Icon(Icons.add, color: blackColor, size: 30.sp),
      ),
      body: Padding(padding: const EdgeInsets.all(10.0), child: ListView()),
    );
  }
}
