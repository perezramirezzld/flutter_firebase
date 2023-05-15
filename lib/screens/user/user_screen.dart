import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/user/adduser_screen.dart';
import 'package:flutter_firebase/service/firebase_service.dart';

class user_screen extends StatefulWidget {
  user_screen({Key? key}) : super(key: key);

  @override
  State<user_screen> createState() => _user_screenState();
}

class _user_screenState extends State<user_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Screen'),
          backgroundColor: Colors.orange,
        ),
        body: FutureBuilder(
          future: getUser(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) async => deleteUser(
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
                          color: Colors.orange,
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
                            'Age: ${snapshot.data?[index]['age']?.toString() ?? ''}'),
                        trailing: Icon(
                          Icons.delete_sweep,
                          size: 23,
                        ),
                        iconColor: Colors.orange,
                        onTap: () async {
                          print(snapshot.data?[index]['uid']);
                          await Navigator.pushNamed(context, '/user_detail',
                              arguments: {
                                'name': snapshot.data?[index]['name'],
                                'lastname': snapshot.data?[index]['lastname'],
                                'age': snapshot.data?[index]['age'],
                                'gender': snapshot.data?[index]['gender'],
                                'email': snapshot.data?[index]['email'],
                                'password': snapshot.data?[index]['password'],
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
                builder: (context) => adduser(),
              ),
            );
            setState(() {
              // ignore: unnecessary_statements
              getUser();
            });
          },
          child: const Icon(Icons.playlist_add),
        ));
  }
}
