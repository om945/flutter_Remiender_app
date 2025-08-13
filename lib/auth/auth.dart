import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

// 1. Converted to a StatefulWidget
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 2. State variable to track the view
  bool _isSignupView = true;

  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthServices authService = AuthServices();

  @override
  void dispose() {
    // Clean up controllers
    userName.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void signupUser() {
    authService.signUpUser(
      context: context,
      email: email.text,
      password: password.text,
      name: userName.text,
    );
  }

  // 3. Added a function for signing in
  void signinUser() {
    // Make sure you have a `signInUser` method in your AuthServices class
    authService.signInUser(
      context: context,
      email: email.text,
      password: password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screeenWidth = MediaQuery.of(context).size.width;
    final screeenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screeenHeight,
          child: Stack(
            children: [
              Container(
                width: screeenWidth,
                height: screeenHeight * 0.45,
                decoration: BoxDecoration(color: blueColor),
              ),
              _isSignupView
                  ? Positioned(
                      top: screeenHeight * 0.14,
                      right: 0,
                      left: 0,
                      child: Text(
                        'Hello...\nCreate an Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blackColor,
                          fontFamily: googleFontBold,
                          fontSize: 30.sp,
                        ),
                      ),
                    )
                  : Positioned(
                      top: screeenHeight * 0.14,
                      right: 0,
                      left: 0,
                      child: Text(
                        'Welcome back!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blackColor,
                          fontFamily: googleFontBold,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
              Positioned(
                top: screeenHeight * 0.25, // Adjusted top position
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: screeenWidth,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 4. Toggle Button UI
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: blueColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSignupView = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _isSignupView
                                            ? blueColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: _isSignupView
                                                ? blackColor
                                                : faintwhiteColor,
                                            fontFamily: googleFontSemiBold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSignupView = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !_isSignupView
                                            ? blueColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: !_isSignupView
                                                ? blackColor
                                                : faintwhiteColor,
                                            fontFamily: googleFontSemiBold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // 5. Conditional UI for Username field
                          if (_isSignupView)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Textfield(
                                  controller: userName,
                                  lableText: "Enter username",
                                  hintText: "username",
                                  obscureText: false,
                                ),
                                SizedBox(height: 8.h),
                              ],
                            ),
                          Textfield(
                            controller: email,
                            lableText: "Enter email",
                            hintText: "email",
                            obscureText: false,
                          ),
                          SizedBox(height: 8.h),
                          Textfield(
                            controller: password,
                            lableText: "Enter password",
                            hintText: "password",
                            obscureText: true,
                          ),
                          SizedBox(height: 30.h),
                          Custombutton(
                            title: _isSignupView ? 'Sign Up' : 'Sign In',
                            action: _isSignupView ? signupUser : signinUser,
                          ),

                          // 7. The old navigation row is removed.
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// No changes needed for these widgets below

//Textfield
class Textfield extends StatelessWidget {
  final String lableText;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const Textfield({
    super.key,
    required this.lableText,
    required this.hintText,
    required this.controller,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lableText,
          style: TextStyle(
            color: bgColor,
            fontFamily: googleFontSemiBold,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        TextFormField(
          obscureText: obscureText,
          obscuringCharacter: '•',
          controller: controller,
          cursorColor: blueColor,
          style: TextStyle(
            fontSize: 14.sp,
            color: bgColor,
            fontFamily: googleFontFaintNormal,
            fontWeight: FontWeight.w600,
          ),
          cursorWidth: 2.w,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: faintwhiteColor),
            ),
            hintText: hintText,
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
      ],
    );
  }
}

// button
class Custombutton extends StatelessWidget {
  final String title;
  final VoidCallback action;

  const Custombutton({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialButton(
      color: blueColor,
      height: 40.h,
      minWidth: screenWidth,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      onPressed: action,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontFamily: googleFontSemiBold,
          color: blackColor,
        ),
      ),
    );
  }
}
