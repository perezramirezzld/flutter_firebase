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
            cost: document['cost'],
            price: document['price'],
            utility: document['utility'],
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
      appBar: AppBar(
        title: const Text('Update Purchase'),
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
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Purchase purchase = Purchase(
                      uid: uid.text,
                      name: selectedProduct!.name,
                      pieces: int.parse(_piecesController.text),
                    );
                    if (aux>int.parse(_piecesController.text)){
                      int aux2 = aux - int.parse(_piecesController.text);
                      
                      updateUnits(selectedProduct!.uid!, selectedProduct!.units - aux2);
                      aux2=0;
                    }else{
                      int aux2 = int.parse(_piecesController.text) - aux ;

                      updateUnits(selectedProduct!.uid!, selectedProduct!.units + aux2);
                      aux2=0;
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
    );
  }
}
