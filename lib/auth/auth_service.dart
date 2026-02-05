import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN UP
  Future<User> signUp({ required String email, required String password}) async {

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  // LOGIN
  Future<User?> signIn({ required String email, required String password }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // LOGOUT
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // AUTH STATE
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
