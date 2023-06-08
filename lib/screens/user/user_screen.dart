import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/data_controller.dart';
import '../../models/user_model.dart';

class userscreen extends StatefulWidget {
  const userscreen({super.key});

  @override
  State<userscreen> createState() => _userscreenState();
}

class _userscreenState extends State<userscreen> {
  StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  List<UserLocal> userModel = [];
  List<String> randomIcons = [
    'assets/pana1.png',
    'assets/pana2.png',
    'assets/pana3.png',
    // Agrega más iconos aquí según tus necesidades
  ];
  @override
  void initState() {
    //controller.getAllProducts();
    userModel.addAll(controller.users);
    super.initState();
    _subscribeToUsers();
  }

  void _subscribeToUsers() {
    _subscription = FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        userModel = snapshot.docs.map((DocumentSnapshot document) {
          return UserLocal(
            uid: document.id,
            name: document['name'],
            lastname: document['lastname'],
            role: document['role'],
            age: document['age'],
            gender: document['gender'],
            email: document['email'],
            password: document['password'],
          );
        }).toList();
      });
    });
  }

  // void deleteUsers(String Suid) {
  //   controller.deleteUser(Suid);
  // }

  void showAlert(
      BuildContext context, String exitoMessage, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exitoMessage),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/users');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser(BuildContext context, String uid) async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user!.uid == uid) {
      if (user != null) {
        try {
          await user.delete();
          print('Usuario eliminado (autenticado)');
        } catch (e) {
          print('Error al actualizar email: $e');
        }
        try {
          controller.deleteUser(uid);
          showAlert(
              context, 'Operación exitosa', 'Usuario eliminado exitosamente');
          Navigator.pushNamed(context, "/menu");
        } catch (e) {
          print('Error al actualizar info del usuario: $e');
        }
      } else {
        print('No user signed in');
      }
    } else {
      showAlert(context, 'Error',
          'No se puede actualizar información de otro usuario.');

      print('No se puede actualizar información de otro usuario');
    }
  }

  Future<void> initData() async {
    await controller.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf8fef4),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Users',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial  ',
                  fontWeight: FontWeight.normal)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/menu'); // Navegar a la página de inicio de sesión
              },
              child: Icon(Icons.roofing, color: Colors.white),
            ),
          ],
          backgroundColor: const Color(0xff7a6a53),
        ),
        body: ListView.builder(
          itemCount: userModel.length,
          itemBuilder: (BuildContext context, int index) {
            final randomIndex = Random().nextInt(randomIcons.length);
            final randomImage = randomIcons[randomIndex];
            return Card(
              child: ListTile(
                leading: Image.asset(
                  randomImage,
                  width: 30,
                  height: 30,
                ),
                title: Text(userModel[index].name),
                subtitle: Text('Gender: ${userModel[index].gender}'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_sweep,
                    size: 23,
                    color: Color(0xffE1860A),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Do you want to remove this item?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              deleteUser(context,
                                  userModel[index].uid?.toString() ?? '');
                              Navigator.pushNamed(context, "/login");

                              initState();
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/updateUser", arguments: {
                    'name': userModel[index].name,
                    'lastname': userModel[index].lastname,
                    'role': userModel[index].role,
                    'age': userModel[index].age,
                    'gender': userModel[index].gender,
                    'email': userModel[index].email,
                    'password': userModel[index].password,
                    'uid': userModel[index].uid,
                  });
                  setState(() {});
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addUser");
          },
          child: const Icon(
            Icons.add_task_outlined,
            size: 25,
          ),
          backgroundColor: const Color(0xffE1860A),
        ));
  }
}
