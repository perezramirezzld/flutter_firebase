import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/addproduct_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/user_model.dart';

class userscreen extends StatefulWidget {
  const userscreen({super.key});

  @override
  State<userscreen> createState() => _userscreenState();
}

class _userscreenState extends State<userscreen> {
  final controller = Get.put(DataController());
  List<User> userModel = [];
  @override
  void initState() {
    //controller.getAllProducts();
    userModel.addAll(controller.users);
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await controller.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F8EC),
        appBar: AppBar(
          backgroundColor: const Color(0XFF9d870c),
        ),
        body: ListView.builder(
          itemCount: userModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (direction) async =>
                  await deleteUser(userModel[index].uid?.toString() ?? ''),
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
                  title: Text(userModel[index].name),
                  subtitle: Text('Cantidad: ${userModel[index].gender}'),
                  trailing: Icon(
                    Icons.delete_sweep,
                    size: 23,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/upUser", arguments: {
                      'name': userModel[index].name,
                      'description': userModel[index].lastname,
                      'units': userModel[index].age,
                      'cost': userModel[index].gender,
                      'price': userModel[index].email,
                      'utility': userModel[index].password,
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
          child: const Icon(Icons.playlist_add),
          backgroundColor: const Color(0XFF9d870c),
        ));
  }
}
