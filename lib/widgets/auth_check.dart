import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:pickup/home_page.dart';
import 'package:pickup/loginPage.dart';
import 'package:pickup/services/auth_service.dart';

class AuthCheck extends StatelessWidget {
  var log = Logger();

  AuthCheck({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUser(), // function that returns Future<User>
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        log.t("AuthCheck: snapshot: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading spinner while waiting
        } else {
          if (snapshot.hasError) {
            Get.snackbar("Error", "Couldn't SignIn: ${snapshot.error}");
            return const LoginPage(); // Show LoginPage on error
          } else if (snapshot.data == null) {
            return const LoginPage(); // Show LoginPage if user is null
          } else {
            return const HomePage(); // Show HomePage if user is signed in
          }
        }
      },
    );
  }

  Future<User?> getUser() async {
    final authService = Get.find<AuthService>();
    log.t("AuthCheck: getUser: ${authService.user}");
    return authService.user;
  }
}
