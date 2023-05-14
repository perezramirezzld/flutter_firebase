import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getProduct() async {
  List product = [];
  CollectionReference collectionReference = db.collection('product');
  QuerySnapshot queryproduct = await collectionReference.get();
  queryproduct.docs.forEach((documento) {
    product.add(documento.data());
  });
  await Future.delayed(const Duration(seconds: 1));
  return product;
}

Future<void> addProduct(String id, String name, String description, int units,
    double cost, double price, double utility) async {
  CollectionReference collectionReference = db.collection('product');
  await collectionReference.add({
    'id': id,
    'name': name,
    'description': description,
    'units': units,
    'cost': cost,
    'price': price,
    'utility': utility,
  });
}
