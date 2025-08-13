import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/auth/signin.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    final screeenWidth = MediaQuery.of(context).size.width;
    final screeenHeight = MediaQuery.of(context).size.height;

    void signupUser() {
      authService.signUpUser(
        context: context,
        email: email.text,
        password: password.text,
        name: userName.text,
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      // appBar: AppBar(backgroundColor: bgColor),
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
              Positioned(
                top: screeenHeight * 0.25,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: screeenWidth,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Create your account',
                          //   style: TextStyle(
                          //     color: blueColor,
                          //     fontSize: 28.sp,
                          //     fontFamily: googleFontBold,
                          //   ),
                          //   textAlign: TextAlign.start,
                          // ),
                          // SizedBox(height: 50.h),
                          Textfield(
                            controller: userName,
                            lableText: "Enter username",
                            hintText: "username",
                            obscureText: false,
                          ),
                          SizedBox(height: 5.h),
                          Textfield(
                            controller: email,
                            lableText: "Enter email",
                            hintText: "email",
                            obscureText: false,
                          ),
                          SizedBox(height: 10.h),
                          Textfield(
                            controller: password,
                            lableText: "Enter password",
                            hintText: "password",
                            obscureText: true,
                          ),
                          SizedBox(height: 50.h),
                          Custombutton(title: 'Sign Up', action: signupUser),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: bgColor,
                                  fontFamily: googleFontNormal,
                                  fontSize: 15.sp,
                                ),
                              ),
                              InkWell(
                                canRequestFocus: false,
                                enableFeedback: false,
                                splashColor: Colors.black,
                                focusColor: Colors.black,
                                borderRadius: BorderRadius.circular(15.r),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SigninPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  " Sign In",
                                  style: TextStyle(
                                    color: bgColor,
                                    fontFamily: googleFontNormal,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.all(25.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Create your account',
        //         style: TextStyle(
        //           color: blueColor,
        //           fontSize: 28.sp,
        //           fontFamily: googleFontBold,
        //         ),
        //         textAlign: TextAlign.start,
        //       ),
        //       SizedBox(height: 50.h),
        //       Textfield(
        //         controller: userName,
        //         lableText: "Enter username",
        //         hintText: "username",
        //         obscureText: false,
        //       ),
        //       SizedBox(height: 10.h),
        //       Textfield(
        //         controller: email,
        //         lableText: "Enter email",
        //         hintText: "email",
        //         obscureText: false,
        //       ),
        //       SizedBox(height: 10.h),
        //       Textfield(
        //         controller: password,
        //         lableText: "Enter password",
        //         hintText: "password",
        //         obscureText: true,
        //       ),
        //       SizedBox(height: 80.h),
        //       Custombutton(title: 'Sign Up', action: signupUser),
        //       SizedBox(height: 8.h),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             "Already have an account?",
        //             style: TextStyle(
        //               color: whiteColor,
        //               fontFamily: googleFontNormal,
        //               fontSize: 15.sp,
        //             ),
        //           ),
        //           InkWell(
        //             canRequestFocus: false,
        //             enableFeedback: false,
        //             splashColor: Colors.black,
        //             focusColor: Colors.black,
        //             borderRadius: BorderRadius.circular(15.r),
        //             onTap: () {
        //               Navigator.of(context).push(
        //                 MaterialPageRoute(builder: (context) => SigninPage()),
        //               );
        //             },
        //             child: Text(
        //               " Sign In",
        //               style: TextStyle(
        //                 color: whiteColor,
        //                 fontFamily: googleFontNormal,
        //                 fontSize: 15.sp,
        //                 fontWeight: FontWeight.w700,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(30.r),
      ),
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
