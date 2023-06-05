import 'package:flutter/material.dart';
//import 'package:flutter_firebase/screens/componentes/boton_login.dart';
import 'package:flutter_firebase/screens/componentes/textfield_login.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../credentials/credential.dart';

class login_Screen extends StatelessWidget {
  login_Screen({Key? key}) : super(key: key);

  // text editing controllers
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String name = "";
  String password = "";
  User? user;

  Future<void> signIn(String email, String password, Function callback) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      GlobalVariables.userCredential = userCredential;

      // El inicio de sesión fue exitoso
      user = userCredential.user;
      callback();
      // Realiza las acciones necesarias después del inicio de sesión exitoso
    } on FirebaseAuthException catch (e) {
      // Maneja los errores de inicio de sesión aquí
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToMenu() {
      Navigator.pushNamed(context, '/menu');
    }

    return Scaffold(
      backgroundColor: Color(0xfff8fef4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16.0, left: 40.0, right: 40.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Image.asset(
                  'assets/logo.png',
                  width: 280,
                  height: 280,
                ),
                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 25.0),
                TextFormField_login(
                    controller: _usernameController,
                    labelText: 'User',
                    obscureText: false,
                    valor: name),
                SizedBox(height: 16.0),
                TextFormField_login(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    valor: password),
                SizedBox(height: 25.0),
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/users');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),
                ),
                // SizedBox(height: 8.0),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     onTap: () {
                //       // Aquí puedes realizar la acción al hacer clic en el texto
                //       // Por ejemplo, navegar a la pantalla de registro
                //       Navigator.pushNamed(context, '/register');
                //     },
                //     child: Text(
                //       'Register new user',
                //       style: TextStyle(
                //         color: Colors.blue,
                //         decoration: TextDecoration.underline,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  child: Text('Sign in'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Realizar el registro
                      name = _usernameController.text;
                      password = _passwordController.text;

                      // Navigator.pushNamed(context, '/menu');
                      signIn(name, password, navigateToMenu);
                      // Aquí puedes realizar el registro utilizando la información del formulario
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff7a6a53),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
