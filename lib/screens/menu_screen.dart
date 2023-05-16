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

final List<String> items = ['Register', 'Products', 'Sales'];

class _menuscreenState extends State<menuscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 81, 153),
        title: Text('Menú'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              // Navegar a la página correspondiente
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/users');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/products');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/sales');
                  break;
              }
            },
          );
        },
      ),
    );
  }
}
