import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? get user => _auth.currentUser;


  Future<void> signInWithGoogle() async {
    try { 
      final googleSignInAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);   
      if (user != null){ //TODO: Ensure this is secure.
        createUser(user!.displayName ?? "Anonymous", user!.email ?? "N/A", user!.uid);
      } else if(googleSignIn.currentUser != null && user == null){
        createUser(googleSignIn.currentUser!.displayName ?? "Anonymous", googleSignIn.currentUser!.email ?? "N/A", googleSignIn.currentUser!.id);
      }
    } catch (error) {
      Get.snackbar("Login Error", "Failed to sign in with Google");
      Logger().e(error);
      rethrow;
    }
  }

    Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      createUser(user!.displayName ?? "Anonymous", user!.email ?? "N/A", user!.uid);
    //TODO: ^Make sure to update when name or email updates. Also SetOptions(merge: true) when needed.
    
    } catch (e) {
      Get.snackbar("Login Error", "Failed to sign in with email and password"); 
      Logger().e(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  void createUser(String name, String email, String uid) {
    _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
    });
  }

}
