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
        cost: doc['cost'] + 0.0,
        price: doc['price'] + 0.0,
        utility: doc['utility'] + 0.0,
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
      pieces: int.tryParse(doc['pieces'].toString()) ?? 0,
      subtotal: doc['subtotal'] + 0.0,
      total: doc['total'] + 0.0,
      uid: doc.id,
    ));
  }
  return salesModel;
}

Future<List<UserLocal>> getUsers() async {
  List<UserLocal> usersModel = [];
  QuerySnapshot queryproduct = await db.collection('user').get();
  for (var doc in queryproduct.docs) {
    usersModel.add(UserLocal(
      name: doc['name'],
      lastname: doc['lastname'],
      role: doc['role'],
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
      idProduct: doc['IdProduct'],
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

Future<void> infoAdicional(String uid, UserLocal user) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    await users.doc(uid).set({
      'name': user.name,
      'lastname': user.lastname,
      'role': user.role,
      'age': user.age + 0,
      'gender': user.gender,
      'email': user.email,
      'password': user.password,
    });
    print('Se ha creado el usuario');
  } catch (e) {
    print('Error al crear el usuario');
  }

  // UserLocal user = UserLocal(
  //   name: _nameController.text,
  //   lastname: _lastnameController.text,
  //   age: int.parse(_ageController.text),
  //   gender: _genderController.text,
  //   email: _emailController.text,
  //   password: _passwordController.text,
  // );
  // controller.addUser(user);
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

Future<void> postUser(UserLocal user) async {
  await db.collection("user").add({
    'name': user.name,
    'lastname': user.lastname,
    'role': user.role,
    'age': user.age,
    'gender': user.gender,
    'email': user.email,
    'password': user.password,
  });
}

Future<void> postPurchase(Purchase purchase) async {
  await db.collection("purchase").add({
    'IdProduct': purchase.idProduct,
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

Future<void> updateUserF(UserLocal user) async {
  await db.collection('user').doc(user.uid).set({
    'name': user.name,
    'lastname': user.lastname,
    'role': user.role, // 'admin' or 'user' or 'seller'
    'age': user.age,
    'gender': user.gender,
    'email': user.email,
    'password': user.password,
  });
}

Future<void> updatePurchaseF(Purchase purchase) async {
  await db.collection('purchase').doc(purchase.uid).set({
    'IdProduct': purchase.idProduct,
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
