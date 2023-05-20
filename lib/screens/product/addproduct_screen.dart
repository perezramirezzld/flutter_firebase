import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';
import '../../service/firebase_service.dart';

class addproduct extends StatefulWidget {
  const addproduct({super.key});

  @override
  State<addproduct> createState() => _addproductState();
}

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _descriptionController = TextEditingController();
final _unitsController = TextEditingController();
final _costController = TextEditingController();
final _priceController = TextEditingController();
final _utilityController = TextEditingController();

class _addproductState extends State<addproduct> {
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
      Navigator.of(context).pushNamed('/products');
    });
  }

  Future<void> agregar() async {
    Product product = Product(
      uid: uid.text,
      name: _nameController.text,
      description: _descriptionController.text,
      units: int.parse(_unitsController.text),
      cost: double.parse(_costController.text),
      price: double.parse(_priceController.text),
      utility: double.parse(_utilityController.text),
    );
    await controller.addProduct(product);
  }

  void clear() {
    _nameController.clear();
    _descriptionController.clear();
    _unitsController.clear();
    _costController.clear();
    _priceController.clear();
    _utilityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
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
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitsController,
                decoration: const InputDecoration(labelText: 'Units'),
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
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cost';
                  }
                  final double? cost = double.tryParse(value);
                  if (cost == null || cost < 0) {
                    return 'Please enter a valid cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  final double? price = double.tryParse(value);
                  if (price == null || price < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _utilityController,
                decoration: InputDecoration(
                  labelText: 'Utility',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the utility';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
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
