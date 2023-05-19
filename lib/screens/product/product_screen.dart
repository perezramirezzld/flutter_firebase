import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/addproduct_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';

class productscreen extends StatefulWidget {
  const productscreen({super.key});

  @override
  State<productscreen> createState() => _productscreenState();
}

class _productscreenState extends State<productscreen> {
  final controller = Get.put(DataController());
  List<Product> productModel = [];
  @override
  void initState() {
    //controller.getAllProducts();
    productModel.addAll(controller.products);
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await controller.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F8EC),
        appBar: AppBar(
          backgroundColor: const Color(0XFF9d870c),
        ),
        body: ListView.builder(
          itemCount: productModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (direction) async => await deleteProduct(
                  productModel[index].uid?.toString() ?? ''),
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
              key: Key(productModel[index].uid.toString()),
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
                  title: Text(productModel[index].name),
                  subtitle: Text('Cantidad: ${productModel[index].units}'),
                  trailing: Icon(
                    Icons.delete_sweep,
                    size: 23,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/updateProduct", arguments: {
                      'name': productModel[index].name,
                      'description': productModel[index].description,
                      'units': productModel[index].units,
                      'cost': productModel[index].cost,
                      'price': productModel[index].price,
                      'utility': productModel[index].utility,
                      'uid': productModel[index].uid,
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
            Navigator.pushNamed(context, "/addProduct");
          },
          child: const Icon(Icons.playlist_add),
          backgroundColor: const Color(0XFF9d870c),
        ));
  }
}
