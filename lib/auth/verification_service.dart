import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';
import 'package:remiender_app/utils/enums.dart';

class OtpServiceField extends StatefulWidget {
  final String? email;
  final OtpPurpose purpose;
  const OtpServiceField({
    super.key,
    this.email,
    this.purpose = OtpPurpose.emailVerification,
  });

  @override
  State<OtpServiceField> createState() => _OtpServiceFieldState();
}

class _OtpServiceFieldState extends State<OtpServiceField> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final AuthServices authService = AuthServices();
  Timer? _timer;
  int _start = 60;
  bool _isResendButtonDisabled = false;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    setState(() {
      _isResendButtonDisabled = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendButtonDisabled = false;
          _start = 30;
        });
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void verifyOTP() async {
    if (widget.purpose == OtpPurpose.passwordReset) {
      authService.verifyResetOtp(
        context: context,
        email: widget.email?.toString() ?? _emailController.text,
        otp: _otpController.text,
      );
      _otpController.clear();
    } else {
      authService.verifyOTP(
        context: context,
        email: widget.email?.toString() ?? _emailController.text,
        otp: _otpController.text,
      );
    }
  }

  void resendOtp() {
    if (!_isResendButtonDisabled) {
      authService.reVerificationRequest(
        context: context,
        email: widget.email?.toString() ?? _emailController.text,
      );
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screeenWidth = MediaQuery.of(context).size.width;
    final screeenHeight = MediaQuery.of(context).size.height;
    final PinTheme otptheme = PinTheme(
      textStyle: TextStyle(
        fontFamily: googleFontSemiBold, // Assuming this is defined
        fontSize: 20.sp,
        color: whiteColor,
      ),
      height: 48.h,
      // width: 66.w,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none, color: blueColor),
        borderRadius: BorderRadius.circular(10.r),
        color: blackColor,
      ),
    );
    return Scaffold(
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
                  widget.purpose == OtpPurpose.passwordReset
                      ? 'Enter Password Reset OTP'
                      : 'Verify your account',
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
                        children: [
                          SizedBox(height: 15.h),
                          Text(
                            widget.purpose == OtpPurpose.passwordReset
                                ? 'A password reset OTP is sent to your ${widget.email != null ? "(${widget.email}) email" : "email"}'
                                : widget.email == null
                                ? 'Verification code is already sent to your email'
                                : 'Verification code is sent to your ${widget.email != null ? "(${widget.email}) email" : "email"}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: blackColor,
                              fontFamily: googleFontNormal,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if (widget.email == null)
                            Textfield(
                              lableText: 'Email',
                              hintText: 'Enter email',
                              controller: _emailController,
                              initialObscureText: false,
                            ),
                          SizedBox(height: 30.h),
                          Pinput(
                            length: 6,
                            controller:
                                _otpController, // Link Pinput to controller
                            focusNode:
                                _otpFocusNode, // Link Pinput to focus node
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            selectionControls: MaterialTextSelectionControls(),
                            defaultPinTheme: otptheme,
                            focusedPinTheme: otptheme.copyBorderWith(
                              border: Border.all(width: 2.w, color: blueColor),
                            ),
                            // Optional: Automatically verify when OTP is complete
                            onCompleted: (pin) => (verifyOTP()),
                          ),
                          SizedBox(height: 30.h),
                          Custombutton(title: 'Verify otp', action: verifyOTP),
                          SizedBox(height: 20.h),
                          if (widget.purpose == OtpPurpose.emailVerification)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive the code? ",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontFamily: googleFontNormal,
                                  ),
                                ),
                                TextButton(
                                  onPressed: resendOtp,
                                  child: Text(
                                    _isResendButtonDisabled
                                        ? 'Resend in $_start'
                                        : 'Resend Code',
                                    style: TextStyle(
                                      color: _isResendButtonDisabled
                                          ? Colors.grey
                                          : blueColor,
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
      ),
    );
  }
}
