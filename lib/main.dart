import 'package:flutter/material.dart';
//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/controller/data_controller.dart';
import 'package:flutter_firebase/screens/general/login_screen.dart';
import 'package:flutter_firebase/screens/menu_screen.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/screens/purchase/addPurchase_screen.dart';
import 'package:flutter_firebase/screens/purchase/purchase_screen.dart';
import 'package:flutter_firebase/screens/purchase/updatePurchase_screen.dart';
import 'package:flutter_firebase/screens/sale/sale_screen.dart';
import 'package:flutter_firebase/screens/general/splash.dart';
import 'package:flutter_firebase/screens/sale/upSale_screen.dart';
import 'package:flutter_firebase/screens/user/adduser_screen.dart';
import 'package:flutter_firebase/screens/user/updateuser_screen.dart';
import 'package:flutter_firebase/screens/user/user_screen.dart';
import 'firebase_options.dart';
import 'screens/product/addproduct_screen.dart';
import 'screens/sale/addSale_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DataController().onInit();
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
        '/login': (context) => login_Screen(),
        '/menu': (context) => menuscreen(),
        '/products': (context) => productscreen(),
        '/purchases': (context) => purchasescreen(),
        '/users': (context) => userscreen(),
        '/sales': (context) => salescreen(),
        //add
        '/addProduct': (context) => addproduct(),
        '/addPurchase': (context) => addpurchase(),
        '/addSale': (context) => addsalescreen(),
        '/addUser': (context) => adduser(),
        //update
        '/updateUser': (context) => update_user(),
        '/updatePurchase': (context) => UpdatePurchase(),
        '/updateSale': (context) => const UpdateSales(),
        '/updateProduct': (context) => const UpdateProduct(),

        '/splash': (context) => SplashScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: "/splash",
    );
  }
}
