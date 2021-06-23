import 'dart:convert';
import 'package:bharat_mystery/screens/availableCards.dart';
import 'package:bharat_mystery/screens/creditDebit.dart';
import 'package:bharat_mystery/screens/userMonuments.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bharat_mystery/screens/homepage.dart' as HomePage;

class MainGame extends StatefulWidget {
  final List players;
  MainGame({this.players});

  @override
  _MainGameState createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  var availableCardsMain = [];
  var player1Cards = [];
  var player2Cards = [];
  var activePlayer = false;
  var player1Money = 0;
  var player2Money = 0;

  Future _setListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("CurrentPlayer", activePlayer);
  }

  Future _getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      player1Money = prefs.getInt("player1Money");
      player2Money = prefs.getInt("player2Money");
      player1Cards =
          List.from(jsonDecode(prefs.getString("player1Cards"))).toList();
      player2Cards =
          List.from(jsonDecode(prefs.getString("player2Cards"))).toList();
    });
  }

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

  Future<bool> _endGame() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to End the Game?'),
            actions: <Widget>[
              //no
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              //yes
              TextButton(
                onPressed: () {
                  widget.players.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage.HomePage()),
                      (Route<dynamic> route) => false);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String player1Initials;
  String player2Initials;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setListFromSharedPref();
    _getListFromSharedPref();
    var nameparts1 = widget.players[0].split(" ");
    if (nameparts1.length == 2) {
      var p1I = nameparts1[0][0].toUpperCase() + nameparts1[1][0].toUpperCase();
      player1Initials = p1I;
    } else {
      var p1I = nameparts1[0][0].toUpperCase();
      player1Initials = p1I;
    }
    var nameparts2 = widget.players[1].split(" ");
    if (nameparts2.length == 2) {
      var p2I = nameparts2[0][0].toUpperCase() + nameparts2[1][0].toUpperCase();
      player2Initials = p2I;
    } else {
      var p2I = nameparts2[0][0].toUpperCase();
      player2Initials = p2I;
    }
  }

  int newDiceImage = 1;
  Color activeColor1 = Colors.black;
  Color activeColor2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: Column(
                children: <Widget>[
                  //players and money
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: activeColor1,
                        radius: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 45,
                          child: Text(
                            player1Initials,
                            style: TextStyle(
                              fontFamily: 'LexendDeca',
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: activeColor2,
                        radius: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 45,
                          child: Text(
                            player2Initials,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'LexendDeca',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '₹' + " " + player1Money.toString(),
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontFamily: 'LexendDeca',
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        '₹' + " " + player2Money.toString(),
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontFamily: 'LexendDeca',
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),

                  //dice and roll
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 100.0,
                        width: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/Dice-$newDiceImage.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        newDiceImage = Random().nextInt(6) + 1;
                        if (activeColor1 == Colors.blue) {
                          activeColor1 = Colors.black;
                          activeColor2 = Colors.blue;
                          activePlayer = true;
                          _setListFromSharedPref();
                        } else {
                          activeColor1 = Colors.blue;
                          activeColor2 = Colors.black;
                          activePlayer = false;
                          _setListFromSharedPref();
                        }
                      });
                    },
                    height: 40.0,
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "Roll Dice",
                      style: TextStyle(
                          fontFamily: 'LexendDeca',
                          fontSize: 16.0,
                          color: Theme.of(context).highlightColor),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),

                  //available monuments
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailableCards(),
                          )).then((value) => {_getListFromSharedPref()});
                    },
                    height: 50.0,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "Available Cards",
                      style: TextStyle(
                          fontFamily: 'LexendDeca',
                          fontSize: 16.0,
                          color: Theme.of(context).cardColor),
                    ),
                    color: Theme.of(context).highlightColor,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  //my monuments
                  MaterialButton(
                    onPressed: () {
                      if (activePlayer == false &&
                          player1Cards.isEmpty == false) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserMonuments(),
                            )).then((value) => {_getListFromSharedPref()});
                      } else if (activePlayer == true &&
                          player2Cards.isEmpty == false) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserMonuments(),
                            )).then((value) => {_getListFromSharedPref()});
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "you have no cards to view, please unlock a card to view more");
                      }
                    },
                    height: 50.0,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "My Cards",
                      style: TextStyle(
                          fontFamily: 'LexendDeca',
                          fontSize: 16.0,
                          color: Theme.of(context).cardColor),
                    ),
                    color: Theme.of(context).highlightColor,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),

                  //Debit Credit to bank or other player
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreditDebit(),
                          )).then((value) => {_getListFromSharedPref()});
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
                  SizedBox(
                    height: 30.0,
                  ),

                  MaterialButton(
                    onPressed: () {
                      _endGame();
                    },
                    height: 50.0,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "End Game",
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
          ),
        ),
      ),
    );
  }
}
