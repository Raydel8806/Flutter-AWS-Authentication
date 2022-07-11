import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'auth_credentials.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowSignUp;

  const LoginPage(
      {Key? key,
      required this.shouldShowSignUp,
      required this.didProvideCredentials})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1 Dado que LoginPage requiere la entrada del usuario, tenemos que controlar ese estado con un TextEditingController para cada campo en la pantalla, en este caso, nombre de usuario y contraseña.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 2 _LoginPageState.build devolverá un widget Scaffold que permitirá que nuestros widgets puedan formatearse correctamente para un dispositivo móvil.
    return Scaffold(
      // 3 Es importante tener en cuenta el widget SafeArea, ya que la aplicación podrá ejecutarse en varios dispositivos. En este caso, también aprovechamos las inserciones de borde mínimo destinadas a agregar relleno en los lados izquierdo y derecho de la pantalla para que el formulario de inicio de sesión no sea de borde a borde.
      body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 40),
          // 4 Nuestra UI consistirá en el formulario de inicio de sesión principal y un botón en la parte inferior de la pantalla que permitirá al usuario registrarse en lugar de iniciar sesión. Aquí usamos una pila para facilitar la manipulación de la ubicación de cada widget secundario.
          child: Stack(children: [
            // Login Form
            _loginForm(),

            // 6 El botón de registro tendrá la forma de una oración interactiva que permitirá al usuario registrarse si aún no tiene una cuenta. Aún no se ha implementado ninguna funcionalidad onPressed.
            // Sign Up Button
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: widget.shouldShowSignUp,
                  child: const Text('Don\'t have an account? Sign up.')),
            )
          ])),
    );
  }

  // 5 Crear una función _loginForm es completamente opcional, pero ordena un poco el método de construcción. Aquí implementamos la UI para los campos de texto de nombre de usuario y contraseña, así como el botón de inicio de sesión.
  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
              icon: Icon(Icons.mail), labelText: 'Username'),
        ),

        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        // 7 Login Button
        ElevatedButton(onPressed: _login, child: const Text('Login'))
      ],
    );
  }

  // 7 El método _login extraerá los valores de los controladores de campo de texto y creará un objeto AuthCredentials. En este momento solo imprime los valores de cada controlador.
  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (kDebugMode) {
      print('username: $username');
    }
    if (kDebugMode) {
      print('password: $password');
    }
    final credentials =
        LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
  }
}
