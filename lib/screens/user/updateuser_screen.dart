import 'package:flutter/material.dart';

import '../../service/firebase_service.dart';

class update_user extends StatefulWidget {
  const update_user({super.key});

  @override
  State<update_user> createState() => _update_userState();
}

final uid = TextEditingController();
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _lastnameController = TextEditingController();
final _ageController = TextEditingController();
final _genderController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

class _update_userState extends State<update_user> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _lastnameController.text = arguments['lastname'];
    _ageController.text = arguments['age'].toString();
    _genderController.text = arguments['gender'];
    _emailController.text = arguments['email'];
    _passwordController.text = arguments['password'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  decoration: const InputDecoration(labelText: 'Lastname'),
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
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //Save the form data into variables
                    final user = {
                      'name': _nameController.text,
                      'lastname': _lastnameController.text,
                      'age': int.parse(_ageController.text),
                      'gender': _genderController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    };
                    print(uid.text);
                    await updateUser(
                      uid.text,
                      _nameController.text,
                      _lastnameController.text,
                      int.parse(_ageController.text),
                      _genderController.text,
                      _emailController.text,
                      _passwordController.text,
                    ).then((_) => Navigator.pop(context));
                  }
                },
                child: Text('Update User'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
