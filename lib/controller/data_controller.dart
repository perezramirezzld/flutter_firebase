import 'package:get/get.dart';

import '../models/purchase_model.dart';
import '../models/sale_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../service/firebase_service.dart';

class DataController extends GetxController {
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

  Future<void> getAllProducts() async {
    products.clear();
    products.value = await getProducts();
  }

  Future<void> getAllUsers() async {
    users.clear();
    users.value = await getUsers();
  }

  Future<void> getAllPurchases() async {
    purchases.clear();
    purchases.value = await getPurchases();
  }

//////////////////////ADD//////////////////////
  Future<void> addSale(Sale sale) async {
    await postSale(sale);
    await getAllSales();
  }

  Future<void> addProduct(Product product) async {
    await postProduct(product);
    await getAllProducts();
  }

  Future<void> addUser(User user) async {
    await postUser(user);
    await getAllUsers();
  }

  Future<void> addPurchase(Purchase purchase) async {
    await postPurchase(purchase);
    await getAllPurchases();
  }

  ////////////////////////UPDATE//////////////////////
  Future<void> updateSale(Sale sale) async {
    await updateSaleF(sale);
    await getAllSales();
  }

  Future<void> updateProduct(Product products) async {
    await updateProductF(products);
    await getAllProducts();
  }
  Future<void> updateProductM(ProductM productm) async {
    await updateProductM(productm);
    await getAllProducts();
  }

  // Future<void> updateProductStock(String uid, int i) async {
  //   await updateUnits(uid, i);
  //   await getAllProducts();
  // }

  Future<void> updateUser(User user) async {
    await updateUserF(user);
    await getAllUsers();
  }

  Future<void> updatePurchase(Purchase purchase) async {
    await updatePurchaseF(purchase);
    await getAllPurchases();
  }

  ////////////////////////DELETE//////////////////////
  Future<void> deleteSale(String uid) async {
    await deleteSaleF(uid);
    await getAllSales();
  }

  Future<void> deleteProduct(String uid) async {
    await deleteProductF(uid);
    await getAllProducts();
  }

  Future<void> deleteUser(String uid) async {
    await deleteUserF(uid);
    await getAllUsers();
  }

  Future<void> detelePurchase(String uid) async {
    await deletePurchaseF(uid);
    await getAllPurchases();
  }
}
