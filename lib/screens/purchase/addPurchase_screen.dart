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
            cost: document['cost']+ 0.0,
            price: document['price']+ 0.0,
            utility: document['utility']+ 0.0,
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
      resizeToAvoidBottomInset: false,
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
                          Image.asset('assets/inventario.png',
                              width: 50, height: 50),
                          SizedBox(width: 10),
                          Text(
                            'Purchases Form',
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
                    SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Purchase purchase = Purchase(
      name: selectedProduct!.name,
      pieces: int.parse(_piecesController.text),
    );

    updateUnits(selectedProduct!.uid!, newPieces);
    controller.addPurchase(purchase);
                          Navigator.of(context).pushNamed('/purchases');
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
