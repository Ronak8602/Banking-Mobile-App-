import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:basic_banking_app/database/database.dart';
import 'package:basic_banking_app/toasts/wrong_info.dart';
import 'package:basic_banking_app/screens/user_details.dart';
import 'package:basic_banking_app/toasts/toast.dart';

class SelectConnection extends StatefulWidget {
  /// Information About Profile Opened User
  final String currUserEmail;
  final String currAccUserName;
  final String currAccountMoney;

  SelectConnection(
      {@required this.currUserEmail,
        @required this.currAccountMoney,
        @required this.currAccUserName});

  @override
  _SelectConnectionState createState() => _SelectConnectionState();
}

class _SelectConnectionState extends State<SelectConnection> {
  final List<Map<String, String>> _usersCollection = [];

  final LocalStorageHelper _localStorageHelper = LocalStorageHelper();
  final FToast _fToast = FToast();

  final TextEditingController _amountTake = TextEditingController();

  void _initialDataCollect() async {
    final List<Map<String, Object>> _usersCollection =
    await _localStorageHelper.extractDataFromUserStoredData();

    if (_usersCollection != null && _usersCollection.isNotEmpty) {
      _usersCollection.forEach((everyUserData) {
        if (mounted) {
          setState(() {
            if (everyUserData['user_mail'].toString() != widget.currUserEmail)
              this._usersCollection.add({
                everyUserData['user_name'].toString():
                "${everyUserData['user_mail'].toString()}[[[separator]]]${everyUserData['user_balance'].toString()}",
              });
          });
        }
      });
    }
  }

  @override
  void initState() {
    this._fToast.init(context);
    this._amountTake.text = '';

    this._initialDataCollect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.purple,
          elevation: 10.0,
          shadowColor: Colors.white70,
          title: Text(
            'Select User to Transfer Money',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: this._usersCollection.length,
            itemBuilder: (context, index) {
              return _everyUserGeneralInformation(index);
            },
          ),
        ));
  }

  Widget _everyUserGeneralInformation(int index) {
    return Card(
        elevation: 0.0,
        color: Color(0xffE2D3F6),
        child: Container(
          height: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffE2D3F6),
              onPrimary: Colors.black,
              elevation: 0.0,
            ),
            onPressed: () {
              print('Transfer Money');

              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    title: Center(
                      child: Text(
                        'Enter Transfer Amount',
                        style:
                        TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: double.maxFinite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextField(
                            autofocus: true,
                            controller: this._amountTake,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: 'Money to Transfer',
                                labelStyle:
                                TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.purple),
                                )),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                    side: BorderSide(color: Colors.black),
                                  )),
                              child: Text(
                                'Transfer',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              onPressed: () async {
                                await _transferMoney(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          this._usersCollection[index].keys.first.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontSize: 18.0),
                        ),
                        Text(
                          this
                              ._usersCollection[index]
                              .values
                              .first
                              .toString()
                              .split('[[[separator]]]')[0],
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Colors.black54, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Rs. ${this._usersCollection[index].values.first.toString().split('[[[separator]]]')[1]}',
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _transferMoney(int index) async {
    print('Money Transfer');

    /// If amount not entered
    if (this._amountTake.text != '') {
      if (double.parse(this._amountTake.text) >
          double.parse(widget.currAccountMoney)) {
        showCommonDialog(
            title: 'Entered Amount greater than your account balance',
            context: context,
            titleTextFontSize: 16.0,
            titleTextColor: Colors.black);
      } else {
        /// Selected User Current Balance Take
        final String targetUserCurrBalance =
        await _localStorageHelper.extractCurrAmountOrCurrUserName(this
            ._usersCollection[index]
            .values
            .first
            .toString()
            .split('[[[separator]]]')[0]);

        /// Will Money Credited account value sum up
        final double sumUpValue = double.parse(this._amountTake.text) +
            double.parse(targetUserCurrBalance);

        /// Data Update for change Bank Balance of selected user
        bool response = await _localStorageHelper.updateAccountBalance(
            updatedBal: sumUpValue.toString(),
            userEmail: this
                ._usersCollection[index]
                .values
                .first
                .toString()
                .split('[[[separator]]]')[0]);

        /// Current User Profile make Deducted Value
        final double currUserDeductedValue =
            double.parse(widget.currAccountMoney) -
                double.parse(this._amountTake.text);

        /// Data Update for change Bank Balance of Current user
        response = await _localStorageHelper.updateAccountBalance(
            updatedBal: currUserDeductedValue.toString(),
            userEmail: widget.currUserEmail);

        /// If updated data insertion successful
        if (response) {
          /// Transaction Table data insert according to Tasks Insertion
          await _localStorageHelper.insertDataInTransactionTable(
              creditedEmail: this
                  ._usersCollection[index]
                  .values
                  .first
                  .toString()
                  .split('[[[separator]]]')[0],
              creditedName: this._usersCollection[index].keys.first.toString(),
              debitedEmail: widget.currUserEmail,
              debitedName: widget.currAccUserName,
              transactedAmount: this._amountTake.text);

          /// Current Screen pop out
          Navigator.pop(context);

          /// Show Message about Transfer Successful
          showToast('Transfer Successful', this._fToast,
              bgColor: Color(0xffE2D3F6),
              toastColor: Colors.black, toastGravity: ToastGravity.CENTER);

          /// Some Reset Operation
          if (mounted) {
            setState(() {
              this._amountTake.clear();
            });
          }

          /// Transfer Users Selection Page Pop Out
          Navigator.pop(context);

          /// Switch to All Customer Information View Page
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CustomersView()));
        } else

          /// Transfer Failed message show
          showCommonDialog(title: 'Transfer Failed', context: context);
      }
    } else {
      /// empty field not accepted message show
      showCommonDialog(title: "Empty Field Can't Accepted", context: context);
    }
  }
}
