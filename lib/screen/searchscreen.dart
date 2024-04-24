import 'dart:io';
import 'package:app/database/db_functions.dart';
import 'package:app/database/db_model.dart';
import 'package:app/screen/editstudent.dart';
import 'package:app/screen/studentdetails.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<StudentModel> finduser = [];

  @override
  void initState() {
    super.initState();
    finduser = studentList.value;
    // Initialize with the current student list
  }

  void _runFilter(String enteredKeyword) {
    List<StudentModel> result = [];
    if (enteredKeyword.isEmpty) {
      result = studentList.value;
      // Reset to the original list if the search is empty
    } else {
      // Filter based on student properties
      result = studentList.value
          .where((student) =>
              student.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              student.age
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      finduser = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 246, 240),
      body: SafeArea(
        child: ValueListenableBuilder<List<StudentModel>>(
          valueListenable: studentList,
          builder: (context, studentListValue, child) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: finduser.length,
                      itemBuilder: (context, index) {
                        final finduserItem = finduser[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(finduserItem.imagex),
                            ),
                            title: Text(finduserItem.name),
                            subtitle: Text('CLASS : ${finduserItem.age}'),
                            trailing:Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => EditStudent(student: finduserItem),
                        ));
                      },
                    ),
                    IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deletestudent(context, finduserItem);
                      },
                    ),
                  ],
                ), 
                            // IconButton(
                            //     onPressed: () {
                            //       Navigator.of(context)
                            //           .pushReplacement(MaterialPageRoute(
                            //         builder: (context) =>
                            //             EditStudent(student: finduserItem),
                            //       ));
                            //     },
                            //     icon: const Icon(Icons.edit)),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (ctr) =>
                                    StudentDetails(stdetails: finduserItem),
                              ));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    
  }
  void deletestudent(rtx, StudentModel student) {
    showDialog(
      context: rtx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure want to delete ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(rtx);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                delectYes(context, student);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void delectYes(ctx, StudentModel student) {
    deleteStudent(student.id!);
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text("Successfully Deleted"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(ctx).pop();
  }
}