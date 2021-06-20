import 'dart:ffi';

import 'package:basic_banking_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:basic_banking_app/screens/user_details.dart';
import 'package:basic_banking_app/toasts/toast.dart';
import 'package:basic_banking_app/database/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Make Object of some Special Class
  final LocalStorageHelper _localStorageHelper = LocalStorageHelper();
  final FToast _fToast = FToast();

  /// Extract Initialize Data
  void _extractImportantUserData() async {
    await _localStorageHelper.createTableToStoreUserData();
    await _localStorageHelper.createTableForLiveTransactions();
  }

  @override
  void initState() {
    this._fToast.init(context);

    _extractImportantUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(Column(children: [
        Container(
          padding: EdgeInsets.only(top: 120.0, bottom: 100),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Image.network(
              'https://thumbs.dreamstime.com/b/dollar-sign-icon-isolated-purple-background-vector-illustration-eps-dollar-sign-icon-isolated-purple-background-vector-180161144.jpg'),
        ),
        _landingPageColumnWidgets(
            text: 'Basic Banking Application',
            marginFromTopVal: 0.0,
            fontSize: 25.0,
            color: Colors.black),
        _landingPageColumnWidgets(
            text: 'The Sparks Foundation',
            marginFromTopVal: 30.0,
            fontSize: 22.0,
            color: Colors.purple),
        _landingPageColumnWidgets(
            text: 'Click below to experience',
            marginFromTopVal: 30.0,
            fontSize: 15.0,
            color: Colors.black),
        SizedBox(height: 20.0),
        _viewCustomers(),
      ])),
    );
  }

  /// Landing Page Some Instruction Screen
  Widget _landingPageColumnWidgets(
      {@required String text,
        @required double marginFromTopVal,
        @required double fontSize,
        Color color = Colors.white70}) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: marginFromTopVal),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      ),
    );
  }

  /// All Customers List

  Widget _viewCustomers() {
    return Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.symmetric(horizontal: 60.0),
        decoration: BoxDecoration(
          color: Color(0xffE2D3F6),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: GestureDetector(
          child: Text(
            'Bank Customers',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            print('View All Customers Button Pressed');
            try {
              showToast('User Data Extracting', this._fToast,
                  toastGravity: ToastGravity.CENTER,
                  toastColor: Colors.black,
                  bgColor: Color(0xffE2D3F6));
            } catch (e) {
              print('Landing Page Toast Show Error:');
            }
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CustomersView()));
          },
        ));
  }
}
