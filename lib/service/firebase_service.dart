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

Future<void> deleteProduct(String uid) async {
  await db.collection('product').doc(uid).delete();
}
//aqui abajo va lo de usuarios

Future<List> getUser() async {
  List users = [];
  QuerySnapshot queryproduct = await db.collection('user').get();
  for (var doc in queryproduct.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final user = {
      // 'uid' is the document id
      'name': data['name'],
      'lastname': data['lastname'],
      'age': data['age'],
      'gender': data['gender'],
      'email': data['email'],
      'password': data['password'],
      'uid': doc.id,
    };
    users.add(user);
  }

  await Future.delayed(const Duration(seconds: 1));
  return users;
}

Future<void> addUser(String name, String lastname, int age, String gender, 
String email, String password) async {
  await db.collection("user").add({
    'name': name,
    'lastname': lastname,
    'age': age,
    'gender': gender,
    'email': email,
    'password': password,
  });
}

Future<void> updateUser(String uid, String nname, String nlastname,
    int nage, String ngender, String nemail, String npassword) async {
  await db.collection('user').doc(uid).set({
    'name': nname,
    'lastname': nlastname,
    'age': nage,
    'gender': ngender,
    'email': nemail,
    'password': npassword,
  });
}

Future<void> deleteUser(String uid) async {
  await db.collection('user').doc(uid).delete();
}

