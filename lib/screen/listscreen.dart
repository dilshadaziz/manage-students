import 'dart:io';
import 'package:app/database/db_functions.dart';
import 'package:app/database/db_model.dart';
import 'package:app/screen/editstudent.dart';
import 'package:app/screen/studentdetails.dart';
import 'package:flutter/material.dart';


class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentList,      
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final student = value[index];

            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 1,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(student.imagex)
                ),
                title: Text(student.name),
                subtitle: Text(
                  "Age: ${student.age} \nMobile: +91 ${student.pnumber}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditStudent(student: student),
                        ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deletestudent(context, student);
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctr) => StudentDetails(stdetails: student),
                  ));
                },
              ),
            );
          },
        );
      },
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
        content: Text("Student deleted successfully."),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.of(ctx).pop();
  }
}