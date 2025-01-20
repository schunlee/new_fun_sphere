import 'package:firebase_auth/firebase_auth.dart' as fauth;

class AuthService {
  static AuthService? _instance;
  AuthService._();
  factory AuthService() => _instance ??= AuthService._();

  final fauth.FirebaseAuth _auth = fauth.FirebaseAuth.instance;

  Stream<fauth.User> authStateChanges() async* {
    _auth.authStateChanges();
  }

  Future<fauth.UserCredential> createUser(
    // 注册
      String name, String email, String password) async {
    fauth.UserCredential authResult =
        await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
    print(authResult);
    return authResult;
  }

  Future<fauth.UserCredential> login(String email, String password) async {
    // 登录
    fauth.UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
    return authResult;
  }

  Future<void> signOut() async {
    // 退出登录
    await _auth.signOut();
  }
}
