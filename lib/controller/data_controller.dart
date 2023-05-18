import 'package:get/get.dart';

import '../models/purchase_model.dart';
import '../models/sale_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../service/firebase_service.dart';

class DataController extends GetxController{
  
  final sales = <Sale>[].obs;
  final users = <User>[].obs;
  final products = <Product>[].obs;
  final purchases = <Purchase>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
  /////////////////GET/////////////////////
  Future<void> getAllSales() async {
    sales.clear();
    sales.value = await getSales();
  }

  Future<void> getAllProducts() async{
    products.clear();
    products.value = await getProducts();
  }

  Future<void> getAllUsers() async{
    users.clear();
    users.value = await getUsers();
  }

  Future<void> getAllPurchases() async{
    purchases.clear();
    purchases.value = await getPurchases();
  }
//////////////////////ADD//////////////////////
  Future<void> addSale(Sale sale) async{
    await postSale(sale);
    await getAllSales();
  }

  Future<void> addProduct(Product product) async{
    await postProduct(product);
    await getAllProducts();
  }
  Future<void> addUser(User user) async{
    await postUser(user);
    await getAllUsers();
  }

  Future<void> addPurchase(Purchase purchase) async{
    await postPurchase(purchase);
    await getAllPurchases();
  }
  ////////////////////////UPDATE//////////////////////
  Future<void> updateSale(Sale sale) async{
    await updateSale(sale);
    await getAllSales();
  }
  Future<void> updateProduct(Product product) async{
    await updateProduct(product);
    await getAllProducts();
  }
  Future<void> updateUser(User user) async{
    await updateUser(user);
    await getAllUsers();
  }
  Future<void> updatePurchase(Purchase purchase) async{
    await updatePurchase(purchase);
    await getAllPurchases();
  }
  ////////////////////////DELETE//////////////////////
  Future<void> deleteSale(String uid) async{
    await deleteSale(uid);
    await getAllSales();
  }
  Future<void> deleteProduct(String uid) async{
    await deleteProduct(uid);
    await getAllProducts();
  }
  Future<void> deleteUser(String uid) async{
    await deleteUser(uid);
    await getAllUsers();
  }
  Future<void> detelePurchase(String uid) async{
    await deletePurchase(uid);
    await getAllPurchases();
  }
  
}