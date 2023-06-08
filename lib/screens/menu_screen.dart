import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../credentials/credential.dart';

class menuscreen extends StatefulWidget {
  const menuscreen({super.key});

  @override
  State<menuscreen> createState() => _menuscreenState();
}

bool registro = false;
bool productos = false;
bool ventas = false;
bool compras = false;

final List<String> items = ['Register', 'Products', 'Sales', 'Purchases'];
final List<IconData> icons = [
  Icons.person,
  Icons.shopping_cart_outlined,
  Icons.attach_money,
  Icons.local_shipping_outlined
];
void roles() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        String role = snapshot.get('role');
        if (role == 'Admin') {
          registro = true;
          productos = true;
          ventas = true;
          compras = true;
        } else if (role == 'Seller') {
          registro = false;
          productos = true;
          ventas = true;
          compras = false;
        } else if (role == 'User') {
          registro = false;
          productos = true;
          ventas = false;
          compras = true;
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

void showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.of(context).pushNamed('/users');
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class _menuscreenState extends State<menuscreen> {
  @override
  Widget build(BuildContext context) {
    roles();
    return Scaffold(
      backgroundColor: Color(0xff948c75),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            top: 90.0, left: 10.0, right: 10.0, bottom: 0.0),
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
                const SizedBox(height: 20, width: 300),
                Text(
                  'Welcome to Cuasó!',
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
                ElevatedButton(
                  onPressed: () {
                    if (registro) {
                      Navigator.pushNamed(context, '/users');
                    } else {
                      showAlert(context,
                          "No tienes persmios para acceder a esta sección");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff7a6a53),
                    fixedSize: Size(150, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 229, 229, 229),
                      ), // Añadir el ícono deseado aquí
                      SizedBox(width: 8), // Espacio entre el ícono y el texto
                      Text(
                        'Register',
                        style: TextStyle(
                            color: Color.fromARGB(255, 229, 229, 229)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (productos) {
                      Navigator.pushNamed(context, '/products');
                    } else {
                      showAlert(context,
                          "No tienes persmios para acceder a esta sección");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff7a6a53),
                    fixedSize: Size(150, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Color.fromARGB(255, 229, 229, 229),
                      ), // Añadir el ícono deseado aquí
                      SizedBox(width: 8), // Espacio entre el ícono y el texto
                      Text(
                        'Products',
                        style: TextStyle(
                            color: Color.fromARGB(255, 229, 229, 229)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (ventas) {
                      Navigator.pushNamed(context, '/sales');
                    } else {
                      showAlert(context,
                          "No tienes persmios para acceder a esta sección");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff7a6a53),
                    fixedSize: Size(150, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: Color.fromARGB(255, 229, 229, 229),
                      ), // Añadir el ícono deseado aquí
                      SizedBox(width: 8), // Espacio entre el ícono y el texto
                      Text(
                        'Sales',
                        style: TextStyle(
                            color: Color.fromARGB(255, 229, 229, 229)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (compras) {
                      Navigator.pushNamed(context, '/purchases');
                    } else {
                      showAlert(context,
                          "No tienes persmios para acceder a esta sección");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff7a6a53),
                    fixedSize: Size(150, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: Color.fromARGB(255, 229, 229, 229),
                      ), // Añadir el ícono deseado aquí
                      SizedBox(width: 8), // Espacio entre el ícono y el texto
                      Text(
                        'Purchases',
                        style: TextStyle(
                            color: Color.fromARGB(255, 229, 229, 229)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
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
                // ListView.builder(
                //   padding: const EdgeInsets.only(
                //       top: 0.0, left: 60.0, right: 0.0, bottom: 0.0),
                //   shrinkWrap: true,
                //   itemCount: items.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       leading: Icon(icons[index]),
                //       title: Text(
                //         '${items[index]}',
                //         style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.black,
                //         ),
                //       ),
                //       onTap: () {
                //         if (GlobalVariables.userCredential != null) {
                //           // Las credenciales están disponibles
                //           UserCredential userCredential =
                //               GlobalVariables.userCredential!;
                //           // Acceder a los datos necesarios, por ejemplo:
                //           User? user = userCredential.user;
                //           String userId = user?.uid ?? '';
                //           String email = user?.email ?? '';
                //           // Resto de tu lógica
                //         } else {
                //           // Las credenciales no están disponibles
                //         }

                //         if (index == 0) {
                //           Navigator.pushNamed(context, '/users');
                //         } else if (index == 1) {
                //           Navigator.pushNamed(context, '/products');
                //         } else if (index == 2) {
                //           Navigator.pushNamed(context, '/sales');
                //         } else if (index == 3) {
                //           Navigator.pushNamed(context, '/purchases');
                //         }
                //       },
                //     );
                //   },
                // ),