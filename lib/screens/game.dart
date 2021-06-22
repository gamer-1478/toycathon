import 'package:flutter/services.dart';
import 'package:bharat_mystery/screens/mainGame.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).focusColor,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 200.0, 10.0, 20.0),
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
      ),
    );
  }

  void addUser() {
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
