// import 'package:flutter/material.dart';
// import 'package:flutter_firebase/screens/purchase/addPurchase_screen.dart';
// import 'package:flutter_firebase/service/firebase_service.dart';

// class purchasesscreen extends StatefulWidget {
//   const purchasesscreen({super.key});

//   @override
//   State<purchasesscreen> createState() => _purchasesscreenState();
// }

// class _purchasesscreenState extends State<purchasesscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8EC),
//         appBar: AppBar(
//           backgroundColor: const Color(0XFF9d870c),
//         ),
//         body: FutureBuilder(
//           future: getPurchase(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 itemCount: snapshot.data?.length,
//                 itemBuilder: (context, index) {
//                   return Dismissible(
//                     onDismissed: (direction) async => deletePurchase(
//                         await snapshot.data?[index]['uid']?.toString() ?? ''),
//                     confirmDismiss: ((direction) => showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Are you sure?'),
//                         content:
//                         const Text('Do you want to remove this item?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () =>
//                                 Navigator.of(context).pop(true),
//                             child: const Text('Yes'),
//                           ),
//                           TextButton(
//                             onPressed: () =>
//                                 Navigator.of(context).pop(false),
//                             child: const Text('Cancel'),
//                           ),
//                         ],
//                       ),
//                     )),
//                     direction: DismissDirection.endToStart,
//                     key: Key(snapshot.data?[index]['uid']),
//                     background: Container(
//                       child: ColorFiltered(
//                         colorFilter: ColorFilter.mode(
//                             Colors.red.withOpacity(0.8), BlendMode.dstATop),
//                         child: Container(
//                           color: Color(0XFF9d870c),
//                         ),
//                       ),
//                     ),
//                     child: Card(
//                       margin: 
//                        EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//                       child: ListTile(
//                         title: Text(snapshot.data?[index]['name']?.toString() ?? ''),
//                         subtitle: Text('Pieces: ${snapshot.data?[index]['pieces']?.toString() ?? ''}'),
//                         trailing: Icon(Icons.delete_sweep,
//                           size: 23,),
//                           iconColor: Color(0XFF9d870c),
//                           onTap: () async {
//                             print(snapshot.data?[index]['uid']);
//                           },
//                       ),
                      

//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//     );
//   }
// }