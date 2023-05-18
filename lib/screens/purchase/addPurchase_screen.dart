// import 'package:flutter/material.dart';

// import '../../service/firebase_service.dart';

// class addpurchase extends StatefulWidget {
//   const addpurchase({super.key});

//   @override
//   State<addpurchase> createState() => _addpurchaseState();
// }

// final _formKey = GlobalKey<FormState>();
// final _nameController = TextEditingController();
// final _piecesController = TextEditingController();

// class _addpurchaseState extends State<addpurchase> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Purchase Form'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _piecesController,
//                 decoration: const InputDecoration(labelText: 'Pieces'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a quantity';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0,),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     final purchase = {
//                       'name': _nameController.text,
//                       'pieces': int.parse(_piecesController.text),
//                     };
//                     await addPurchase(_nameController.text,
//                             int.parse(_piecesController.text))
//                         .then((value) => {
//                               _nameController.clear(),
//                               _piecesController.clear(),
//                               Navigator.pop(context)
//                             });
//                   }
//                 },
//                 child: const Text("save"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
