import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase/models/purchase_model.dart';
import '../../controller/data_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product_model.dart';

class UpdatePurchase extends StatefulWidget {
  UpdatePurchase({Key? key}) : super(key: key);

  @override
  State<UpdatePurchase> createState() => _UpdatePurchaseState();
}

class _UpdatePurchaseState extends State<UpdatePurchase> {
  StreamSubscription<QuerySnapshot>? _subscription;
  List<Product> productModel = [];
  Product? selectedProduct;
  final uid = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _piecesController = TextEditingController();

  void dispose() {
    _nameController.dispose();
    _piecesController.dispose();
    super.dispose();
  }

  final controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    controller.getAllPurchases();
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
            cost: document['cost']+ 0.0,
            price: document['price']+ 0.0,
            utility: document['utility']+ 0.0,
          );
        }).toList();
      });
    });
  }

  Future<void> changeScreen() async {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
      Navigator.of(context).pushNamed('/purchases');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _piecesController.text = arguments['pieces'].toString();
    int aux = int.parse(_piecesController.text);
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
                            'Purchase Form',
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
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _piecesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pieces',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a pieces';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Purchase purchase = Purchase(
                            uid: uid.text,
                            name: selectedProduct!.name,
                            pieces: int.parse(_piecesController.text),
                          );
                          if (aux > int.parse(_piecesController.text)) {
                            int aux2 = aux - int.parse(_piecesController.text);

                            updateUnits(selectedProduct!.uid!,
                                selectedProduct!.units - aux2);
                            aux2 = 0;
                          } else {
                            int aux2 = int.parse(_piecesController.text) - aux;

                            updateUnits(selectedProduct!.uid!,
                                selectedProduct!.units + aux2);
                            aux2 = 0;
                          }
                          controller.updatePurchase(purchase);
                          Navigator.of(context).pushNamed('/purchases');
                        }
                      },
                      child: const Text('Save'),
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
