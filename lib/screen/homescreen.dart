import 'package:app/database/db_functions.dart';
import 'package:app/screen/addstudent.dart';
import 'package:app/screen/gridscreen.dart';
import 'package:app/screen/listscreen.dart';
import 'package:app/screen/searchscreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  int _selectedIndex = 0;
  int _viewMode = 0; // 0 for Grid, 1 for List
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    getstudentdata(); 
    
    return Scaffold(
      backgroundColor: Colors.indigoAccent.shade100,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 117, 238, 177),
        title: const Text('Students Record'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctxs) => const SearchScreen()));
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child:_viewMode == 0
                  ? const StudentListGridView()
                  : const StudentList()), 
                
              
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Visibility(
        visible: true, // Show the add button
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade100,
          shape: const CircleBorder(),
          elevation: 2, // shadow
          onPressed: () {
            addstudent(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(items: const [
         Icon(Icons.grid_view_outlined,),
         Icon(Icons.list),
      ],
      color: Colors.teal.shade200,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.indigoAccent.shade100,

      animationDuration: const Duration(milliseconds: 300),
      
      index: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _viewMode = index;
          });
        },
      
      ),

    );
  }

  void addstudent(gtx) {
    Navigator.of(gtx)
        .push(MaterialPageRoute(builder: (gtx) => const AddStudent()));
  }
}