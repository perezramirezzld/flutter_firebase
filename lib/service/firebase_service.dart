import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/sale_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/purchase_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

////////////////////// GET //////////////////////

Future<List<Product>> getProducts() async {
  List<Product> productModel = [];
  QuerySnapshot queryproduct = await db.collection('product').get();
  for (var doc in queryproduct.docs) {
    productModel.add(
      Product(
        name: doc['name'],
        description: doc['description'],
        units: doc['units'] as int,
        cost: doc['cost'] as double,
        price: doc['price'] as double,
        utility: doc['utility'] as double,
        uid: doc.id,
      ),
    );
  }

  print(productModel.length);

  return productModel;
}

Future<List<Sale>> getSales() async {
  List<Sale> salesModel = [];
  QuerySnapshot queryproduct = await db.collection('sale').get();
  for (var doc in queryproduct.docs) {
    salesModel.add(Sale(
      name: doc['name'],
      idProduct: doc['IdProduct'],
      idClient: doc['IdClient'],
      pieces: doc['pieces'],
      subtotal: doc['subtotal'],
      total: doc['total'],
      uid: doc.id,
    ));
  }
  return salesModel;
}

Future<List<User>> getUsers() async {
  List<User> usersModel = [];
  QuerySnapshot queryproduct = await db.collection('user').get();
  for (var doc in queryproduct.docs) {
    usersModel.add(User(
      name: doc['name'],
      lastname: doc['lastname'],
      age: doc['age'],
      gender: doc['gender'],
      email: doc['email'],
      password: doc['password'],
      uid: doc.id,
    ));
  }
print(usersModel.length);

  return usersModel;
}

Future<List<Purchase>> getPurchases() async {
  List<Purchase> purchasesModel = [];
  QuerySnapshot queryproduct = await db.collection('purchase').get();
  for (var doc in queryproduct.docs) {
    purchasesModel.add(Purchase(
      name: doc['name'],
      pieces: doc['pieces'],
      uid: doc.id,
    ));
  }
  return purchasesModel;
}

///////////////////////////// ADD //////////////////////////////////////

Future<void> postProduct(Product product) async {
  await db.collection("product").add({
    'name': product.name,
    'description': product.description,
    'units': product.units,
    'cost': product.cost,
    'price': product.price,
    'utility': product.utility,
  });
}


Future<void> postSale(Sale sale) async {
  await db.collection('sale').add({
    'name': sale.name,
    'IdProduct': sale.idProduct,
    'IdClient': sale.idClient,
    'pieces': sale.pieces,
    'subtotal': sale.subtotal,
    'total': sale.total,
  });
}

Future<void> postUser(User user) async {
  await db.collection("user").add({
    'name': user.name,
    'lastname': user.lastname,
    'age': user.age,
    'gender': user.gender,
    'email': user.email,
    'password': user.password,
  });
}

Future<void> postPurchase(Purchase purchase) async {
  await db.collection("purchase").add({
    'name': purchase.name,
    'pieces': purchase.pieces,
  });
}

///////////////////////////// UPDATE //////////////////////////////////////
Future<void> updateProductF(Product product) async {
  await db.collection('product').doc(product.uid).set({
    'name': product.name,
    'description': product.description,
    'units': product.units,
    'cost': product.cost,
    'price': product.price,
    'utility': product.utility,
  });
}

Future<void> updateProductM(ProductM productM) async {
  await db.collection('product').doc(productM.uid).set({
    'name': productM.name,
    'description': productM.description,
    'units': productM.units,
    'cost': productM.cost,
    'price': productM.price,
    'utility': productM.utility,
  });
}

Future<void> updateUnits(String uid, int i) async {
  await FirebaseFirestore.instance.collection('product').doc(uid).update({
    'units': i,
  });
}


Future<void> updateSaleF(Sale sale) async {
  await db.collection('sale').doc(sale.uid).set({
    'name': sale.name,
    'IdProduct': sale.idProduct,
    'IdClient': sale.idClient,
    'pieces': sale.pieces,
    'subtotal': sale.subtotal,
    'total': sale.total,
  });
}

Future<void> updateUserF(User user) async {
  await db.collection('user').doc(user.uid).set({
    'name': user.name,
    'lastname': user.lastname,
    'age': user.age,
    'gender': user.gender,
    'email': user.email,
    'password': user.password,
  });
}

Future<void> updatePurchaseF(Purchase purchase) async {
  await db.collection('purchase').doc(purchase.uid).set({
    'name': purchase.name,
    'pieces': purchase.pieces,
  });
}

///////////////////////////// DELETE //////////////////////////////////////

Future<void> deleteProductF(String uid) async {
  await db.collection('product').doc(uid).delete();
}

Future<void> deleteUserF(String uid) async {
  await db.collection('user').doc(uid).delete();
}

Future<void> deletePurchaseF(String uid) async {
  await db.collection('purchase').doc(uid).delete();
}

Future<void> deleteSaleF(String uid) async {
  await db.collection('sale').doc(uid).delete();
}
