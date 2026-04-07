import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      var googleUser = await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }
}
