import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/discoverPage.dart';
import 'package:pickup/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pickup/loginPage.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/widgets/auth_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  Get.put(AuthService());
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
      home: AuthCheck(),
    );
  }

  Future<bool> checkLoginState() async {
    // check if user is logged in
    return true;
  }

}
