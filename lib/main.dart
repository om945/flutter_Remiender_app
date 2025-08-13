import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/pages/home_screen.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvideer())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authService = AuthServices();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Don't call getUserData here - context is not available yet
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData baseDark = ThemeData.dark();
    return ScreenUtilInit(
      designSize: const Size(353, 745),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: baseDark.copyWith(
          scaffoldBackgroundColor: bgColor,
          canvasColor: bgColor,
          colorScheme: baseDark.colorScheme.copyWith(
            // ignore: deprecated_member_use
            background: bgColor,
            surface: bgColor,
            primary: blueColor,
            secondary: blueColor,
          ),
          appBarTheme: baseDark.appBarTheme.copyWith(
            backgroundColor: bgColor,
            elevation: 0,
          ),
        ),
        home: Consumer<UserProvideer>(
          builder: (context, userProvider, child) {
            // Only call getUserData once when the app initializes
            if (!_isInitialized) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _isInitialized = true;
                authService.getUserData(context);
              });
            }
            // Show loading indicator while checking authentication
            if (!_isInitialized) {
              return const Scaffold(
                backgroundColor: blackColor,
                body: Center(
                  child: CircularProgressIndicator(color: blueColor),
                ),
              );
            }

            return userProvider.user.token.isEmpty
                ? SignupPage()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
