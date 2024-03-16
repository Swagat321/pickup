import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/chat_screen.dart';
import 'package:pickup/controllers/chat_controller.dart';
import 'package:pickup/home_page.dart';
import 'package:pickup/loginPage.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/chat_service.dart';
import 'package:pickup/services/game_service.dart';
import 'package:pickup/services/log.dart';

class AuthCheck extends StatelessWidget {

  const AuthCheck({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUser(), // function that returns Future<User>
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        Log.trace("AuthCheck: snapshot: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading spinner while waiting
        } else {
          if (snapshot.hasError) {
            Get.snackbar("Error", "Couldn't SignIn: ${snapshot.error}");
            return const LoginPage(); // Show LoginPage on error
          } else if (snapshot.data == null) {
            return const LoginPage(); // Show LoginPage if user is null
          } else {
            Get.put(ChatService()); //Must be put before ChatController.
            Get.put(ChatController());
            Get.put(GameService());
            return const HomePage(); // Show HomePage if user is signed in
          }
        }
      },
    );
  }

  Future<User?> getUser() async {
    final authService = Get.find<AuthService>();
    Log.trace("AuthCheck: getUser: ${authService.user}");
    return authService.user;
  }
}
