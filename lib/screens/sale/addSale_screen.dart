import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/controller/data_controller.dart';
import 'package:flutter_firebase/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/sale_model.dart';

class addsalescreen extends StatefulWidget {
  const addsalescreen({Key? key}) : super(key: key);

  @override
  State<addsalescreen> createState() => _addsalescreenState();
}

class _addsalescreenState extends State<addsalescreen> {
  StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  List<Product> productModel = [];
  Product? selectedProduct;

  // Variables necesarias
  double subtotal = 0;
  double total = 0;
  double pieces = 0;
  double price = 0;
  int newPieces = 0;

  final _formKey = GlobalKey<FormState>();
  final _idClientController = TextEditingController();
  final _piecesController = TextEditingController();

  @override
  void initState() {
    clear();
    _subscribeToProducts();
    super.initState();
  }

  Future<void> changeScreen() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Navigator.of(context).pushNamed('/sales');
    });
  }

  Future<void> agregar() async {
    Sale sale = Sale(
      idClient: _idClientController.text,
      idProduct: selectedProduct!.uid!,
      name: selectedProduct!.name,
      pieces: int.parse(_piecesController.text),
      subtotal: selectedProduct!.price,
      total: total,
    );
    ProductM p = ProductM(
      uid: selectedProduct!.uid!,
      name: selectedProduct!.name,
      description: selectedProduct!.description,
      units: newPieces,
      cost: selectedProduct!.cost,
      price: selectedProduct!.price,
      utility: selectedProduct!.utility,
    );
    // controller.updateProductM(p);
    controller.addSale(sale);
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
    _idClientController.clear();
    _piecesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Selection'),
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
                    : productModel.map<DropdownMenuItem<Product>>(
                        (Product product) {
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
              SizedBox(height: 16),
              TextFormField(
                controller: _piecesController,
                onChanged: (value) {
                  setState(() {
                    pieces = double.tryParse(value) ?? 0.0;
                    total = pieces * (selectedProduct?.price ?? 0);
                    newPieces = selectedProduct!.units - pieces.toInt();
                    print(total);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Pieces',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      int.tryParse(value) == null ||
                      int.parse(value) > selectedProduct!.units ||
                      value.isEmpty) {
                    return 'Please enter a valid number of pieces or a number lower than ${selectedProduct!.units}';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _idClientController,
                decoration: const InputDecoration(
                  labelText: 'Id Client',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an id client';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    agregar();
                    changeScreen();
                    clear();
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
