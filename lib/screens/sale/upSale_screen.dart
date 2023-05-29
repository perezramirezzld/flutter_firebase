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
            cost: document['cost']+0.0,
            price: document['price']+0.0,
            utility: document['utility']+0.0,
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _piecesController.text = arguments['pieces'].toString();
    _idClientController.text = arguments['IdClient'];
    _idProductController.text = arguments['IdProduct'];
    _subtotalController.text = arguments['subtotal'].toString();
    _totalController.text = arguments['total'].toString();
    return Scaffold(
  backgroundColor: Color(0xff948c75),
  appBar: AppBar(
    backgroundColor: Color(0xff948c75),
  ),
  body: SingleChildScrollView(
    child: Form(
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
                        Image.asset('assets/buy.png',
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
                    decoration: const InputDecoration(
                      labelText: 'Pieces',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) > selectedProduct!.units ||
                          value.isEmpty) {
                        return 'Please enter a valid number max: ${selectedProduct!.units}';
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
                  SizedBox(height: 45),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Sale sale = Sale(
                          name: selectedProduct!.name,
                          idProduct: _idProductController.text,
                          idClient: _idClientController.text,
                          pieces: int.parse(_piecesController.text),
                          subtotal: double.parse(_subtotalController.text) + 0.0,
                          total: double.parse(_totalController.text) + 0.0,
                        );
                        //controller.deleteSale(uid.text);
                        controller.updateSale(sale);
                        Navigator.of(context).pushNamed('/sales');
                      }
                    },
                    child: Text('Update Sale'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

  }
}
