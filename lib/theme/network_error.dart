import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150.h),
            Image.asset(
              'assets/network_error.png',
              fit: BoxFit.cover,
              scale: 1.7,
            ),
            SizedBox(height: 20.h),
            Text(
              'Something went wrong',
              style: TextStyle(fontFamily: googleFontBold, fontSize: 18.sp),
            ),
            SizedBox(height: 20.h),
            MaterialButton(
              onPressed: () {},
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontFamily: googleFontSemiBold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
