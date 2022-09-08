// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Admin_Screens/admin_screen.dart';
import 'package:firebase_example/User_Screens/specific_drink_details_screen.dart';
import 'package:firebase_example/models/drink.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/shared/database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  final UserModel user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
      final TextEditingController newNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

CollectionReference collectionReference = FirebaseFirestore.instance
                .collection('users')
                .doc(Database.currentUser.uId)
                .collection('drinks');
 List userDrinks = [];                                 
                                 


  Future<void> createOrUpdate( Drink? drink) async {
   

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: newNameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text( 'Güncelle'),
                  onPressed: () async {
                    CollectionReference collectionReference =
                                  FirebaseFirestore.instance.
                    collection('users').
                    doc(Database.currentUser.uId).
                    collection('drinks');

                      await collectionReference.doc(drink!.uId).update({
                      'name': newNameController.text,
                      'ingredients': descriptionController.text,
                    });
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Successfully Updated",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(milliseconds: 500),
                      ));
                    });
                    newNameController.text = '';
                    descriptionController.text = '';
                  
                  },
                )
              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        top: 10,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            
                            SizedBox(height: 20.0),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminPanel()));
                                },
                                child: Text("AdminPanelGiriş",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))),
                            
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.
                  collection('users').
                  doc(Database.currentUser.uId).
                  collection('drinks').
                  snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                   
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                Database.globalDrinks = snapshot.data!.docs.map((document) {
                  return Drink(
                    uId: document.id,
                    name: document['name'],
                    ingredients: document['ingredients'],
                  );
                }).toList();
                Database.globalDrinks = snapshot.data!.docs.map((document) {
                  return Drink(
                    uId: document.id,
                    name: document['name'],
                    ingredients: document['ingredients'],
                  );
                }).toList();

                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Ürünler : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 191,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => buildProduct(
                                drink: Database.globalDrinks[index],
                              
                                user: widget.user),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 20.0,
                                ),
                            itemCount: Database.globalDrinks.length),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProduct({required Drink drink, required UserModel user,}) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SpecificDrinkDetailsScreen(drink, user)));
        },
        child: Container(
          height: 195,
          width: 170,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              CollectionReference collectionReference =
                                  FirebaseFirestore.instance.
                    collection('users').
                    doc(Database.currentUser.uId).
                    collection('drinks');
                    await collectionReference.doc(drink.uId).delete();
                              
            //                   CollectionReference a = FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(Database.currentUser.uId)
            //     .collection('favorites');

            // await collectionReference.doc(favorite.uId).delete();
                            },
                            
                            
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {createOrUpdate(drink);},
                                  // ,
                            icon: Icon(
                              Icons.update,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      drink.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      drink.ingredients,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
