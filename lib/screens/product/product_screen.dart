import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/addproduct_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/service/firebase_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';

class productscreen extends StatefulWidget {
  const productscreen({super.key});

  @override
  State<productscreen> createState() => _productscreenState();
}

class _productscreenState extends State<productscreen> {
  StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  List<Product> productModel = [];
  List<String> randomIcons = [
    'assets/tostado.png',
    'assets/pan-dulce.png',
    'assets/pan-de-molde.png',
    'assets/grano-integral.png',
    // Agrega más iconos aquí según tus necesidades
  ];
  @override
  void initState() {
    //controller.getAllProducts();
    productModel.addAll(controller.products);
    super.initState();
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
            cost: document['cost'] + 0.0,
            price: document['price'] + 0.0,
            utility: document['utility'] + 0.0,
          );
        }).toList();
      });
    });
  }

  Future<void> initData() async {
    await controller.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf8fef4),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Products',
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
          itemCount: productModel.length,
          itemBuilder: (BuildContext context, int index) {
            // Generar un índice aleatorio para seleccionar un icono de la lista
            final randomIndex = Random().nextInt(randomIcons.length);
            final randomImage = randomIcons[randomIndex];
            return Dismissible(
              onDismissed: (direction) async => await deleteProductF(
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
                  leading: Image.asset(
                    randomImage,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(productModel[index].name),
                  subtitle: Text(
                      ' Units: ${productModel[index].units} Price: ${productModel[index].price}'),
                  trailing: Icon(
                    Icons.delete_sweep,
                    size: 23,
                    color: Color(0xffE1860A),
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
          backgroundColor: const Color(0xffE1860A),
          child: const Icon(
            Icons.add_task_outlined,
            size: 25,
          ),
        ));
  }
}
