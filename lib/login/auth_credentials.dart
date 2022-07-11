// 1 AuthCredentials es una clase abstracta que usaremos para una línea de base de la información mínima necesaria destinada a iniciar sesión o registrarse. Esto nos permitirá usar LoginCredentials y SignUpCredentials casi indistintamente.
abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({required this.username, required this.password});
}

// 2 LoginCredentials es una implementación sencilla y concreta de AuthCredentials, ya que para iniciar sesión solo se necesita el nombre de usuario y la contraseña.
class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

// 3 Casi exactamente lo mismo que LoginCredentials pero con el correo electrónico como un campo adicional necesario para registrarse.
class SignUpCredentials extends AuthCredentials {
  final String email;

  SignUpCredentials(
      {required String username, required String password, required this.email})
      : super(username: username, password: password);
}
