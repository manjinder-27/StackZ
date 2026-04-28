import 'package:flutter/material.dart';
import 'package:stackz/mainwrapper.dart';
import 'package:stackz/pages/coursepage.dart';
import 'package:stackz/pages/lessoncompleted.dart';
import 'package:stackz/pages/loginpage.dart';
import 'package:stackz/pages/modulepage.dart';
import 'package:stackz/pages/progpage.dart';
import 'package:stackz/pages/reset2.dart';
import 'package:stackz/pages/signuppage.dart';
import 'package:stackz/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/login/forgotPassword': (context) => const ForgotPasswordPage(),
        '/signup': (context) => const SignupPage(),
        '/progress': (context) => const ProgressLoadingScreen(),
        '/home': (context) => const MainWrapper(),
        '/course': (context) => const CoursePage(),
        '/module': (context) => const ModulePage(),
        '/complete': (context) => const LessonCompletedPage(),
      },
    );
  }
}