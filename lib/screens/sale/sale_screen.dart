import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/sale/addSale_screen.dart';

import '../../service/firebase_service.dart';

class salescreen extends StatefulWidget {
  const salescreen({super.key});

  @override
  State<salescreen> createState() => _salescreenState();
}

class _salescreenState extends State<salescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8EC),
      appBar: AppBar(
        backgroundColor: const Color(0XFF9d870c),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_outlined),
            //color: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addsalescreen(),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getSale(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) async => deleteSale(
                      await snapshot.data?[index]['uid']?.toString() ?? ''),
                  confirmDismiss: ((direction) => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content:
                              const Text('Do you want to remove this item?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      )),
                  direction: DismissDirection.endToStart,
                  key: Key(snapshot.data?[index]['uid']),
                  background: Container(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.8), BlendMode.dstATop),
                      child: Container(
                        color: Color(0XFF9d870c),
                      ),
                    ),
                  ),
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: ListTile(
                      title:
                          Text(snapshot.data?[index]['name']?.toString() ?? ''),
                      subtitle: Text(
                          '\$${snapshot.data?[index]['total']?.toString() ?? ''}'),
                      trailing: Icon(
                        Icons.delete_sweep,
                        size: 23,
                      ),
                      iconColor: Color(0XFF9d870c),
                      onTap: () async {
                        print(snapshot.data?[index]['uid']);
                        await Navigator.pushNamed(context, "/upsale",
                            arguments: {
                              'name': snapshot.data?[index]['name'],
                              'IdSale': snapshot.data?[index]['IdSale'],
                              'IdProduct': snapshot.data?[index]['IdProduct'],
                              'IdClient': snapshot.data?[index]['IdClient'],
                              'pieces': snapshot.data?[index]['pieces'],
                              'subtotal': snapshot.data?[index]['subtotal'],
                              'total': snapshot.data?[index]['total'],
                              'uid': snapshot.data?[index]['uid'],
                            });
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
