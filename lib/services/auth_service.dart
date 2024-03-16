import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickup/models/user.dart' as my;
import 'package:pickup/services/log.dart';

class AuthService extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? get user => auth.currentUser;
  my.User? myUser; //Ensure this is fine.

  @override
  void onInit() {
    super.onInit();
    auth.authStateChanges().listen((User? user) async {
      Log.info("AuthService: onInit: authStateChanges: user: $user");
      if (user != null) {
        myUser = await getUser(user.uid);
        Log.info("myUser initialized: $myUser");
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      final bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        Log.info("New User: ${userCredential.user!.displayName}");
        myUser = await createUser(
          id: userCredential.user!.uid,
          userName: userCredential.user!.displayName ?? "Anonymous",
          email: userCredential.user!.email,
          phoneNumber: userCredential.user!.phoneNumber,
          ranking: 0,
          avatarUrl: userCredential.user!.photoURL,
          location: null,
          chatIds: [],
        );
      } else {
        Log.info("Existing User: ${userCredential.user!.displayName}");
        myUser = await getUser(user!.uid);
      }

      // if (user != null) {
      //   await createUser(
      //     id: user!.uid,
      //     userName: user!.displayName ?? "Anonymous",
      //     email: user!.email,
      //     phoneNumber: user!.phoneNumber,
      //     // You can add default values for the other parameters if they are not available in the user object
      //     ranking: 0,
      //     avatarUrl: user!.photoURL,
      //     location: null,
      //     chatIds: [],
      //   );
      // } else if (googleSignIn.currentUser != null && user == null) {
      //   // createUser(googleSignIn.currentUser!.displayName ?? "Anonymous", googleSignIn.currentUser!.email ?? "N/A", googleSignIn.currentUser!.id);
      //   Log.wtf("AuthService: signInWithGoogle: ",
      //       "Firebase Auth Instance User is null but googleSignIn.currentUser is not null. Shouldn't happen.");
      // }
    } catch (error) {
      Log.error("signInWithGoogle() in AuthService", error);
      rethrow;
    }
  }

//   Future<void> signInWithEmailAndPassword(String email, String password) async { //TODO later: Need to check if user already exists then proceed with sign in or sign up.
//     try {

//       String email = 'user@example.com';
// try {
//   final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email); //Deprecated.

//   if (signInMethods.contains('google.com')) {
//     // The email is associated with Google Sign-In
//   } else if (signInMethods.contains('apple.com')) {
//     // The email is associated with Apple Sign-In
//   } else if (signInMethods.isEmpty) {
//     // No account exists for this email, you can prompt for account creation
//   } else {
//     // Handle other sign-in methods or generic sign-in
//   }
// } catch (e) {
//   // Handle errors, such as network issues or invalid emails
// }

//       // await FirebaseAuth.instance
//       //     .signInWithEmailAndPassword(email: email, password: password);
//       // if (user != null) {
//       //   await createUser(
//       //     id: user!.uid,
//       //     userName: user!.displayName ?? "Anonymous",
//       //     email: user!.email,
//       //     phoneNumber: user!.phoneNumber,
//       //     // You can add default values for the other parameters if they are not available in the user object
//       //     ranking: 0,
//       //     avatarUrl: user!.photoURL,
//       //     location: null, //These values will need to be updated:
//       //     chatIds: [],
//       //   );
//       // }
//       //TODO: ^Make sure to update when name or email updates. Also SetOptions(merge: true) when needed.
//     } catch (e) {
//       Log.error(e);
//       rethrow;
//     }
//   }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }

  Future<my.User> createUser({
    //TODO: Show a sign up page to prompt for fields to update.
    required String id,
    required String userName,
    String? email,
    String? phoneNumber,
    double? ranking,
    String? avatarUrl,
    String? location,
    List<String>? chatIds,
  }) async {
    try {
      await _firestore.collection('users').doc(id).set({
        'id': id,
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'ranking': ranking,
        'avatarUrl': avatarUrl,
        'location': location,
        'chatIds': chatIds,
      });
      return my.User(
        id: id,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        ranking: ranking,
        avatarUrl: avatarUrl,
        location: location,
        chatIds: chatIds,
      );
    } catch (e) {
      Log.error('Failed to create user in Firestore:', e);
      rethrow; // Re-throw the exception to allow the caller to handle it
    }
  }

  Future<my.User> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Log.info(userDoc.data());
        return my.User.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  void init() {}
}
