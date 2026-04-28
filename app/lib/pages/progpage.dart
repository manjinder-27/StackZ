import 'package:flutter/material.dart';
import 'package:stackz/services/network_service.dart';
import 'package:toastification/toastification.dart';

class ProgressLoadingScreen extends StatefulWidget {

  const ProgressLoadingScreen({super.key});

  @override
  State<ProgressLoadingScreen> createState() => _ProgressLoadingScreenState();
}

class _ProgressLoadingScreenState extends State<ProgressLoadingScreen> {
  final _loadingText = "Just few seconds...";

  // This mimics the time taken for Django to respond and for Flutter to load assets
  void _callloginfunc(String username,String password) async {
    await Future.delayed(const Duration(seconds: 2));
    int res = await NetworkService.authenticateUser(username, password);
    if (res == 200) {
      toastification.show(
        context: context,
        title: Text('Login Successful'),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      _navigateToHome();
    } else if (res == 429) {
      toastification.show(
        context: context,
        title: Text('Try Again Later !'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      _back();
    }else if (res == 401) {
      toastification.show(
        context: context,
        title: Text('Invalid Credentials !'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      _back();
    }else {
      toastification.show(
        context: context,
        title: Text('An Error Occured, Try Again !'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      _back();
    }
  }

  void _back() {
    Navigator.pop(context);
  }

  void _callsignupfunc(String username,String password,String fullname,String email) async {
    await Future.delayed(const Duration(seconds: 2));
    int res = await NetworkService.registerUser(username, password,fullname,email);
    if (res == 201) {
      toastification.show(
        context: context,
        title: Text('Account Created Successfully'),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      _navigateToLogin();
    } else {
      toastification.show(
        context: context,
        title: Text('An Error Occured, Try Again !'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      _back();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final isSignUp = args['signup'] != null ? true : false;
    if (isSignUp){
      _callsignupfunc(args['username']!,args['password']!,args['name']!,args['email']!);
    }else{
      _callloginfunc(args['username']!,args['password']!);
    }
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // Matching your theme
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Coding Icon
            const Icon(Icons.code_rounded, size: 80, color: Colors.white),
            const SizedBox(height: 40),

            Text(
              isSignUp ? "Creating Your Profile" : "Welcome Back!",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              _loadingText,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),

            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
