import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/data_controller.dart';
import '../../models/product_model.dart';
import '../../service/firebase_service.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key}) : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final uid = TextEditingController();
  final controller = Get.put(DataController());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitsController = TextEditingController();
  final _costController = TextEditingController();
  final _priceController = TextEditingController();
  final _utilityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _unitsController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _utilityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.getAllProducts();
  }

  Future<void> changeScreen() async {
    // await controller.getAllProducts();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Navigator.of(context).pushNamed('/products');
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    uid.text = arguments['uid'];
    _nameController.text = arguments['name'];
    _descriptionController.text = arguments['description'];
    _unitsController.text = arguments['units'].toString();
    _costController.text = arguments['cost'].toString();
    _priceController.text = arguments['price'].toString();
    _utilityController.text = arguments['utility'].toString();

    return Scaffold(
      backgroundColor: Color(0xff948c75),
      appBar: AppBar(
        backgroundColor: Color(0xff948c75),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 90.0,
            left: 30.0,
            right: 30.0,
            bottom: 100.0,
          ),
          child: Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Color(0xffff8fef4),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 30.0,
                  right: 30.0,
                  bottom: 35.0,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/panes.png',
                              width: 50, height: 50),
                          SizedBox(width: 10),
                          Text(
                            'Product Form',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _unitsController,
                      decoration: const InputDecoration(labelText: 'Units'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of units';
                        }
                        final int? units = int.tryParse(value);
                        if (units == null || units < 1) {
                          return 'Please enter a valid number of units';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _costController,
                      decoration: const InputDecoration(labelText: 'Cost'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the cost';
                        }
                        final double? cost = double.tryParse(value);
                        if (cost == null || cost < 0) {
                          return 'Please enter a valid cost';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price';
                        }
                        final double? price = double.tryParse(value);
                        if (price == null || price < 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _utilityController,
                      decoration: InputDecoration(
                        labelText: 'Utility',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the utility';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final product = Product(
                            uid: uid.text,
                            name: _nameController.text,
                            description: _descriptionController.text,
                            units: int.parse(_unitsController.text),
                            cost: double.parse(_costController.text),
                            price: double.parse(_priceController.text),
                            utility: double.parse(_utilityController.text),
                          );
                          controller
                              .updateProduct(product)
                              .then((value) => changeScreen());
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
