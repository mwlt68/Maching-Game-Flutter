import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_game/models/mycard.dart';

class GamePage extends StatefulWidget {
  GamePage({this.columnCount, this.rowCount});
  int columnCount, rowCount;
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _isFirstOpenCard = true, _isClickActive = true;
  int _trueCount = 0, _turnAllCount = 0, _timeCounter = 0;
  int _firstIndex = -1, _secondIndex = -1;
  double _imgWidth, _imgHeight;
  List<MyCard> _cards;
  List<Container> _imgs;
  int _gameSize;
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gameSize = widget.columnCount * widget.rowCount;
    if ((_gameSize) % 2 != 0) {
      print("Error : Column count and row count multiply must equal even");
      return null;
    }
    _cards = _getMyCards();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _timerSet());
  }

  @override
  void dispose() {
        timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calculateImageSize();
    return Scaffold(
      appBar: AppBar(
        title: _getTitle,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(7),
            child: FlatButton(
              child: Icon(
                Icons.star,
                color: Colors.white,
                size: 36,
              ),
              color: Colors.lime,
              disabledColor: Colors.redAccent,
              onPressed: _turnAllCount > 0 && _isFirstOpenCard && _isClickActive ? _turnAllCard : null,
            ),
          ),
        ],
      ),
      body: Center(
        child: _getColumns(),
      ),
    );
  }

  Widget get _getTitle => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.timer,
              size: 44,
            ),
          ),
          Text(
            _timeCounter.toString(),
            style: TextStyle(fontSize: 25),
          ),
        ],
      );

  Widget _getColumns() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _getRows(),
    );
  }

  List<Widget> _getRows() {
    List<Widget> rows = new List<Widget>();
    for (var i = 0; i < widget.columnCount; i++) {
      Widget row = _getRow(i);
      rows.add(row);
    }
    return rows;
  }

  Widget _getRow(int columnIndex) {
    return Row(
      children: _getImages(columnIndex),
    );
  }

  List<Widget> _getImages(int columnIndex) {
    List<Widget> images = new List<Widget>();
    for (var i = 0; i < widget.rowCount; i++) {
      int index = columnIndex * widget.rowCount + i;
      images.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              _cardClick(index);
            },
            child: Container(
              width: _imgWidth,
              height: _imgHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_cards.elementAt(index).getImgAsset()),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return images;
  }

  List<MyCard> _getMyCards() {
    double halfOfSize = (_gameSize / 2);
    List<MyCard> cards = new List<MyCard>();
    for (var i = 0; i < _gameSize; i++) {
      int indexVal = (i % halfOfSize.toInt());
      cards.add(new MyCard(i, imgId: indexVal));
    }
    Random random = new Random();
    for (var i = 0; i < _gameSize; i++) {
      int rndFirst = random.nextInt(_gameSize);
      int rndSecond = random.nextInt(_gameSize);
      var temp = cards.elementAt(rndFirst).imgId;
      cards.elementAt(rndFirst).imgId = cards.elementAt(rndSecond).imgId;
      cards.elementAt(rndSecond).imgId = temp;
    }
    return cards;
  }

  void _calculateImageSize() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    _imgHeight = ((screenHeight - 50) /
        (widget.columnCount + (widget.columnCount * 0.33)));
    _imgWidth = ((screenWidth - 30) / widget.rowCount);
  }

  _cardClick(int index) {
    if (_cards.elementAt(index).isOpen || !_isClickActive) {
      return;
    }
    if (_isFirstOpenCard) {
      _firstIndex = index;
      _isFirstOpenCard = false;
      setState(() {
        _cards.elementAt(_firstIndex).isOpen = true;
      });
    } else {
      _isFirstOpenCard = true;
      _secondIndex = index;
      _isClickActive = false;
      setState(() {
        _cards.elementAt(_secondIndex).isOpen = true;
      });
      if (_cards.elementAt(_firstIndex).imgId !=
          _cards.elementAt(_secondIndex).imgId) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _cards.elementAt(_firstIndex).isOpen = false;
            _cards.elementAt(_secondIndex).isOpen = false;
            _isClickActive = true;
          });
        });
      } else {
        setState(() {
          _trueCount++;
          if (_trueCount % 3 == 0) _turnAllCount++;
          _isClickActive = true;
          _gameFinishCheck();
        });
      }
    }
  }

  void _turnAllCard() {
    _turnAllCount--;
    _isClickActive = false;
    List<MyCard> turnOfCards = new List<MyCard>();
    for (var card in _cards) {
      if (!card.isOpen) {
        turnOfCards.add(card);
        setState(() {
          card.isOpen = true;
        });
      }
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      for (var card in turnOfCards) {
        setState(() {
          _cards.elementAt(card.index).isOpen = false;
        });
      }
      _isClickActive = true;
    });
  }

  void _timerSet() {
    setState(() {
      _timeCounter++;
    });
  }

  void _gameFinishCheck() {
    if (_gameSize == 2 * _trueCount) {
         timer?.cancel();
      _showGameFinishDialog();
    }
  }

  void _showGameFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.timer,
                size: 44,
                color: Colors.blue,
              ),
            ),
            Text(
              _timeCounter.toString(),
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        content: Text(
            "Tebrikler oyunu kazandınız.Ana menüye dönebilir yada yeniden başlatabilirsiniz."),
        actions: [
          FlatButton(
              color: Colors.teal,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Ana Menü")),
          FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
              child: Text("Tekrar Oyna")),
        ],
      ),
    );
  }

}
