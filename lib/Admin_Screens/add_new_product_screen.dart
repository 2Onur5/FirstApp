// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Admin_Screens/admin_screen.dart';
import 'package:firebase_example/shared/custom_widgets.dart';
import 'package:firebase_example/shared/database.dart';
import 'package:flutter/material.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({Key? key}) : super(key: key);

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          screenTitle: 'Add New Product',
          backScreen: AdminPanel(),
          context: context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              productTextFormField(
                controller: nameController,
                labelText: 'Product Name',
                validatorReturn: 'value is needed',
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              productTextFormField(
                controller: descriptionController,
                labelText: 'Product Description',
                validatorReturn: 'value is needed',
              ),
              SizedBox(
                height: 20,
              ),
              defaultButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(Database.currentUser.uId)
                        .collection('drinks')
                        .add({
                      'name': nameController.text,
                      'ingredients': descriptionController.text
                    });

                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Successfully Added",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(milliseconds: 500),
                      ));
                    });

                    nameController.text = '';
                    descriptionController.text = '';
                  }
                },
                text: 'Add Product',
              ),
            ],
          ),
        ),
      ),
    );
  }
  //
}
