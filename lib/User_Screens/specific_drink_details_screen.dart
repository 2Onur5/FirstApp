// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/drink.dart';
import 'package:firebase_example/models/favorite.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/shared/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecificDrinkDetailsScreen extends StatefulWidget {
  // const SpecificDrinkDetailsScreen({Key? key}) : super(key: key);

  final UserModel user;

  final Drink drink;
  SpecificDrinkDetailsScreen(this.drink, this.user);

  @override
  _SpecificDrinkDetailsScreenState createState() =>
      _SpecificDrinkDetailsScreenState();
}

class _SpecificDrinkDetailsScreenState
    extends State<SpecificDrinkDetailsScreen> {
  @override
  int smallCounter = 0;
  int mediumCounter = 1;
  int largeCounter = 0;

  double calculateTotalCost() {
    return double.parse(
            (smallCounter + mediumCounter + largeCounter).toString()) +
        double.parse(
            ((smallCounter + mediumCounter + largeCounter) * 0.1).toString());
  }

  List<Favorite> userFavorites = [];
  Color _iconColor = Colors.grey;

  bool alreadyInFavorites = false;

  Widget build(BuildContext context) {
    gettingFavorites();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Database.currentUser.uId)
            .collection('favorites')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          userFavorites = snapshot.data!.docs.map((document) {
            return Favorite(document['product name'].toString(), document.id);
          }).toList();

          for (int i = 0; i < userFavorites.length; i++) {
            if (userFavorites[i].productName == widget.drink.name) {
              alreadyInFavorites = true;
              _iconColor = Colors.red;
              break;
            }
          }

          return Scaffold(
            backgroundColor: Colors.brown[700],
            body: SafeArea(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2 - 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 10, 5),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.brown[800],
                                  size: 26,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.only(right: 20),
                                onPressed: () {
                                  if (!alreadyInFavorites) {
                                    Database.addProductToFavoritesList(
                                        uId: widget.user.uId,
                                        name: widget.drink.name);
                                  }
                                  setState(() {
                                    if (_iconColor == Colors.red) {
                                      _iconColor = Colors.grey;
                                    } else if (_iconColor == Colors.grey) {
                                      _iconColor = Colors.red;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  size: 26,
                                ),
                                color: _iconColor,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      widget.drink.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[300],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 210,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          widget.drink.ingredients,
                                          // maxLines: 14,
                                          // overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.brown[300],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<Favorite> gettingFavorites() {
    List<Favorite> fav = [];

    StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Database.currentUser.uId)
            .collection('favorites')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          fav = snapshot.data!.docs.map((document) {
            return Favorite(document['product name'].toString(), document.id);
          }).toList();
          return Center();
        });
    fav.forEach((element) {
      print('UID: ${element.uId}');
      print('Product: ${element.productName}');
    });
    return fav;
  }
}
