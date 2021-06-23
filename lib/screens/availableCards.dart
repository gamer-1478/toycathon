import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableCards extends StatefulWidget {
  //final List availableCards;
  const AvailableCards();

  @override
  _AvailableCardsState createState() => _AvailableCardsState();
}

class _AvailableCardsState extends State<AvailableCards> {
  var currentPlayer = false;
  var player1Cards = [];
  var player2Cards = [];
  var gottenCards = [];

  Future _getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    gottenCards = await jsonDecode(prefs.getString("availableCards"));
    currentPlayer = prefs.getBool("CurrentPlayer");
    player1Cards = await jsonDecode(prefs.getString("player1Cards"));
    player2Cards = await jsonDecode(prefs.getString("player2Cards"));
    log(gottenCards.toString());
    return (gottenCards);
  }

  Future _setListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("availableCards", jsonEncode(gottenCards));
    await prefs.setString("player1Cards", jsonEncode(player1Cards));
    await prefs.setString("player2Cards", jsonEncode(player2Cards));
    _onWillPop();
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
          /*if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Theme.of(context).focusColor,
              body: Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              )),
            );
          }
          final gottenCards = json.decode(snapshot.data);*/

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
                                  return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Are you sure?'),
                                          content: Text(
                                              'You landed on this monument and wish to unlock it?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (currentPlayer == false) {
                                                  player1Cards.addAll(
                                                      gottenCards[index]);
                                                  gottenCards.removeAt(index);
                                                  _setListFromSharedPref();
                                                } else {
                                                  player2Cards.addAll(
                                                      gottenCards[index]);
                                                  gottenCards.removeAt(index);
                                                  _setListFromSharedPref();
                                                }
                                              },
                                              child: Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      ) ??
                                      false;
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
