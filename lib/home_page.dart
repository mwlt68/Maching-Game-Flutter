import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matching_game/game_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eşleşme Oyunu"),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                _pushGamePage(context, 4, 3);
              },
              child: Text(
                "Kolay",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              color: Colors.yellow,
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: FlatButton(
                onPressed: () {
                  _pushGamePage(context, 5, 4);
                },
                child: Text(
                  "Orta",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                color: Colors.amber,
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
              ),
            ),
            FlatButton(
              onPressed: () {
                _pushGamePage(context, 6, 5);
              },
              child: Text(
                "Zor",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              color: Colors.orange,
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          exit(0);
        },
        icon: Icon(
          Icons.exit_to_app,
        ),
        label: Text("ÇIKIŞ"),
      ),
    );
  }

  _pushGamePage(BuildContext context, int columnCount, int rowCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GamePage(
                columnCount: columnCount,
                rowCount: rowCount,
              )),
    );
  }
}
