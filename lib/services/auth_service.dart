import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._(); //constructor privado para realizar el singleton
  //genera una unica instancia de la clase con static final.
  static final AuthService instance = AuthService._();

  //nos ahorramos poner el .instance a cada rato
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //inicializado en null
  Future<void>? _initFuture;

  Future<void> _ensureInitialized() {
    return _initFuture ??= _googleSignIn.initialize();
    //si es null se inicializa, este codigo asegura que no hayan dos inicializaciones
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _ensureInitialized();
      //autentica con google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      //genera token una vez iniciada la sesion
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) throw Exception('Error al Iniciar sesión en Google');
      //entrega la credencial de google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      return await _auth.signInWithCredential(
        credential,
      ); //nos retorna la data del usuario autenticado
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
