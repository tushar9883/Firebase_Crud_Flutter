import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('user');

  final col_ref = FirebaseFirestore.instance
      .collection('user')
      .orderBy('date', descending: true);

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _nameController.text.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color(0xfff8eced),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                        content: Text(
                          "Enter Valid Name",
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontFamily: 'Strait',
                          ),
                        ),
                      ));
                    } else if (_mobileController.text.isEmpty ||
                        _mobileController.text.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color(0xfff8eced),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Enter Mobile Number",
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontFamily: 'Strait',
                          ),
                        ),
                      ));
                    } else {
                      final name = _nameController.text;
                      final mobile = _mobileController.text;

                      final _utcTime = DateTime.now().toUtc();
                      final Localtime = _utcTime.toLocal();
                      print("Create Time:- ${Localtime}");
                      print("Name:- ${name}");
                      print("Number:- ${mobile}");
                      final datee = Localtime.toString();

                      await _products
                          .add({"name": name, "mobile": mobile, "date": datee});

                      _nameController.text = '';
                      _mobileController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _mobileController.text = documentSnapshot['mobile'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _nameController.text.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color(0xfff8eced),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                        content: Text(
                          "Enter Valid Name",
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontFamily: 'Strait',
                          ),
                        ),
                      ));
                    } else if (_mobileController.text.isEmpty ||
                        _mobileController.text.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color(0xfff8eced),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Enter Mobile Number",
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontFamily: 'Strait',
                          ),
                        ),
                      ));
                    } else {
                      final name = _nameController.text;
                      final mobile = _mobileController.text;
                      print("Update Name:- ${name}");
                      print("Update Number:- ${mobile}");
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"name": name, "mobile": mobile});
                      _nameController.text = '';
                      _mobileController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await FirebaseFirestore.instance.collection('user').doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Color(0xfff8eced),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      content: Text(
        "You have successfully deleted a product",
        style: TextStyle(
          color: Color(0xff555555),
          fontSize: 18,
          fontFamily: 'Strait',
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: col_ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['mobile']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _update(documentSnapshot);
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  print("Delete Id:- ${documentSnapshot.id}");
                                  _delete(documentSnapshot.id);
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: RaisedButton(
        color: Colors.lightGreen,
        onPressed: () {
          _create();
        },
        child: Text(
          "Add Data",
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
