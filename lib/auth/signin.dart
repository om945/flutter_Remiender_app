import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/auth/signup.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final email = TextEditingController();
  final password = TextEditingController();
  final AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    void loginUser() {
      authService.signInUser(
        context: context,
        email: email.text,
        password: password.text,
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: bgColor,
      forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                  color: blueColor,
                  fontSize: 28.sp,
                  fontFamily: googleFontBold,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 50.h),
              Textfield(
                lableText: 'Enter email',
                hintText: 'email',
                controller: email,
                obscureText: false,
              ),
              SizedBox(height: 10.h),
              Textfield(
                lableText: 'Enter password',
                hintText: 'password',
                controller: password,
                obscureText: true,
              ),
              SizedBox(height: 5.h),
              InkWell(
                onTap: () {},
                child: Text(
                  'Forgat password',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: whiteColor,
                    fontFamily: googleFontFaintNormal,
                  ),
                ),
              ),
              SizedBox(height: 80.h),
              Custombutton(title: 'Sign In', action: loginUser),
            ],
          ),
        ),
      ),
    );
  }
}
