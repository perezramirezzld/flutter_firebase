import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/sale/addSale_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase/models/user_model.dart';

import '../../controller/data_controller.dart';
import '../../service/firebase_service.dart';

class update_user extends StatefulWidget {
  const update_user({super.key});

  @override
  State<update_user> createState() => _update_userState();
}

class _update_userState extends State<update_user> {
  final uid = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final controller = Get.put(DataController());
  @override
  void initState() {
    super.initState();
    controller.getAllUsers();
  }

  Future<void> changeScreen() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Navigator.of(context).pushNamed('/users');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _lastnameController.text = arguments['lastname'];
    _ageController.text = arguments['age'].toString();
    _genderController.text = arguments['gender'];
    _emailController.text = arguments['email'];
    _passwordController.text = arguments['password'];
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
                      },
                    ),
                    TextFormField(
                        controller: _lastnameController,
                        decoration:
                            const InputDecoration(labelText: 'Lastname'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a lastname';
                          }
                        }),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a age';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _genderController,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your gender';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //Save the form data into variables
                          User user = User(
                            uid: uid.text,
                            name: _nameController.text,
                            lastname: _lastnameController.text,
                            age: int.parse(_ageController.text),
                            gender: _genderController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          controller
                              .updateUser(user)
                              .then((value) => changeScreen());
                        }
                      },
                      child: Text('Update User'),
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
