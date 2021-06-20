import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:basic_banking_app/screens/transfer_money.dart';

class UserInformation extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userCurrAcc;

  UserInformation(
      {@required this.userName,
        @required this.userEmail,
        @required this.userCurrAcc});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'User Account Information',
                style: TextStyle(color: Colors.purple, fontSize: 30.0,fontWeight: FontWeight.bold),
              ),
            ),
            _everyUserGeneralInformation('User Name', widget.userName),
            _everyUserGeneralInformation('User Email', widget.userEmail),
            _everyUserGeneralInformation(
                'Bank Balance', 'Rs. ${widget.userCurrAcc}'),
            _transferMoney(),
          ],
        ),
      ),
    );
  }

  Widget _everyUserGeneralInformation(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
      child: Card(
          elevation: 0.0,
          color: Color(0xffE2D3F6),
          child: Container(
            height: 80,
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                  ),
                  child: Text(
                    leftText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      rightText,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _transferMoney() {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: BorderSide(color: Colors.purple),
          ),
        ),
        child: Text(
          'Transfer Money',
          style: TextStyle(color: Colors.purple, fontSize: 25.0),
        ),
        onPressed: () {
          print('Transfer Money Button Clicked');

          /// Some Screen Pop Out
          Navigator.pop(context);
          Navigator.pop(context);

          /// User Selection Page to Transfer Money
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectConnection(
                    currUserEmail: widget.userEmail,
                    currAccountMoney: widget.userCurrAcc,
                    currAccUserName: widget.userName,
                  )));
        },
      ),
    );
  }
}
