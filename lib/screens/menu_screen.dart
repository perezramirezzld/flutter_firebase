import 'package:flutter/material.dart';

class menuscreen extends StatefulWidget {
  const menuscreen({super.key});

  @override
  State<menuscreen> createState() => _menuscreenState();
}

final List<String> items = ['Register', 'Products', 'Sales', 'Purchases'];
final List<IconData> icons = [
  Icons.person,
  Icons.shopping_cart_outlined,
  Icons.attach_money,
  Icons.local_shipping_outlined
];

class _menuscreenState extends State<menuscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff948c75),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            top: 90.0, left: 30.0, right: 30.0, bottom: 0.0),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Color(0xffff8fef4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Welcome to Fresh bread!',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 17,
                  ),
                ),
                Image.asset(
                  'assets/logopan.gif',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 25),
                ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 60.0, right: 0.0, bottom: 0.0),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(icons[index]),
                      title: Text(
                        '${items[index]}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        if (index == 0) {
                          Navigator.pushNamed(context, '/users');
                        } else if (index == 1) {
                          Navigator.pushNamed(context, '/products');
                        } else if (index == 2) {
                          Navigator.pushNamed(context, '/sales');
                        } else if (index == 3) {
                          Navigator.pushNamed(context, '/purchases');
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 70),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context,
                        '/login'); // Navegar a la página de inicio de sesión
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, color: Color(0xffE1860A)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
