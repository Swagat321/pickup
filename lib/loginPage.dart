import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:pickup/home_page.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/widgets/PickUpLogo.dart';
import 'package:pickup/widgets/auth_check.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = Get.find<AuthService>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PickUpLogo(),
                const SizedBox(height: 48),
                // Toggle switch for 'Create Account' and 'Log In' could be implemented here
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Once you log in, please quit the app and open again. There\'s a bug.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email (coming soon...)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password (use google or apple for now)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: null,
      //             onPressed: () {
      //               try {
      //                 // Trigger Email/Password Sign-In
      //                 _authService.signInWithEmailAndPassword( //TODO: Ask for Username and maybe picture?
      //                   emailController.text,
      //                   passwordController.text,
      //                 );
      //                 Get.to(() => const HomePage());
      //               } catch (e) {
      // Get.snackbar("Login Error", "Failed to sign in with email and password"); 
      //               }
      //             },
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Get Started'),
                ),
                const SizedBox(height: 16),
                const Text('Or sign in with'),
                const SizedBox(height: 16),
                SignInButton(
                  Buttons.GoogleDark,
                  text: "Continue with Google",
                  onPressed: () async {
                    try {
                      // Trigger Google Sign-In
                      await _authService.signInWithGoogle();
                      // Get.snackbar("Known Bug Incomming", "Please quit the app and open again to avoid a bug.");
                      Get.off(const AuthCheck());
                    } catch (e) {
      Get.snackbar("Login Error", "Failed to sign in with Google");
                    }
                  },
                ),
                const SizedBox(height: 16),
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
