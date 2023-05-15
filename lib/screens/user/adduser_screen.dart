import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
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
                  return null;
                },
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(labelText: 'Lastname'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return 'Please enter a gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return 'Please enter a email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()){
                    final user = {
                      'name': _nameController.text,
                      'lastname': _lastnameController.text,
                      'age': int.parse(_ageController.text),
                      'gender': _genderController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    };
                    await addUser(
                      _nameController.text,
                      _lastnameController.text,
                      int.parse(_ageController.text),
                      _genderController.text,
                      _emailController.text,
                      _passwordController.text,
                    ).then((_) =>{
                      _nameController.clear(),
                      _lastnameController.clear(),
                      _ageController.clear(),
                      _genderController.clear(),
                      _emailController.clear(),
                      _passwordController.clear(),
                      Navigator.pop(context),
                    });
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}