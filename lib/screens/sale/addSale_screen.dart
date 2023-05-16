import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addsalescreen extends StatefulWidget {
  const addsalescreen({Key? key}) : super(key: key);

  @override
  State<addsalescreen> createState() => _addsalescreenState();
}

String? _idProduct;
String? _nameProduct;
double? _priceProduct;

//Variables necesarias
double stotal = 0;
double total = 0;
double pieces = 0;
double price = 0;

final _formKey = GlobalKey<FormState>();
final _idClientController = TextEditingController();
final _piecesController = TextEditingController();
double _totaltextController = 0;

void _updateTotal() {
  pieces = double.parse(_piecesController.text);
  price = _priceProduct ?? 0;
  total = price * pieces;
  _totaltextController = total;
}

class _addsalescreenState extends State<addsalescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Selection'),
      ),
      body: SingleChildScrollView(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 30.0, right: 30.0, bottom: 0.0),
              child: FutureBuilder<List>(
                future: getProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final products = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Product name',
                      ),
                      value: _nameProduct,
                      onChanged: (value) {
                        setState(() {
                          pieces = 0;
                          _totaltextController = 0.00;
                          _piecesController.text = "";
                          _nameProduct = value;
                          _priceProduct = products.firstWhere((product) =>
                              product['name'] == _nameProduct)['price'];
                          _idProduct = products.firstWhere((product) =>
                              product['name'] == _nameProduct)['uid'];
                          print(_nameProduct);
                          print(_priceProduct);
                        });
                      },
                      items: products.map((product) {
                        return DropdownMenuItem<String>(
                          value: product['name'],
                          child: Text(product['name']),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a product';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _piecesController,
                    decoration: const InputDecoration(labelText: 'pieces'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onChanged: (value) async {
                      await Firebase.initializeApp();
                      if (_piecesController.text.isNotEmpty) {
                        _updateTotal();
                      } else {
                        _totaltextController = 0.0;
                      }
                      setState(() {});
                    },
                  ),
                  TextFormField(
                    controller: _idClientController,
                    decoration: InputDecoration(
                      labelText: 'Id Client',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the Id';
                      }
                      return null;
                    },
                    onChanged: (value) async {
                      await Firebase.initializeApp();
                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 250,
                    width: 150,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 20.0, right: 16.0, bottom: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sale Ticket',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 15),
                            Text('${_nameProduct}'),
                            const SizedBox(height: 8),
                            Text(
                              'IdSale: ${_idProduct}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'IdClient: ${_idClientController.text}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 15),
                            Text('Pieces: ${_piecesController.text}'),
                            Text('Subtotal: \$${_priceProduct}'),
                            const SizedBox(height: 30),
                            Text(
                                'Total: \$${_totaltextController.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await addSale(
                        _nameProduct!,
                        _idProduct!,
                        _idClientController.text,
                        int.parse(_piecesController.text),
                        double.parse(price.toStringAsFixed(2)),
                        double.parse(total.toStringAsFixed(2)))
                    .then((_) => {
                          _nameProduct = "",
                          _idProduct = "",
                          _idClientController.clear(),
                          _piecesController.clear(),
                          _totaltextController = 0.0,
                          Navigator.pop(context),
                        });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
