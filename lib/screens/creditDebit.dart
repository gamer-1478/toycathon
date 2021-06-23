import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditDebit extends StatefulWidget {
  const CreditDebit();

  @override
  _CreditDebitState createState() => _CreditDebitState();
}

class _CreditDebitState extends State<CreditDebit> {
  String _ammount;
  bool _ischecked = false, _toFrom = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var currentPlayer = false;
  var player1Money = 0;
  var player2Money = 0;

  Future _setListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("player1Money", player1Money);
    prefs.setInt("player2Money", player2Money);
    Fluttertoast.showToast(msg: "transaction successfull!!");
    Navigator.of(context).pop();
  }

  Future _getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      player1Money = prefs.getInt("player1Money");
      player2Money = prefs.getInt("player2Money");
      currentPlayer = prefs.getBool("CurrentPlayer");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListFromSharedPref();
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) {
          Navigator.of(context).pop(true);
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).focusColor,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0),
                    child: Column(
                      children: <Widget>[
                        //text on top
                        Text(
                          "Ammount to Pay/Get",
                          style: TextStyle(
                            color: Theme.of(context).highlightColor,
                            fontFamily: 'LexendDeca',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        //Pay/Get
                        CheckboxListTile(
                            title: const Text('Pay'),
                            value: _ischecked,
                            onChanged: (bool value) {
                              setState(() {
                                _ischecked = value;
                              });
                            }),
                        CheckboxListTile(
                            title: const Text('Get'),
                            value: !_ischecked,
                            onChanged: (bool value) {
                              setState(() {
                                _ischecked = !value;
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),

                        //To/From bank/player
                        CheckboxListTile(
                            title: const Text('To/From Bank'),
                            value: _toFrom,
                            onChanged: (bool value) {
                              setState(() {
                                _toFrom = value;
                              });
                            }),
                        CheckboxListTile(
                            title: const Text('To/From Player'),
                            value: !_toFrom,
                            onChanged: (bool value) {
                              setState(() {
                                _toFrom = !value;
                              });
                            }),
                        SizedBox(
                          height: 30.0,
                        ),

                        //enter ammount
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              //textfield ammount
                              TextFormField(
                                autocorrect: false,
                                autofocus: false,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return "Please provide the ammount in number";
                                  }
                                  return null;
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    hintText: "Amount to Pay/Get",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[50]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(20.0)),
                                onSaved: (input) => _ammount = input,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),

                              MaterialButton(
                                onPressed: () {
                                  final formState = _formKey.currentState;

                                  if (formState.validate()) {
                                    formState.save();
                                    if (currentPlayer == false) {
                                      if (_ischecked == true) {
                                        if (_toFrom == true) {
                                          player1Money = player1Money -
                                              int.parse(_ammount);
                                        } else {
                                          player1Money = player1Money -
                                              int.parse(_ammount);
                                          player2Money = player2Money +
                                              int.parse(_ammount);
                                        }
                                      } else {
                                        if (_toFrom == true) {
                                          player1Money = player1Money +
                                              int.parse(_ammount);
                                        } else {
                                          player1Money = player1Money +
                                              int.parse(_ammount);
                                          player2Money = player2Money -
                                              int.parse(_ammount);
                                        }
                                      }
                                    } else {
                                      if (_ischecked == true) {
                                        if (_toFrom == true) {
                                          player2Money = player2Money -
                                              int.parse(_ammount);
                                        } else {
                                          player2Money = player2Money -
                                              int.parse(_ammount);
                                          player1Money = player1Money +
                                              int.parse(_ammount);
                                        }
                                      } else {
                                        if (_toFrom == true) {
                                          player2Money = player2Money +
                                              int.parse(_ammount);
                                        } else {
                                          player2Money = player2Money +
                                              int.parse(_ammount);
                                          player1Money = player1Money -
                                              int.parse(_ammount);
                                        }
                                      }
                                    }
                                  }
                                  print(player1Money.toString() +
                                      " " +
                                      player2Money.toString());
                                  _setListFromSharedPref();
                                },
                                height: 50.0,
                                padding: EdgeInsets.symmetric(horizontal: 40.0),
                                shape: StadiumBorder(),
                                child: Text(
                                  "Debit/Credit",
                                  style: TextStyle(
                                      fontFamily: 'LexendDeca',
                                      fontSize: 16.0,
                                      color: Theme.of(context).cardColor),
                                ),
                                color: Theme.of(context).highlightColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 20.0,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
