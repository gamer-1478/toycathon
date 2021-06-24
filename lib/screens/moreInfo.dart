import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoreInfo extends StatefulWidget {
  final String url;
  MoreInfo({this.url});

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).highlightColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "More Info",
            style: TextStyle(
                fontFamily: 'LexendDeca',
                color: Theme.of(context).highlightColor),
          ),
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
