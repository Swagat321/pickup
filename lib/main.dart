import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/gamePage.dart';
import 'package:pickup/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: FutureBuilder(
    //     future: checkLoginState(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator(); // or some splash screen
    //       } else {
    //         if (snapshot.data) {
    //           return HomePage();
    //         } else {
    //           return LoginPage();
    //         }
    //       }
    //     },
    //   ),
    // );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }

  Future<bool> checkLoginState() async {
    // check if user is logged in
    return true;
  }

}
