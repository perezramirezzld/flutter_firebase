import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';

class purchasescreen extends StatefulWidget {
  const purchasescreen({super.key});

  @override
  State<purchasescreen> createState() => _purchasescreenState();
}

class _purchasescreenState extends State<purchasescreen> {
  StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  List<Purchase> purchaseModel = [];
  List<Product> productModel = [];
  Product? selectedProduct;
  @override
  void initState() {
    //controller.getAllProducts();
    purchaseModel.addAll(controller.purchases);
    super.initState();
    _subscribeToPurches();
    _subscribeToProducts();
  }

  void _subscribeToPurches() {
    _subscription = FirebaseFirestore.instance
        .collection('purchase')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        purchaseModel = snapshot.docs.map((DocumentSnapshot document) {
          return Purchase(
            uid: document.id,
            name: document['name'],
            pieces: document['pieces'],
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
            cost: document['cost'] +0.0,
            price: document['price'] +0.0,
            utility: document['utility'] +0.0,
          );
        }).toList();
      });
    });
  }

  Future<void> initData() async {
    await controller.getAllPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F8EC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Purchase',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial  ',
                  fontWeight: FontWeight.normal)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/menu'); // Navegar a la página de inicio de sesión
              },
              child: Icon(Icons.roofing, color: Colors.white),
            ),
          ],
          backgroundColor: const Color(0xff7a6a53),
        ),
        body: ListView.builder(
          itemCount: purchaseModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (direction) async => await controller
                  .detelePurchase(purchaseModel[index].uid?.toString() ?? ''),
              confirmDismiss: ((direction) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to remove this item?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  )),
              direction: DismissDirection.endToStart,
              key: Key(purchaseModel[index].uid.toString()),
              background: Container(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.red.withOpacity(0.8), BlendMode.dstATop),
                  child: Container(
                    color: Color(0XFF9d870c),
                  ),
                ),
              ),
              child: Card(
                child: ListTile(
                                    leading: Image.asset(
                    'assets/bolsapan.png',
                    width: 30,
                    height: 30,
                  ),
                  title: Text(purchaseModel[index].name),
                  subtitle: Text('Units: ${purchaseModel[index].pieces}'),
                  trailing: Icon(
                    Icons.delete_sweep,
                    size: 23,
                    color: Color(0xffE1860A),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/updatePurchase", arguments: {
                      'name': purchaseModel[index].name,
                      'pieces': purchaseModel[index].pieces,
                      'uid': purchaseModel[index].uid,
                    });
                    setState(() {});
                  },
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addPurchase");
          },
          backgroundColor: const Color(0xffE1860A),
          child: const Icon(
            Icons.add_task_outlined,
            size: 25,
          ),
        ));
  }
}
