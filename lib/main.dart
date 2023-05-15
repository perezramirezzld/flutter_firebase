import 'package:flutter/material.dart';
//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/screens/general/login_screen.dart';
import 'package:flutter_firebase/screens/menu_screen.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/screens/user/updateuser_screen.dart';
import 'package:flutter_firebase/screens/user/user_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/menu': (context) => menuscreen(),
        '/updateProduct': (context) => const upproduct(),
        '/products':(context) =>  productscreen(),
        '/login':(context) =>  login_Screen(),
        '/users':(context) => user_screen(),
        '/updateUser':(context) => update_user(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: "/menu",
    );
  }
}
