import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/user_model.dart';
import '../../service/firebase_service.dart';

class adduser extends StatefulWidget {
  const adduser({super.key});

  @override
  State<adduser> createState() => _adduserState();
}

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _lastnameController = TextEditingController();
final _ageController = TextEditingController();
final _genderController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

class _adduserState extends State<adduser> {
  final controller = Get.put(DataController());
  @override
  void initState() {
    clear();
    super.initState();
  }

  Future<void> initData() async {
    await controller.getAllUsers();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Navigator.of(context).pushNamed('/users');
    });
  }

  Future<void> agregar() async {
    User user = User(
      name: _nameController.text,
      lastname: _lastnameController.text,
      age: int.parse(_ageController.text),
      gender: _genderController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    controller.addUser(user);
  }

  void clear() {
    _nameController.clear();
    _lastnameController.clear();
    _ageController.clear();
    _genderController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff948c75),
      appBar: AppBar(
        backgroundColor: Color(0xff948c75),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 90.0,
            left: 30.0,
            right: 30.0,
            bottom: 100.0,
          ),
          child: Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Color(0xffff8fef4),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 30.0,
                  right: 30.0,
                  bottom: 35.0,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/panes.png',
                              width: 50, height: 50),
                          SizedBox(width: 10),
                          Text(
                            'Product Form',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(labelText: 'LastName'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a lastname';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of age';
                        }
                        final int? units = int.tryParse(value);
                        if (units == null || units < 1) {
                          return 'Please enter a valid number of age';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _genderController,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a gender';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Paswword'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          agregar();
                          initData();
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
