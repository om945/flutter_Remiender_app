import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthServices authService = AuthServices();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendOtp() {
    authService.forgotPassword(context: context, email: emailController.text);
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
                height: screeenHeight * 0.50,
                decoration: BoxDecoration(gradient: Grediants.gradient1),
              ),
              Positioned(
                top: screeenHeight * 0.14,
                right: 0,
                left: 0,
                child: Text(
                  'Forgot Password',
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Enter your email to receive a password reset OTP.',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: blackColor,
                              fontFamily: googleFontNormal,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Textfield(
                            controller: emailController,
                            lableText: 'Email',
                            hintText: 'Enter your email',
                            initialObscureText: false,
                          ),
                          SizedBox(height: 30.h),
                          Custombutton(title: 'Send OTP', action: sendOtp),
                          SizedBox(height: 10.h),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text('Back to Sign In'),
                            ),
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
      ),
    );
  }
}
