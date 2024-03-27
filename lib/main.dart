import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/web.dart';
import 'package:pickup/chat_screen.dart';
import 'package:pickup/controllers/chat_controller.dart';
import 'package:pickup/example_page.dart';
import 'package:pickup/loginPage.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/chat_service.dart';
import 'package:pickup/services/log.dart';
import 'package:pickup/widgets/auth_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Log.init(Level.all);
  Get.put(AuthService());
  // Get.find<AuthService>().onInit(); redundant but not harmful.
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // static const platform = MethodChannel('com.pickup/deeplink');

  // @override
  // void initState() {
  //   super.initState();
  //   platform.setMethodCallHandler(_handleMethod);
  // }

  // Future<dynamic> _handleMethod(MethodCall call) async {
  //   switch (call.method) {
  //     case "openPage":
  //       final String link = call.arguments;
  //       final Uri uri = Uri.parse(link);
  //       final String gameId = uri.queryParameters['gameId'] ?? "No Game ID";
  //       Get.to(ExamplePage(text: gameId));
  //       break;
  //   }
  // }

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
      home: const AuthCheck(),
    );
  }
}
