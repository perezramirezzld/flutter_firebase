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
        appBar: AppBar(
          backgroundColor: Colors.orange,
        ),
        body: FutureBuilder(
          future: getProduct(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: ListTile(
                      title:
                          Text(snapshot.data?[index]['name']?.toString() ?? ''),
                      subtitle: Text(
                          'Price: \$${snapshot.data?[index]['price']?.toString() ?? ''}'),
                      trailing: Icon(
                        Icons.delete_sweep,
                        size: 23,
                      ),
                      iconColor: Colors.orange,
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
            setState(() {});
          },
          child: const Icon(Icons.playlist_add),
        ));
  }
}
