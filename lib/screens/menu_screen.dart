import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:flutter_firebase/screens/user/user_screen.dart';

class menuscreen extends StatefulWidget {
  const menuscreen({super.key});

  @override
  State<menuscreen> createState() => _menuscreenState();
}

final List<String> items = ['Register', 'Products', 'Sales', 'Purchases'];

class _menuscreenState extends State<menuscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La Vaquita'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MenuButton(
              text: 'Products',
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
            ), 
            const SizedBox(height: 16),
            MenuButton(
              text: 'Purchases',
              onPressed: () {
                Navigator.pushNamed(context, '/purchases');
              },
            ),
            const SizedBox(height: 16),
            MenuButton(
              text: 'Users',
              onPressed: () {
                Navigator.pushNamed(context, '/users');
              },
            ),
            const SizedBox(height: 16),
            MenuButton(
              text: 'Sales',
              onPressed: () {
                Navigator.pushNamed(context, '/sales');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(200, 60),
        primary: Colors.orange,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
