import 'package:awsauthentication/login/sign_up_page.dart';
import 'package:flutter/material.dart';

import 'core/camera_flow.dart';
import 'login/auth_service.dart';
import 'login/login_page.dart';
import 'login/verification_page.dart';

void main() {
  runApp(const MyApp());
}

// 1 Hemos cambiado el widget MyApp por StatefulWidget. Más adelante nos encargaremos de su estado.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _authService.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      // 2 El widget de inicio de nuestra MaterialApp es un navegador que permitirá configurar nuestra navegación de forma declarativa.

      // 1 Envolvimos el navegador con un StreamBuilder que espera observar un stream que emita AuthState.
      home: StreamBuilder<AuthState>(
          // 2 Accedemos al stream AuthState desde authStateController de la instancia de AuthService.
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3 El stream puede o no tener datos. Para acceder de forma segura a authFlowStatus desde los datos, que son de tipo AuthState, primero implementamos la verificación aquí.
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4 Si el stream emite AuthFlowStatus.login, mostraremos LoginPage.
                  // Show Login Page
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                      didProvideCredentials: _authService.loginWithCredentials,
                      shouldShowSignUp: _authService.showSignUp,
                    )),

                  // 5 Si el stream emite AuthFlowStatus.singUp, mostraremos SignUpPage.
                  // Show Sign Up Page
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
                      didProvideCredentials: _authService.signUpWithCredentials,
                      shouldShowLogin: _authService.showLogin,
                    )),
                  // Show Verification Code Page
                  if (snapshot.data?.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        child: VerificationPage(
                      didProvideVerificationCode: _authService.verifyCode,
                    )),

                  // Show Camera Flow
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        child: CameraFlow(
                            shouldLogOut: _authService.logOut, key: widget.key))
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6 Si el stream no tiene datos, se muestra un CircularProgressIndicator.
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
