import 'dart:io';
import 'dart:ui_web';
import 'package:app/database/db_functions.dart';
import 'package:app/screen/studentdetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class StudentListGridView extends StatelessWidget {
  const StudentListGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('${} mediaquery');
    return ValueListenableBuilder(
      valueListenable: studentList,
      builder: (context, value, child) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: (MediaQuery.sizeOf(context).height*0.3),
            crossAxisCount: (MediaQuery.sizeOf(context).width*0.01).floor()-2 > 6 ? 6 : (MediaQuery.sizeOf(context).width*0.01).floor()-2, // Set the number of columns here
          ),
          itemCount: value.length,
          itemBuilder: (context, index){
            final student = value[index];
            final net = NetworkImage(student.imagex);
            print("net $net");
            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 1,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    
                    MaterialPageRoute(
                      builder: (ctr) => StudentDetails(stdetails: student),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: net,
                      // radius: 30,
                      minRadius: 10,
                      maxRadius: MediaQuery.sizeOf(context).width*0.04,
                    ),
                    const SizedBox(height: 12),
                    Text(student.name),
                    Text(
                      "Age: ${student.age}, \nMobile: +91 - ${student.pnumber}",
                    ),
                    const SizedBox(height: 30,)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
