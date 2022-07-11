import 'dart:async';

import 'auth_credentials.dart';

// 1 AuthFlowStatus es una enumeración que cubrirá los cuatro estados que puede tener nuestro flujo de autenticación: la página de inicio de sesión, la página de registro, la página de verificación o una sesión. Pronto agregaremos las últimas dos páginas.
enum AuthFlowStatus { login, signUp, verification, session }

// 2 AuthState es el objeto que observaremos en nuestro stream y contendrá authFlowStatus como propiedad.
class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

// 3 Nuestro AuthService tendrá dos propósitos, administrar el controlador de streams de AuthState y contener toda la funcionalidad de autenticación que se agregará en el siguiente módulo.
class AuthService {
  // 4 authStateController se encarga de enviar nuevos AuthState para su control.
  final authStateController = StreamController<AuthState>();

  // 5 Esta es una función simple para actualizar el stream de AuthState para signUp.
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  // 6 Esto hace lo mismo que showSignUp, pero actualiza el stream para enviar el inicio de sesión.
  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  // 1 Cuando un usuario pasa una AuthCredential, realizaremos algo de lógica y finalmente pondremos al usuario en estado de sesión.
  void loginWithCredentials(AuthCredentials credentials) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

// 2 El registro requerirá la verificación del correo electrónico ingresado y para eso deberá ingresarse un código de verificación. Por lo tanto, la lógica de registro debería cambiar el estado a verificación.
  void signUpWithCredentials(SignUpCredentials credentials) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
    authStateController.add(state);
  }

  void verifyCode(String verificationCode) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

  void logOut() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }
}
