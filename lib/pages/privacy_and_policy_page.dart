import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyAndPolicyPage extends StatelessWidget {
  const PrivacyAndPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        title: Text(
          'Privacy & Policy',
          style: TextStyle(fontFamily: googleFontNormal, color: whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text: '> Privacy & Data Protection Policy\n\n',
                style: TextStyle(
                  fontFamily: googleFontBold,
                  color: whiteColor,
                  fontSize: 18.sp,
                ),
                children: [
                  TextSpan(
                    text:
                        '• All your notes, to-do lists, and reminders are securely encrypted before being stored in our database.\n\n• This means that even if unauthorized access were to occur, your personal information would remain protected and unreadable.\n\n• We do not sell, share, or misuse your data for advertising or third-party purposes.\n\n• Only you have access to your private content, and our systems are designed to ensure maximum confidentiality.\n\n• You can delete your account and data anytime, and it will be permanently removed from our servers.\n\nYour trust matters to us. That’s why we use the latest security practices to keep your personal information safe, so you can stay focused on your tasks without worrying about privacy.',
                    style: TextStyle(
                      fontFamily: googleFontNormal,
                      color: whiteColor,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10.h),
            Text('• Contact us:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse('https://github.com/om945'));
                    },
                    child: Image.asset(
                      "assets/image/github.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://www.linkedin.com/in/om-belekar-aab424326?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/image/LinkedIn_.png",
                      height: 30,
                      width: 30,
                    ),
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
