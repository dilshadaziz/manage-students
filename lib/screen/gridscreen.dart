import 'package:app/database/db_functions.dart';
import 'package:app/screen/studentdetails.dart';
import 'package:flutter/material.dart';

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

            mainAxisExtent: (MediaQuery.sizeOf(context).width*0.01).floor()-2 <3 ? null: (MediaQuery.sizeOf(context).height*0.4) ,
            crossAxisCount: (MediaQuery.sizeOf(context).width*0.01).floor()-2 > 6 ? 6 : (MediaQuery.sizeOf(context).width*0.01).floor()-2 < 2? 2:(MediaQuery.sizeOf(context).width*0.01).floor()-2, // Set the number of columns here
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
                      maxRadius:(MediaQuery.sizeOf(context).width*0.01).floor()-2 <3 ? 30 : MediaQuery.sizeOf(context).width*0.04,
                    ),
                    const SizedBox(height: 12),
                    Text(student.name),
                    Text(
                      "Age: ${student.age}, \nMobile: +91 - ${student.pnumber}",
                    ),
                    SizedBox(height:(MediaQuery.sizeOf(context).width*0.1).floor()-2 > 2 ?  25 : 14,)
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
