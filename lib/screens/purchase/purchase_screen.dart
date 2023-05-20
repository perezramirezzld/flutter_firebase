import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/addproduct_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/purchase_model.dart';

class purchasescreen extends StatefulWidget {
  const purchasescreen({super.key});

  @override
  State<purchasescreen> createState() => _purchasescreenState();
}

class _purchasescreenState extends State<purchasescreen> {
  final controller = Get.put(DataController());
  List<Purchase> purchaseModel = [];
  @override
  void initState() {
    //controller.getAllProducts();
    purchaseModel.addAll(controller.purchases);
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await controller.getAllPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F8EC),
        appBar: AppBar(
          backgroundColor: const Color(0XFF9d870c),
        ),
        body: ListView.builder(
          itemCount: purchaseModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (direction) async => await deletePurchase(
                  purchaseModel[index].uid?.toString() ?? ''),
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
                  title: Text(purchaseModel[index].name),
                  subtitle: Text('Cantidad: ${purchaseModel[index].pieces}'),
                  trailing: Icon(
                    Icons.delete_sweep,
                    size: 23,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/upPurchase", arguments: {
                      'name': purchaseModel[index].name,
                      'pieces': purchaseModel[index].pieces,
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
          child: const Icon(Icons.playlist_add),
          backgroundColor: const Color(0XFF9d870c),
        ));
  }
}
