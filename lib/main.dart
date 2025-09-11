import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:remiender_app/theme/network_error.dart';
import 'package:remiender_app/theme/theme.dart';

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
  final Connectivity _connectivity = Connectivity();
  final AuthServices authService = AuthServices();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initialize();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initialize() async {
    // It's safer to wait for the first frame to be drawn before using context.
    await SchedulerBinding.instance.endOfFrame;
    if (!mounted) return;

    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    final newResult = result.contains(ConnectivityResult.none)
        ? ConnectivityResult.none
        : result.first;

    if (newResult != _connectivityResult) {
      if (mounted) {
        setState(() {
          _connectivityResult = newResult;
          _isInitializing = true; // Show loading indicator on reconnect
        });
      }

      if (_connectivityResult != ConnectivityResult.none) {
        // Using context safely after a frame.
        await authService.getUserData(context);
      }

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
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
        home: Builder(
          builder: (context) {
            if (_connectivityResult == ConnectivityResult.none) {
              return const NetworkError();
            }
            if (_isInitializing) {
              return const Scaffold(
                backgroundColor: blackColor,
                body: Center(
                  child: CircularProgressIndicator(color: blueColor),
                ),
              );
            }
            return Consumer<UserProvider>(
              builder: (context, userProvider, child) =>
                  userProvider.user.token.isEmpty
                  ? const SignupPage()
                  : const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}

//Notification service
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
