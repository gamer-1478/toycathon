import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:bharat_mystery/screens/mainGame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  const Game({Key pagekey, this.title}) : super(key: pagekey);
  final String title;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with AutomaticKeepAliveClientMixin {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //exit app on back pressed
    return WillPopScope(onWillPop: _onWillPop, child: GameContent());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class GameContent extends StatefulWidget {
  @override
  _GameContentState createState() => _GameContentState();
}

class _GameContentState extends State<GameContent> {
  String _player1Name, _player2Name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List players = [];

  Future _setListFromSharedPref() async {
    var allCards = [
      {"name": "Ajanta and Ellora Caves", "Snumber": 1, "price": 60, "bnum": 1},
      {"name": "Hawa Mahal", "Snumber": 4, "price": 60, "bnum": 3},
      {"name": "New Delhi Railway Station", "price": 200, "bnum": 5},
      {"name": "Golden Temple", "Snumber": 3, "price": 100, "bnum": 6},
      {"name": "Gateway of India", "Snumber": 2, "price": 100, "bnum": 8},
      {"name": "Humayun’s Tomb", "Snumber": 5, "price": 120, "bnum": 9},
      {"name": "Victoria Memorial", "Snumber": 11, "price": 140, "bnum": 11},
      {"name": "Electric Company", "price": 150, "bnum": 12},
      {"name": "Sun Temple", "Snumber": 7, "price": 140, "bnum": 13},
      {"name": "Agra Fort", "Snumber": 12, "price": 160, "bnum": 14},
      {"name": "Mumbai Railway's Station", "price": 200, "bnum": 15},
      {"name": "Fatehpur Sikri", "Snumber": 15, "price": 180, "bnum": 16},
      {"name": "Mysore Palace", "Snumber": 16, "price": 180, "bnum": 18},
      {"name": "Sanchi Stupa", "Snumber": 14, "price": 200, "bnum": 19},
      {"name": "Lotus Temple", "Snumber": 13, "price": 220, "bnum": 21},
      {"name": " ", "price": 220, "bnum": 23},
      {"name": " ", "price": 240, "bnum": 24},
      {"name": "Howrah Railway Station", "price": 200, "bnum": 25},
      {"name": "Jantar Mantar", "Snumber": 20, "price": 260, "bnum": 26},
      {
        "name": "Vivekananda Rock Memorial",
        "Snumber": 19,
        "price": 260,
        "bnum": 27
      },
      {"name": "Waterways", "price": 150, "bnum": 28},
      {"name": "Charminar", "Snumber": 18, "price": 280, "bnum": 29},
      {"name": "Raj Ghat", "Snumber": 17, "price": 300, "bnum": 31},
      {"name": "Qutub Minar", "Snumber": 8, "price": 320, "bnum": 32},
      {"name": "Red Fort", "Snumber": 9, "price": 320, "bnum": 34},
      {"name": "Chennai Railway Station", "price": 200, "bnum": 35},
      {"name": "India Gate", "Snumber": 6, "price": 350, "bnum": 37},
      {"name": "Taj Mahal", "Snumber": 10, "price": 400, "bnum": 39},
    ];
    final prefs = await SharedPreferences.getInstance();
    String newAllCards = jsonEncode(allCards);
    await prefs.setString("availableCards", newAllCards);
    await prefs.setString("player1Cards", jsonEncode([]));
    await prefs.setString("player2Cards", jsonEncode([]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(
                      "Player Info",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontFamily: 'LexendDeca',
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //textfield player1
                          TextFormField(
                            autocorrect: false,
                            autofocus: false,
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Please provide Player's Name";
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "Player 1 Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[50]),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(20.0)),
                            onSaved: (input) => _player1Name = input,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                          //textfield player1
                          TextFormField(
                            autocorrect: false,
                            autofocus: false,
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Please provide Player's Name";
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "Player 2 Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[50]),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(20.0)),
                            onSaved: (input) => _player2Name = input,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                          MaterialButton(
                            onPressed: addUser,
                            height: 50.0,
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            shape: StadiumBorder(),
                            child: Text(
                              "Start Game",
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
    );
  }

  void addUser() async {
    await _setListFromSharedPref();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      players.add(_player1Name);
      players.add(_player2Name);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainGame(
              players: players,
            ),
          ));
    }
  }
}
