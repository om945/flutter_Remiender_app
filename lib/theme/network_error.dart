import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';

class NetworkError extends StatelessWidget {
  final VoidCallback onRetry;
  const NetworkError({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/network_error.png',
              fit: BoxFit.cover,
              scale: 1.7,
            ),
            SizedBox(height: 20.h),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontFamily: googleFontBold,
                fontSize: 18.sp,
                color: whiteColor,
              ),
            ),
            SizedBox(height: 20.h),
            MaterialButton(
              onPressed: onRetry,
              color: blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  fontFamily: googleFontSemiBold,
                  color: blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
