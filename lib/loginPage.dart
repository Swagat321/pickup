import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/home_page.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/widgets/PickUpLogo.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Center(
  //         child: Padding(
  //           padding: const EdgeInsets.all(50.0),
  //           child: Column(
  //             children: [
  //               PickUpLogo(),
  //               SizedBox(height: 48),
  //               const Text(
  //               'Please create an account or log in to continue.',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.grey,
  //               ),
  //             ),
  //             Center(
  //                   child: SignInButton(
  //           Buttons.GoogleDark,
  //           text: "Sign up with Google",
  //           onPressed: () {
  //             // Implement your Google sign-in logic
  //           },
  //                   ),
  //                 )],
  //           ),
  //         ),
  //       )
  //     )
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PickUpLogo(),
                SizedBox(height: 48),
                // Toggle switch for 'Create Account' and 'Log In' could be implemented here
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please create an account or log in to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // AuthService _authService = Get.find<AuthService>();
                    try {
                      // Trigger Email/Password Sign-In
                      print("Attempting to sign in with Email/Password");
                      AuthService().signInWithEmailAndPassword(
                        emailController.text,
                        passwordController.text,
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // );
                      print("After Sign in Attempt.");
                      Get.to(HomePage());
                    } catch (e) {
                      print('Error signing in with Email/Password: $e');
                    }
                  },
                  child: Text('Get Started'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                SizedBox(height: 16),
                Text('Or sign in with'),
                SizedBox(height: 16),
                SignInButton(
                  Buttons.GoogleDark,
                  text: "Continue with Google",
                  onPressed: () async {
                    // AuthService _authService = Get.find<AuthService>();
                    try {
                      // Trigger Google Sign-In
                      print("Attempting to sign in with Google");
                      await AuthService().signInWithGoogle();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // );
                      print("After Sign in Attempt.");
                    } catch (e) {
                      print('Error signing in with Google: $e');
                    }
                  },
                ),
                SizedBox(height: 16),
                SignInButton(
                  Buttons.AppleDark,
                  text: "(Coming Soon...)",
                  onPressed: () {
                    // Implement your Apple sign-in logic
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
