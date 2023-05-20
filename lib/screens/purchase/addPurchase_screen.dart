import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/purchase_model.dart';
import '../../service/firebase_service.dart';

class addpurchase extends StatefulWidget {
  const addpurchase({super.key});

  @override
  State<addpurchase> createState() => _addpurchaseState();
}

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _piecesController = TextEditingController();

class _addpurchaseState extends State<addpurchase> {
  final controller = Get.put(DataController());
  @override
  void initState() {
    clear();
    super.initState();
  }

  Future<void> initData() async {
    await controller.getAllProducts();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Navigator.of(context).pushNamed('/purchases');
    });
  }

  Future<void> agregar() async {
    Purchase purchase = Purchase(
      name: _nameController.text,
      pieces: int.parse(_piecesController.text),
    );
    controller.addPurchase(purchase);
  }

  void clear() {
    _nameController.clear();
    _piecesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Form'),
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
                controller: _piecesController,
                decoration: const InputDecoration(labelText: 'Pieces'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of units';
                  }
                  final int? units = int.tryParse(value);
                  if (units == null || units < 1) {
                    return 'Please enter a valid number of units';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
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
    );
  }
}
