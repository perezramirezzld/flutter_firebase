import 'package:firebase_auth/firebase_auth.dart';
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
  String? _selectedRole;

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
  void showAlert(BuildContext context, String exitoMessage,String errorMessage){
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

  Future<void> updateCredentials(
      String newEmail, String newPassword, UserLocal usr, BuildContext context) async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user!.uid == uid.text){
    if (user != null) {

      try {
        await user.updateEmail(newEmail);
        print('Email updated');
      } catch (e) {
        print('Error al actualizar email: $e');
      }
      try {
        await user!.updatePassword(newPassword);
        print('Password updated');
      } catch (e) {
        print('Error al actualizar password: $e');
      }
      try {
        controller.updateUser(usr);
        showAlert(context,'Acción realizada con éxito' ,'Credenciales actualizadas correctamente');
      } catch (e) {
        print('Error al actualizar info del usuario: $e');
      }
    } else {
      print('No user signed in');
    }}
    else{
      showAlert(context, 'Error','No se puede actualizar información de otro usuario.');

      print('No se puede actualizar información de otro usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _lastnameController.text = arguments['lastname'];
    //  _selectedRole = arguments['role'];
    _ageController.text = arguments['age'].toString();
    _genderController.text = arguments['gender'];
    _emailController.text = arguments['email'];
    _passwordController.text = arguments['password'];
    return Scaffold(
      backgroundColor: Color(0xff948c75),
      appBar: AppBar(
        backgroundColor: Color(0xff948c75),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
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
                            Image.asset('assets/registro.png',
                                width: 50, height: 50),
                            SizedBox(width: 10),
                            Text(
                              'User Form',
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
                        decoration:
                            const InputDecoration(labelText: 'Lastname'),
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
                            return 'Please enter an age';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _genderController,
                        decoration: const InputDecoration(labelText: 'Gender'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your gender';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        items: [
                          DropdownMenuItem(
                            value: 'Admin',
                            child: Text('Admin'),
                          ),
                          DropdownMenuItem(
                            value: 'User',
                            child: Text('User'),
                          ),
                          DropdownMenuItem(
                            value: 'Seller',
                            child: Text('Seller'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                          print('Valor seleccionado: $_selectedRole');
                        },
                        decoration: InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Save the form data into variables
                            print(_selectedRole);
                            UserLocal usr = UserLocal(
                              uid: uid.text,
                              name: _nameController.text,
                              lastname: _lastnameController.text,
                              role: _selectedRole!,
                              age: int.parse(_ageController.text),
                              gender: _genderController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            updateCredentials(
                                _emailController.text,
                                _passwordController.text,
                                usr,
                                context);
                            //changeScreen();
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
      ),
    );
  }
}
