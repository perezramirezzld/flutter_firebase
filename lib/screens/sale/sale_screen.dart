import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/data_controller.dart';
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

  @override
  void initState() {
    saleModel.addAll(controller.sales);
    super.initState();
    _subscribeToSales();
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

  Future<void> initData() async {
    await controller.getAllSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      appBar: AppBar(
        backgroundColor: const Color(0XFF9d870c),
      ),
      body: ListView.builder(
          itemCount: saleModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                onDismissed: (direction) async =>
                    await deleteSaleF(saleModel[index].uid?.toString() ?? ''),
                confirmDismiss: ((direction) => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Do you want to remove this item?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Yes')),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    )),
                direction: DismissDirection.endToStart,
                key: Key(saleModel[index].uid.toString()),
                background: Container(
                    child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.red.withOpacity(0.8), BlendMode.dstATop),
                  child: Container(
                    color: Color(0XFF9d870c),
                  ),
                )),
                child: Card(
                  child: ListTile(
                    title: Text(saleModel[index].name),
                    subtitle: Text(saleModel[index].pieces.toString()),
                    trailing: const Icon(
                      Icons.delete_sweep,
                      size: 23,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/updateSale', arguments: {
                        'uid': saleModel[index].uid,
                        'IdClient': saleModel[index].idClient,
                        'IdProduct': saleModel[index].idProduct,
                        'name': saleModel[index].name,
                        'pieces': saleModel[index].pieces,
                        'subtotal': saleModel[index].subtotal,
                        'total': saleModel[index].total,
                      });
                      setState(() {});
                    },
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addSale');
        },
        backgroundColor: const Color(0XFF9d870c),
        child: const Icon(Icons.playlist_add),
      ),
    );
  }
}
