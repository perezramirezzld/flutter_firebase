import 'package:flutter/material.dart';
import 'package:flutter_firebase/controller/data_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.put(DataController());
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await controller.getAllProducts();
    await controller.getAllSales();
    await controller.getAllPurchases(); 
    await controller.getAllUsers();

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).pushNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(),
    );
  }
}
