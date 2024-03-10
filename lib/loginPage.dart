import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:pickup/widgets/PickUpLogo.dart';

class LoginPage extends StatelessWidget {
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
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
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
                    // Implement your login logic
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
                  onPressed: () {
                    // Implement your Google sign-in logic
                  },
                ),
                SizedBox(height: 16),
                SignInButton(
                  Buttons.AppleDark,
                  text: "Continue with Apple",
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
