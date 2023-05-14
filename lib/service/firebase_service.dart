import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getProduct() async {
  List product = [];
  QuerySnapshot queryproduct = await db.collection('product').get();
  for (var doc in queryproduct.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final producto = {
      // 'uid' is the document id
      'name': data['name'],
      'description': data['description'],
      'units': data['units'],
      'cost': data['cost'],
      'price': data['price'],
      'utility': data['utility'],
      'uid': doc.id,
    };
    product.add(producto);
  }

  await Future.delayed(const Duration(seconds: 1));
  return product;
}

Future<void> addProduct(String name, String description, int units, double cost,
    double price, double utility) async {
  await db.collection("product").add({
    'name': name,
    'description': description,
    'units': units,
    'cost': cost,
    'price': price,
    'utility': utility,
  });
}

Future<void> updateProduct(String uid, String nname, String ndescription,
    int nunits, double ncost, double nprice, double nutility) async {
  await db.collection('product').doc(uid).set({
    'name': nname,
    'description': ndescription,
    'units': nunits,
    'cost': ncost,
    'price': nprice,
    'utility': nutility,
  });
}
