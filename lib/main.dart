import 'package:flutter/material.dart';
import 'package:campus_life_hub/pages/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:campus_life_hub/pages/login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:campus_life_hub/pages/home.dart';
import 'package:campus_life_hub/pages/timetable/timetable_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_life_hub/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final notificationService = NotificationService();
  await notificationService.initFCM();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => TimetableState(),
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: seenOnboarding ? Login() : OnboardingScreen(),
      routes: {
        '/home': (context) => const Home(),
      },
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.notification?.title}');
  // You can handle the background message here
}