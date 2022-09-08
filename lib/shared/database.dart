// ignore_for_file: unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/drink.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Database {
  static late UserModel currentUser;

  static List<Drink> globalDrinks = [];

  static List<String> favoriteItemsNames = [];

  static List<Drink> addingList = [];

  static bool homePageFirstTime = true;

  static Future<void> addNewProduct({required Drink drink}) async {
    await FirebaseFirestore.instance.collection('drinks').doc(drink.uId).set({
      'ingredients': drink.ingredients,
      'name': drink.name,
    });
  }

  static void addOnce() {
    for (var drink in addingList) {
      FirebaseFirestore.instance.collection('drinks').add({
        'ingredients': drink.ingredients,
        'name': drink.name,
      }).then((value) {});
    }
  }

  static void addMessage({required String message}) {
    FirebaseFirestore.instance.collection('reviews').add({
      'message': message,
    }).then((value) {
      if (kDebugMode) {
        print('A new Reviewing message added successfully');
      }
    });
  }

  static updateDate(String id, String key, String value) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('drinks');

    await collectionReference.doc('$id').update({'$key': '$value'});
  }

  static Future<UserCredential>? userLogin(
      {required String email, required String password}) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static void userLogOut() {
    FirebaseAuth.instance.signOut();
  }

  static Future<UserCredential> userRegister({
    required String email,
    required String password,
    required String username,
  }) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static void userCreate(
      {required String name, required String email, required String uId}) {
    UserModel model = UserModel(uId, name, email);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      if (kDebugMode) {
        print('new user created successfully');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  static void createUserWithFavoriteList(
      {required String email, required String username, required String uId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set({'email': email, 'username': username, 'favorites': {}});
  }

  static void addProductToFavoritesList({String? uId, required String name}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('favorites')
        .add({'product name': name});
  }

  // Updates to the app

  // 1- To add values to a table and choosing the uid of the row
  static Future<void> addValueToTable({
    required String tableName,
    required String rowUId,
    required String ingredients,
    required String name,
  }) async {
    await FirebaseFirestore.instance.collection(tableName).doc(rowUId).set({
      'ingredients': ingredients,
      'name': name,
    });
  }

  // 2- Adding list of values to Table and sorted uId

  static Future<void> addListOfValuesOnce(
      {required List<Drink> myList, required String tableName}) async {
    for (int i = 0; i < myList.length; i++) {
      await addValueToTable(
        tableName: tableName,
        rowUId: myList[i].uId,
        ingredients: myList[i].ingredients,
        name: myList[i].name,
      );
    }
  }
}
