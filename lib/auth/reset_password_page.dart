import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';
import 'package:remiender_app/utils/utils.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordPage({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final AuthServices authService = AuthServices();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  void resetPassword() {
    if (newPasswordController.text != confirmNewPasswordController.text) {
      showSnackBar(context, 'Passwords do not match!');
      return;
    }
    authService.resetPassword(
      context: context,
      email: widget.email,
      otp: widget.otp,
      newPassword: newPasswordController.text,
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
                height: screeenHeight * 0.50,
                decoration: BoxDecoration(gradient: Grediants.gradient1),
              ),
              Positioned(
                top: screeenHeight * 0.14,
                right: 0,
                left: 0,
                child: Text(
                  'Set New Password',
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
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Container(
                    width: screeenWidth,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 15.h),
                          Text(
                            'Set your new password for ${widget.email}.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: blackColor,
                              fontFamily: googleFontNormal,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Textfield(
                            controller: newPasswordController,
                            lableText: 'New Password',
                            hintText: 'Enter new password',
                            initialObscureText: true,
                          ),
                          SizedBox(height: 10.h),
                          Textfield(
                            controller: confirmNewPasswordController,
                            lableText: 'Confirm New Password',
                            hintText: 'Confirm new password',
                            initialObscureText: true,
                          ),
                          SizedBox(height: 30.h),
                          Custombutton(
                            title: 'Reset Password',
                            action: resetPassword,
                          ),
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
