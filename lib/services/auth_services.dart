import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/auth/verification_service.dart';
import 'package:remiender_app/models/user.dart';
import 'package:remiender_app/pages/home_page.dart';
import 'package:remiender_app/utils/constants.dart';
import 'package:remiender_app/utils/enums.dart';
import 'package:remiender_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:remiender_app/auth/reset_password_page.dart';

class AuthServices {
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        token: '',
        password: password,
      );
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return showSnackBar(context, 'Please fill all required fileds');
      }
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondryAnimation) =>
                  OtpServiceField(email: email),
              transitionDuration: Duration(microseconds: 200),
              transitionsBuilder:
                  (context, animation, scondaryAnimation, child) {
                    const begin = Offset(0, 1);
                    const end = Offset(0, 0);
                    const curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
            ),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //sign In
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (email.isEmpty || password.isEmpty) {
        return showSnackBar(context, 'All fields are required');
      }
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          userProvider.setUser(res.body);
          await pref.setString('x-auth-token', jsonDecode(res.body)['token']);
          navigator.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomeScreen(),
              transitionDuration: Duration(microseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1, 0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Forgot Password
  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/forgot-password'),
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password reset OTP sent to your email!');
          // Navigate to a new screen to enter OTP and new password
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpServiceField(
                email: email,
                purpose: OtpPurpose.passwordReset,
              ),
            ),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'User with this email does not exist!');
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/reset-password'),
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password reset successfully! Please sign in.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Verify Reset OTP
  Future<void> verifyResetOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/verify-reset-otp'),
        body: jsonEncode({'email': email, 'otp': otp}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'OTP verified successfully. You can now set your new password.',
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(email: email, otp: otp),
            ),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        await pref.setString('x-auth-token', '');
        return;
      }

      // Validate token
      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/api/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        // Fetch user data with the token
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/api/user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        if (userRes.statusCode == 200) {
          userProvider.setUser(userRes.body);
        } else {
          await pref.setString('x-auth-token', '');
        }
      } else {
        await pref.setString('x-auth-token', '');
      }
    } catch (e) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('x-auth-token', '');
      showSnackBar(context, 'Authentication error: ${e.toString()}');
    }
  }

  void signOutUser(BuildContext context) async {
    try {
      final navigator = Navigator.of(context);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('x-auth-token', '');
      userProvider.setUserFromModel(
        User(id: '', name: '', email: '', token: '', password: ''),
      );

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignupPage()),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Re-verification OTP
  Future<void> reVerificationRequest({
    required BuildContext context,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse(
          '${Constants.uri}/api/reverification',
        ), // Corrected typo from evaification to reverification
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (email.isEmpty) {
        showSnackBar(context, 'Please enter your email');
      }
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'A new verification code has been sent.');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> verifyOTP({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/verification'),
        body: jsonEncode({'email': email, 'code': otp}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'OTP Verified! You can now sign in.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
