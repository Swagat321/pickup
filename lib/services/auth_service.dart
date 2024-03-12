import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<User?> _firebaseUser = Rx<User?>(null);

  User? get user => _firebaseUser.value;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _firebaseUser.bindStream(_auth.authStateChanges());
  // }

  Future<void> signInWithGoogle() async {
    try { 
      print("AuthService1");
      final googleSignInAccount = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      print("AuthService2");
      await _auth.signInWithCredential(credential);
      print("AuthService3");
      
    } catch (error) {
      print(error);
      Get.snackbar("Login Error", "Failed to sign in with Google: $error");
    }
  }

    Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      print("AuthService attempting email sign in");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error signing in with email and password: $e");
      rethrow;
      //Create new user?
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
