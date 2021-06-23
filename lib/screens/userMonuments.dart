import 'dart:convert';
import 'package:bharat_mystery/screens/monument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMonuments extends StatefulWidget {
  const UserMonuments();

  @override
  _UserMonumentsState createState() => _UserMonumentsState();
}

class _UserMonumentsState extends State<UserMonuments> {
  var currentPlayer = false;
  List player1Cards = [];
  List player2Cards = [];
  List gottenCards = [];
  Future _getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    currentPlayer = prefs.getBool("CurrentPlayer");
    player1Cards =
        List.from(await jsonDecode(prefs.getString("player1Cards"))).toList();
    player2Cards =
        List.from(await jsonDecode(prefs.getString("player2Cards"))).toList();

    if (currentPlayer == false) {
      gottenCards = player1Cards;
    } else {
      gottenCards = player2Cards;
    }
  }

  @override
  void initState() {
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
    return FutureBuilder(
        future: _getListFromSharedPref(),
        builder: (context, snapshot) {
          return WillPopScope(
              onWillPop: _onWillPop,
              child: Container(
                  child: Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                        child: ListView.builder(
                          itemCount: gottenCards
                              .length, // response from db <List of dicts>(json decoded)
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Icon(Icons.place,
                                    color: Theme.of(context).highlightColor),
                                title: Text((gottenCards[index])["name"],
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).highlightColor)),
                                tileColor: Theme.of(context).cardColor,

                                // checks, which player it is, if player one it adds to his array if player two it adds to his. And removes from array of the board.
                                onTap: () {
                                  if (gottenCards[index]
                                      .containsKey("Snumber")) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Monument(
                                            snumber:
                                                (gottenCards[index])["Snumber"],
                                          ),
                                        ));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Data Will be added In the Future!! Stay Tuned..");
                                  }
                                },
                              ),
                            );
                          },
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
              )));
        });
  }
}
