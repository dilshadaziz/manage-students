import 'dart:io';
import 'dart:typed_data';
import 'package:app/database/db_functions.dart';
import 'package:app/database/db_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
                                                              

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  PlatformFile? pickedFile;
  String? imageName;
  final _formKey = GlobalKey<FormState>(); // Add a form key for the validation

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 117, 238, 177),
        title: const Text('Add Student'),
        actions: [
          TextButton.icon(
            label: const Text('Save'),
            onPressed: () {
              addstudentclicked(context);
              
            },
            icon: const Icon(Icons.save_rounded),
          )
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.cyan.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, // The form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                        backgroundImage: pickedFile != null
                            ? MemoryImage(pickedFile!.bytes!)
                            : null 
                                ,
                        radius: 100),
                    Positioned(
                      bottom: 20,
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: const Icon(Icons.add_a_photo_outlined),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        iconSize: 40,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Name input field with validation
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.abc_outlined),
                    suffixIconColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Age input field with validation
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.perm_contact_cal_sharp),
                    suffixIconColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Guardian input field with validation
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _guardianController,
                  decoration: InputDecoration(
                    labelText: "Guardian",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.person),
                    suffixIconColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Guardian';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Mobile input field with validation
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  decoration: InputDecoration(
                    
                    labelText: "Mobile",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.phone_sharp),
                    suffixIconColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Mobile';
                    } else if (value.length != 10) {
                      return 'Mobile number should be 10 digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> addstudentclicked(mtx) async {
    if (_formKey.currentState!.validate() && pickedFile != null) {
      final name = _nameController.text.toUpperCase();
      final age = _ageController.text.toString().trim();
      final father = _guardianController.text;
      final phonenumber = _mobileController.text.trim();
      
      imageName = await uploadFile();
      print('image Uploaded');

      final stdData = StudentModel(
        name: name,
        age: age,
        father: father,
        pnumber: phonenumber,
        imagex: imageName!,
      );

      await addstudent(stdData); // Use the correct function name addStudent.
      print("db updated");

      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text("Successfully added"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        pickedFile = null;
        _nameController.clear();
        _ageController.clear();
        _guardianController.clear();
        _mobileController.clear();
      });
      print('pop');
      Navigator.of(mtx).pop();
      print('popped');

    } else {
      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text('Add all details'),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> getImage() async {
    
  final result = await FilePicker.platform.pickFiles(type: FileType.image,allowMultiple: false,);
  if(result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
}
Future<String> uploadFile() async{
  try {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('images').child(pickedFile!.name);
    final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/png');
    await ref.putData(pickedFile!.bytes!,metadata);
    print('inserted');
    final downloadedUrl = await ref.getDownloadURL();
    print('download : $downloadedUrl');
    return downloadedUrl;
  } catch (error) {
    print('Error uploading file: $error');
    // Handle upload error (e.g., show error message to user)
  }
    return '';
  }

  
}