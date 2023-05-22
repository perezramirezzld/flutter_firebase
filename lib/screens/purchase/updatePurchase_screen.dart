import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase/models/purchase_model.dart';
import '../../controller/data_controller.dart';

class UpdatePurchase extends StatefulWidget {
  UpdatePurchase({Key? key}) : super(key: key);

  @override
  State<UpdatePurchase> createState() => _UpdatePurchaseState();
}



class _UpdatePurchaseState extends State<UpdatePurchase> {
  final uid = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _piecesController = TextEditingController();

  void dispose() {
    _nameController.dispose();
    _piecesController.dispose();
    super.dispose();
  }

  final controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    controller.getAllPurchases();
  }

  Future<void> changeScreen() async{
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
      Navigator.of(context).pushNamed('/purchases');
    });

  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
        uid.text = arguments['uid'];
        _nameController.text = arguments['name'];
        _piecesController.text = arguments['pieces'].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Purchase'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _piecesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pieces',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pieces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Purchase purchase = Purchase(
                      uid: uid.text,
                      name: _nameController.text,
                      pieces: int.parse(_piecesController.text),
                    );
                    controller.updatePurchase(purchase).then((value) => changeScreen());
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}