import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/models/product_model.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../service/firebase_service.dart';

class upproduct extends StatefulWidget {
  const upproduct({super.key});

  @override
  State<upproduct> createState() => _upproductState();
}

final uid = TextEditingController();
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _descriptionController = TextEditingController();
final _unitsController = TextEditingController();
final _costController = TextEditingController();
final _priceController = TextEditingController();
final _utilityController = TextEditingController();

class _upproductState extends State<upproduct> {
  final controller = Get.put(DataController());
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    uid.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _unitsController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _utilityController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    await controller.getAllProducts();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Navigator.of(context).pushNamed('/products');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _descriptionController.text = arguments['description'];
    _unitsController.text = arguments['units'].toString();
    _costController.text = arguments['cost'].toString();
    _priceController.text = arguments['price'].toString();
    _utilityController.text = arguments['utility'].toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
                    // Save the form data
                    final product = {
                      'uid': uid.text,
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'units': int.parse(_unitsController.text),
                      'cost': double.parse(_costController.text),
                      'price': double.parse(_priceController.text),
                      'utility': double.parse(_utilityController.text),
                    };
                    Products products = Products(
                      uid: uid.text,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      units: int.parse(_unitsController.text),
                      cost: double.parse(_costController.text),
                      price: double.parse(_priceController.text),
                      utility: double.parse(_utilityController.text),
                    );

                    controller.updateProduct(products);
                    await controller.getAllProducts();
                    print('uid: ${uid.text}');
                    //initData();
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
