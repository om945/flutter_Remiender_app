import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/Provider/notes_provider.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/pages/home_page.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
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
  bool _isLoading = true;

  void _initializeUser() async {
    await authService.getUserData(context);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // We call getUserData after the first frame has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });
  }

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
        home: _isLoading
            ? const Scaffold(
                backgroundColor: blackColor,
                body: Center(
                  child: CircularProgressIndicator(color: blueColor),
                ),
              )
            : Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return userProvider.user.token.isEmpty
                      ? const SignupPage()
                      : const HomeScreen();
                },
              ),
      ),
    );
  }
}
