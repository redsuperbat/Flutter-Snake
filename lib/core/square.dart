class Square {
  int color;
  int x;
  int y;
  bool isHead;

  Square({this.color = 0xffffffff, this.x, this.y, this.isHead = false});

  String toString(){
    return "x: $x, y: $y";
  }
}
