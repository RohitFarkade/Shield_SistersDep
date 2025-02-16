
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:shield_sister_2/new_pages/newhelplinepage.dart";
import "package:shield_sister_2/pages/BottomNavigation.dart";
import "package:shield_sister_2/pages/SS_ContentaPage.dart";
import "package:shield_sister_2/pages/loginpage.dart";
import "package:shield_sister_2/pages/prot1_OnboardingScreen.dart";
import "package:shield_sister_2/pages/registerpage.dart";
import 'firebase_options.dart';
import 'package:shield_sister_2/pages/myapp.dart';
import 'new_pages/MyMap.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeLocalNotifications() {
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: "email.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Cloud Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions (for iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // initializeLocalNotifications();

  runApp(MaterialApp(
    debugShowMaterialGrid: false,
    home: MyLogin(),
    color: Colors.amber,
    debugShowCheckedModeBanner: false,
    routes: {
      "/bot": (context) => const FinalView(),
      "/int": (context) =>  OnboardingScreen(),
      "/reg": (context) => const RegisterPage(),
      "/log": (context) => const MyLogin(),
      "/home": (context) => const MyApp(),
      "/redirect": (context) => RedirectPage(),
      "/helpline": (context) => const newHelplinePage(),

    },
  ));
}

