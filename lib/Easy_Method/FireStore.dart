import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Easy_Method/Model/StudentDetails.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Db/Database.dart';

class FireStore extends StatefulWidget {
  const FireStore({Key? key}) : super(key: key);

  @override
  State<FireStore> createState() => _FireStoreState();
}

class _FireStoreState extends State<FireStore> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  List<StudDetails>? studentlist;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    getdetails();
  }

  Future<void> getdetails() async {
    var alldata = await DbHelp().getDetailss();
    studentlist?.clear();
    studentlist = alldata;
    loading = false;
    setState(() {});
  }

  Future<void> _create() async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0))),
        context: context,
        isScrollControlled: true,
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
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: _mobileController,
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _nameController.text.length < 3) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
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
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
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
                          final _utcTime = DateTime.now().toUtc();
                          final Localtime = _utcTime.toLocal();
                          print("Create Time:- $Localtime");

                          await DbHelp().addStudent(StudDetails(
                              name: _nameController.text,
                              number: _mobileController.text,
                              date: Localtime.toString()));

                          _nameController.clear();
                          _mobileController.clear();
                          Navigator.of(context).pop();
                          getdetails();
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _nameController.clear();
                        _mobileController.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> _update(StudDetails? stud) async {
    if (stud != null) {
      _nameController.text = stud.name ?? "";
      _mobileController.text = stud.number ?? "";
    }
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0))),
        context: context,
        isScrollControlled: true,
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
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _nameController.text.length < 3) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
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
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
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
                          loading = true;
                          setState(() {});
                          final _utcTime = DateTime.now().toUtc();
                          final Localtime = _utcTime.toLocal();
                          print("Create Time:- $Localtime");

                          stud?.name = _nameController.text;
                          stud?.number = _mobileController.text;
                          stud?.date = Localtime.toString();

                          await DbHelp().updateDetails(
                            stud!,
                          );
                          getdetails();

                          _nameController.clear();
                          _mobileController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _nameController.clear();
                        _mobileController.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? const Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              )
            : ListView.builder(
                itemCount: studentlist?.length,
                itemBuilder: (context, index) {
                  var stud = studentlist?[index];
                  if (stud != null) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        ///Todo ??'' matlab ki aage value null aati hai tab ye blanck yato string mai dali value leta hai
                        title: Text(stud.name ?? ''),
                        subtitle: Text(stud.number ?? ''),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _update(stud);
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    loading = true;
                                    DbHelp().removeDetails(stud);
                                    getdetails();
                                  }),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _create();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
