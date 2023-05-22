import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/product_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../../service/firebase_service.dart';

class addpurchase extends StatefulWidget {
  const addpurchase({super.key});

  @override
  State<addpurchase> createState() => _addpurchaseState();
}

class _addpurchaseState extends State<addpurchase> {
  StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  List<Product> productModel = [];
  Product? selectedProduct;

  int pieces = 0;
  int newPieces = 0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _piecesController = TextEditingController();

  @override
  void initState() {
    clear();
    _subscribeToProducts();
    super.initState();
  }

  Future<void> agregar() async {
    Purchase purchase = Purchase(
      name: selectedProduct!.name,
      pieces: int.parse(_piecesController.text),
    );

    updateUnits(selectedProduct!.uid!, newPieces);
    controller.addPurchase(purchase);
  }

  void _subscribeToProducts() {
    _subscription = FirebaseFirestore.instance
        .collection('product')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        productModel = snapshot.docs.map((DocumentSnapshot document) {
          return Product(
            uid: document.id,
            name: document['name'],
            description: document['description'],
            units: document['units'],
            cost: document['cost'],
            price: document['price'],
            utility: document['utility'],
          );
        }).toList();
      });
    });
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
              DropdownButtonFormField<Product>(
                value: selectedProduct,
                onChanged: (Product? newValue) {
                  setState(() {
                    selectedProduct = newValue;
                    print(selectedProduct!.units);
                  });
                },
                items: productModel.isEmpty
                    ? []
                    : productModel
                        .map<DropdownMenuItem<Product>>((Product product) {
                        return DropdownMenuItem<Product>(
                          value: product,
                          child: Text(product.name),
                        );
                      }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select a product',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _piecesController,
                onChanged: (value) {
                  setState(() {
                    pieces = int.tryParse(value) ?? 0;
                    newPieces = selectedProduct!.units + pieces;
                  });
                },
                decoration: const InputDecoration(labelText: 'Pieces'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      int.tryParse(value) == null ||
                      value.isEmpty) {
                    return 'Please enter a valid number of pieces';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    agregar();
                    Navigator.of(context).pushNamed('/purchases');
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
