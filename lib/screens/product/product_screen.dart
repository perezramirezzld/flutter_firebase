import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/screens/product/addproduct_screen.dart';
import 'package:flutter_firebase/screens/product/upproduct_screen.dart';
import 'package:flutter_firebase/service/firebase_service.dart';

class productscreen extends StatefulWidget {
  const productscreen({super.key});

  @override
  State<productscreen> createState() => _productscreenState();
}

class _productscreenState extends State<productscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F8EC),
        appBar: AppBar(
          backgroundColor: const Color(0XFF9d870c),
        ),
        body: FutureBuilder(
          future: getProduct(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) async => deleteProduct(
                        await snapshot.data?[index]['uid']?.toString() ?? ''),
                    confirmDismiss: ((direction) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content:
                                const Text('Do you want to remove this item?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
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
                        title: Text(
                            snapshot.data?[index]['name']?.toString() ?? ''),
                        subtitle: Text(
                            'Units: ${snapshot.data?[index]['units']?.toString() ?? ''}'),
                        trailing: Icon(
                          Icons.delete_sweep,
                          size: 23,
                        ),
                        iconColor: Color(0XFF9d870c),
                        onTap: () async {
                          print(snapshot.data?[index]['uid']);
                          await Navigator.pushNamed(context, "/up", arguments: {
                            'name': snapshot.data?[index]['name'],
                            'description': snapshot.data?[index]['description'],
                            'units': snapshot.data?[index]['units'],
                            'cost': snapshot.data?[index]['cost'],
                            'price': snapshot.data?[index]['price'],
                            'utility': snapshot.data?[index]['utility'],
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addproduct(),
              ),
            );
            setState(() {
              // ignore: unnecessary_statements
              getProduct();
            });
          },
          child: const Icon(Icons.playlist_add),
          backgroundColor: const Color(0XFF9d870c),
        ));
  }
}
