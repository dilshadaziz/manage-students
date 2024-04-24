// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:app/database/db_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<StudentModel>> studentList = ValueNotifier([]);
final collectionRef = firestore.collection('students'); // Replace 'students' with your actual collection name
final firestore = FirebaseFirestore.instance;

Future<bool?> createCollection(StudentModel students) async {
  // Check if collection exists (optional);
  final colRef = firestore.collection('students');
  final colExists = await colRef.get().then((snapshot) => snapshot.size > 0);

  if (!colExists) {
    try {
      // Create an empty document to trigger collection creation
      await colRef.doc().set({
      "name": students.name,
      "age": students.age,
      "father": students.father,
      "pnumber": students.pnumber,
      "imageUrl" : students.imagex,
    });
      print('Collection "students" created');
      return false;
    } catch (error) {
      print('Error creating collection: $error');
    }
  } else {
    print('Collection "students" already exists');
    return true;
  }
}

Future<void> getstudentdata() async {
  print('in getstudenst');
  final snapshot = await collectionRef.get();
  studentList.value.clear();
  print(snapshot.docs.length);
  if(snapshot.docs.isNotEmpty){
    for (var doc in snapshot.docs) {
    final student = StudentModel.fromMap(map: doc.data(),docId: doc.id);
    studentList.value.add(student);
  }
  }
  studentList.notifyListeners();
}


Future<void>  addstudent(StudentModel students) async {
  try {
    final isExist = await createCollection(students);
    print('collection Created $isExist');
    if(isExist!){
      final docRef = await firestore.collection('students').add({
      "name": students.name,
      "age": students.age,
      "father": students.father,
      "pnumber": students.pnumber,
      "imageUrl" : students.imagex,
    });
    print('Student added successfully with ID: ${docRef.id}');
    }
    getstudentdata();
  } catch (error) {
    print('Error adding student: $error');
  }
  
}



Future<void> deleteStudent(String id) async {
  final docRef = firestore.collection('students').doc(id);
  try{
    await docRef.delete();
    print('deleted successfully');
  }
  catch(e){
    print(e);
  }
  getstudentdata();
}

Future<void> editStudent( name, age, father, pnumber,imagex,id) async {
  final docRef = firestore.collection('students').doc(id);
  final dataflow = {
    'name': name,
    'age': age,
    'father': father,
    'pnumber': pnumber,
    'imageUrl': imagex,
  };
  try {
    docRef.update(dataflow);
  } catch (e) {
    print(e);
  }
  getstudentdata();
}





