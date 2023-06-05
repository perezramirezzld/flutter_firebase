import 'dart:async';
import 'dart:math';
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

  Future<void> initData() async {
    await controller.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F8EC),
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
            return Dismissible(
              onDismissed: (direction) async =>
                  await deleteUserF(userModel[index].uid?.toString() ?? ''),
              confirmDismiss: ((direction) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to remove this item?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  )),
              direction: DismissDirection.endToStart,
              key: Key(userModel[index].uid.toString()),
              background: Container(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.red.withOpacity(0.8), BlendMode.dstATop),
                  child: Container(
                    color: Color(0XFF9d870c),
                  ),
                ),
              ),
              child: Card(
                child: ListTile(
                  leading: Image.asset(
                    randomImage,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(userModel[index].name),
                  subtitle: Text('Gender: ${userModel[index].gender}'),
                  trailing: Icon(
                    Icons.delete_sweep,
                    size: 23,
                    color: Color(0xffE1860A),
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
