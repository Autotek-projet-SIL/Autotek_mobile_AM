// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:autotec/bloc/auth_bloc.dart';
import 'package:autotec/repositories/auth_repository.dart';

import 'package:autotec/Authentication/first_screens/home.dart';
import 'package:autotec/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'car_rental/cars_list.dart';


var userCred ;
var initScreen;

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call initializeApp before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  await Firebase.initializeApp();
  //Get permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  //Get Device token
  String token = (await FirebaseMessaging.instance.getToken())!;
  print('Tokenn: $token');
  //Listening to notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("==================================================================");
    print('                        La notification');
    print("==================================================================");
    print('Message data: ${message.notification?.title}');
    print('Message data: ${message.notification?.body}');
    print("==================================================================");
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  UserCredentials.setDeviceToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'poppins'),
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in.
                if (snapshot.hasData) {
                  return  CarsList();
                }else{
                  return const Home();
                }

              }),
        ),
      ),
    );
  }
}
