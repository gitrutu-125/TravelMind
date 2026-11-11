
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _googleSignIn.initialize(
      serverClientId: '573922768112-pnbinqhimlnqkuv0citsbahip9emk9cg.apps.googleusercontent.com',
    );

    _initialized = true;
  }

  Future<String?> signInAndGetIdToken() async {
    await initialize();

    final GoogleSignInAccount account =
        await _googleSignIn.authenticate();

    final String? idToken = account.authentication.idToken;

    if (idToken == null) {
      throw Exception('Google did not return an ID token');
    }

    return idToken;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
