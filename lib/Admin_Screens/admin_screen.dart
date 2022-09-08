// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:firebase_example/Admin_Screens/add_new_product_screen.dart';
import 'package:firebase_example/shared/custom_widgets.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool deletePressed = false;
  TextEditingController uIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridView.count(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                children: [
                  adminButton(
                      onPressed: () {
                        print('Add New Product');
                        navigateTo(
                            context: context, screen: AddNewProductScreen());
                      },
                      iconData: Icons.add_box_rounded,
                      buttonText: 'Add new\n Product'),
                  
                  
                ],
              ),
            ],
          ),
          myConditionalBuilder(
            condition: deletePressed,
            builder: AddNewProductScreen(),
            fallback: SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget adminButton(
      {required Function() onPressed,
      required IconData iconData,
      required String buttonText}) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 5,
            color: Colors.brown,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 50,
              color: Colors.brown,
            ),
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, color: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }


}
