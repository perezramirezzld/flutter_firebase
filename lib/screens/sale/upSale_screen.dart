import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/sale_model.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';

class UpdateSales extends StatefulWidget {
  const UpdateSales({super.key});

  @override
  State<UpdateSales> createState() => _updatesalescreenState();
}

class _updatesalescreenState extends State<UpdateSales> {
   StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  final _formKey = GlobalKey<FormState>();
  final uid = TextEditingController();
  final _nameController = TextEditingController();
  final _piecesController = TextEditingController();
  final _idProductController = TextEditingController();
  final _subtotalController = TextEditingController();
  final _totalController = TextEditingController();
  final _idClientController = TextEditingController();

  List<Product> productModel = [];
  Product? selectedProduct;

  @override
  void dispose() {
    _nameController.dispose();
    _piecesController.dispose();
    _idClientController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.getAllSales();
    _subscribeToProducts();
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

  @override
  Widget build(BuildContext context) {
    final Map <dynamic, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _piecesController.text = arguments['pieces'].toString();
    _idClientController.text = arguments['IdClient'];
    _idProductController.text = arguments['IdProduct'];
    _subtotalController.text = arguments['subtotal'].toString();
    _totalController.text = arguments['total'].toString();
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
                    Sale sale = Sale(
                      name: selectedProduct!.name, 
                      idProduct: _idProductController.text, 
                      idClient: _idClientController.text, 
                      pieces: int.parse(_piecesController.text), 
                      subtotal: double.parse(_subtotalController.text), 
                      total: double.parse(_totalController.text));
                    controller.updateSale(sale);
                    Navigator.of(context).pushNamed('/sales');
                  }
                },
                child: Text('Update Sale'),
              )
          
        ],
          )
        )
      )
    );
  }
}
