import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/controller/data_controller.dart';
import 'package:flutter_firebase/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
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

  Future<void> agregar() async {
    Sale sale = Sale(
      idClient: _idClientController.text,
      idProduct: selectedProduct!.uid!,
      name: selectedProduct!.name,
      pieces: int.parse(_piecesController.text),
      subtotal: selectedProduct!.price,
      total: total,
    );

    updateUnits(selectedProduct!.uid!, newPieces);
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
                          Image.asset('assets/compra.png',
                              width: 50, height: 50),
                          SizedBox(width: 10),
                          Text(
                            'Sale Form',
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
                    SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          agregar();
                          Navigator.of(context).pushNamed('/sales');
                          clear();
                        }
                      },
                      child: Text('Save'),
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
