import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/componentes/boton_login.dart';
import 'package:flutter_firebase/screens/componentes/textfield_login.dart';

class login_Screen extends StatelessWidget {
   
  login_Screen({Key? key}) : super(key: key);
    // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
      
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
      
                const SizedBox(height: 50),
      
                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
      
                const SizedBox(height: 25),
      
                // username textfield
                textfield_login(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
      
                const SizedBox(height: 10),
      
                // password textfield
                textfield_login(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
      
                const SizedBox(height: 10),
      
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 25),
      
                // sign in button
                boton_login(
                  onTap: ()=>Navigator.popAndPushNamed(context, '/users'),
                ),
      
                //const SizedBox(height: 50),
      
                // or continue with
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text(
                //           'Or continue with',
                //           style: TextStyle(color: Colors.grey[700]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
      
                // const SizedBox(height: 50),
      
                // // google + apple sign in buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     // google button
                //     SquareTile(imagePath: 'lib/images/google.png'),
      
                //     SizedBox(width: 25),
      
                //     // apple button
                //     SquareTile(imagePath: 'lib/images/apple.png')
                //   ],
                // ),
      
                // const SizedBox(height: 50),
      
                // // not a member? register now
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Not a member?',
                //       style: TextStyle(color: Colors.grey[700]),
                //     ),
                //     const SizedBox(width: 4),
                //     const Text(
                //       'Register now',
                //       style: TextStyle(
                //         color: Colors.blue,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}