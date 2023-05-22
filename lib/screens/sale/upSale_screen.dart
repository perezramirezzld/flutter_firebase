import 'dart:async';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../models/product_model.dart';

class UpdateSales extends StatefulWidget {
  const UpdateSales({super.key});

  @override
  State<UpdateSales> createState() => _updatesalescreenState();
}

class _updatesalescreenState extends State<UpdateSales> {
  StreamSubscription<QuerySnapshot>? _subscription;
  final controller = Get.put(DataController());
  List<Product> productModel = [];
  Product? selectedProduct;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
