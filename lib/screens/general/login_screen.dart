import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/componentes/boton_login.dart';
import 'package:flutter_firebase/screens/componentes/textfield_login.dart';

class login_Screen extends StatelessWidget {
  login_Screen({Key? key}) : super(key: key);
  // text editing controllers
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String name = "a";
  String password = "a";

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 32.0),
                ElevatedButton(
                  child: Text('Sing in'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Realizar el registro
                      name = _usernameController.text;
                      password = _passwordController.text;
                      Navigator.pushNamed(context, '/menu');
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
