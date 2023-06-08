import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';
import '../../models/sale_model.dart';
import '../../service/firebase_service.dart';

class salescreen extends StatefulWidget {
  const salescreen({super.key});

  @override
  State<salescreen> createState() => _salescreenState();
}

class _salescreenState extends State<salescreen> {
  StreamSubscription<QuerySnapshot>? _subscription;

  final controller = Get.put(DataController());
  List<Sale> saleModel = [];
  List<Product> productModel = [];
  Product? selectedProduct;

  @override
  void initState() {
    saleModel.addAll(controller.sales);
    super.initState();
    _subscribeToSales();
    _subscribeToProducts();
  }

  void _subscribeToSales() {
    _subscription = FirebaseFirestore.instance
        .collection('sale')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        saleModel = snapshot.docs.map((DocumentSnapshot document) {
          return Sale(
            uid: document.id,
            name: document['name'],
            idProduct: document['IdProduct'],
            idClient: document['IdClient'],
            pieces: document['pieces'],
            subtotal: document['subtotal'],
            total: document['total'],
          );
        }).toList();
      });
    });
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
            cost: document['cost'] + 0.0,
            price: document['price'] + 0.0,
            utility: document['utility'] + 0.0,
          );
        }).toList();
      });
    });
  }

  Future<void> initData() async {
    await controller.getAllSales();
  }

  void deleteProducts(String uidS, String uid, int pcs) {
    int units =
        productModel[productModel.indexWhere((element) => element.uid == uid)]
            .units;
    int newpieces = units + pcs;
    updateUnits(uid, newpieces);
    controller.deleteSale(uidS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fef4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sales',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontWeight: FontWeight.normal)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, '/menu'); // Navegar a la página de inicio de sesión
            },
            child: Icon(Icons.roofing, color: Colors.white),
          ),
        ],
        backgroundColor: const Color(0xff7a6a53),
      ),
      body: ListView.builder(
        itemCount: saleModel.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Image.asset(
                'assets/compra.png',
                width: 30,
                height: 30,
              ),
              title: Text(saleModel[index].name),
              subtitle: Text(
                  'Units: ${saleModel[index].pieces} Total: \$${saleModel[index].total}'),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_sweep,
                  size: 23,
                  color: Color(0xffE1860A),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to remove this item?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            deleteProducts(
                                saleModel[index].uid?.toString() ?? '',
                                saleModel[index].idProduct?.toString() ?? '',
                                saleModel[index].pieces);
                            initState();
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addSale');
        },
        backgroundColor: const Color(0xffE1860A),
        child: const Icon(
          Icons.add_task_outlined,
          size: 25,
        ),
      ),
    );
  }
}
