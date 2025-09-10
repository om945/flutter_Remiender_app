import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/Provider/notes_provider.dart';
import 'package:remiender_app/Provider/todo_provider.dart';
import 'package:remiender_app/auth/auth.dart';
import 'package:remiender_app/pages/home_page.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ); // Changed from 'app_icon' to 'ic_launcher'

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Create a notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'todo_reminders', // id
      'Todo Reminders', // title
      description: 'Notifications for your todo list reminders', // description
      importance: Importance.max,
    );

    // Request notification permissions for Android 13+
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    // Request exact alarm permission for Android 12+.
    // Note: This will open the app settings if the permission is not granted.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
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
