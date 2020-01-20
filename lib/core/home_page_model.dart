import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'square.dart';

class HomePageModel {
  SharedPreferences prefs;

  List<Square> snake;
  Square food;

  int highScore = 0;
  int currentScore = 0;
  int speed = 150;

  String dir = "d";
  String message = "Tap to start";

  bool loop = false;

  StreamController<List<Square>> controller = StreamController();
  StreamController<int> score = StreamController();
  StreamController<int> highScoreController = StreamController();
  StreamController<int> buttonIndex = StreamController();

  HomePageModel() {
    ini();
  }

  Sink get sink => controller.sink;

  Square get head => snake[0];

  Square get tail => snake[snake.length - 1];

  Future<void> ini() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
      highScore = prefs.getInt("highscore") ?? 0;
      highScoreController.add(highScore);
    }
  }

  void resetSnake() {
    snake = [Square(x: 0, y: 0), Square(x: 1, y: 0), Square(x: 2, y: 0)];
    dir = "d";
  }

  void dispose() {
    controller.close();
    highScoreController.close();
    score.close();
  }

  void generateFood() {
    food = Square(
        color: 0xffFF0000,
        x: Random.secure().nextInt(20),
        y: Random.secure().nextInt(27));
  }

  void changeDir(String newDir) {
    if (dir == "u" && newDir == "d" ||
        dir == "d" && newDir == "u" ||
        dir == "r" && newDir == "l" ||
        dir == "l" && newDir == "r") {
    } else {
      dir = newDir;
    }
  }

  void moveHead() {
    if (dir == "u") {
      head.y--;
    }
    if (dir == "d") {
      head.y++;
    }
    if (dir == "r") {
      head.x++;
    }
    if (dir == "l") {
      head.x--;
    }
  }

  void moveBody() {
    for (var i = snake.length - 1; i >= 1; i--) {
      snake[i].x = snake[i - 1].x;
      snake[i].y = snake[i - 1].y;
    }
  }

  void handleFood() {
    if (head.x == food.x && head.y == food.y) {
      snake.add(
        Square(x: tail.x, y: tail.y),
      );
      generateFood();
      score.add(++currentScore);
      if (speed <= 150 && speed > 50) {
        speed =
            (150 - 0.9165 * currentScore - 0.026746 * currentScore).toInt();
      }
    }
  }

  bool checkDeath() {
    if (head.x > 19 || head.y > 26 || head.y < 0 || head.x < 0) {
      gameOver();
      return true;
    }
    for (var i = 1; i < snake.length; i++) {
      if (head.x == snake[i].x && head.y == snake[i].y) {
        gameOver();
        return true;
      }
    }
    return false;
  }

  void gameOver() {
    message = "Game Over\nTap to try again";
    sink.add(null);
    if (currentScore > highScore) {
      highScore = currentScore;
      prefs.setInt("highscore", highScore);
      highScoreController.add(highScore);
    }
    currentScore = 0;
    speed = 150;
    loop = false;
    resetSnake();
  }

  void changeDifficulty(int newSpeed) {
    speed = newSpeed;
    buttonIndex.add(newSpeed);
  }

  Future<void> start() async {
    loop = true;
    score.add(null);
    resetSnake();
    generateFood();
    while (loop) {
      await Future.delayed(Duration(milliseconds: speed)).then(
        (v) {
          moveBody();
          moveHead();
          handleFood();
          if (!checkDeath()) {
            sink.add(snake);
          }
        },
      );
    }
  }
}
