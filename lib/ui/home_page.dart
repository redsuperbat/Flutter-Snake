import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake/core/home_page_model.dart';
import 'package:snake/core/square.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageModel model = Provider.of<HomePageModel>(context);
    final double boxsize = MediaQuery.of(context).size.height * 0.02;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          StreamBuilder<int>(
              stream: model.highScoreController.stream,
              builder: (context, snapshot) => Text("Highscore: " +
                  (snapshot.hasData ? snapshot.data.toString() : ""))),
          StreamBuilder<int>(
            stream: model.score.stream,
            builder: (context, snapshot) => Text(
              "Score: " + (snapshot.hasData ? snapshot.data.toString() : "0"),
              style: TextStyle(fontSize: 50),
            ),
          ),
          Center(
            child: StreamBuilder<List<Square>>(
              stream: model.controller.stream,
              builder: (context, snapshot) => snapshot.hasData
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      width: boxsize * 20,
                      height: boxsize * 27,
                      child: Stack(
                        children: [
                          for (var item in snapshot.data)
                            Positioned(
                              top: item.y * boxsize,
                              left: item.x * boxsize,
                              child: Image.asset(
                                "assets/bock.png",
                                height: boxsize,
                                width: boxsize,
                              ),
                            ),
                          Positioned(
                            top: model.food.y * boxsize,
                            left: model.food.x * boxsize,
                            child: Image.asset(
                              "assets/hay.png",
                              height: boxsize,
                              width: boxsize,
                            ),
                          ),
                        ],
                      ),
                    )
                  : MaterialButton(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            model.message,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onPressed: () => model.start(),
                    ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Expanded(
            child: Buttons(model: model),
          ),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final HomePageModel model;

  const Buttons({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: double.infinity,
            child: FlatButton(
              color: Colors.red,
              child: Text("Left"),
              onPressed: () => model.changeDir("l"),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: FlatButton(
                  color: Colors.green,
                  child: Text("Up"),
                  onPressed: () => model.changeDir("u"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: FlatButton(
                  color: Colors.yellow,
                  child: Text("Down"),
                  onPressed: () => model.changeDir("d"),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            height: double.infinity,
            child: FlatButton(
              color: Colors.blue,
              child: Text("Right"),
              onPressed: () => model.changeDir("r"),
            ),
          ),
        ),
      ],
    );
  }
}
