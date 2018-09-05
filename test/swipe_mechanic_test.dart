import "package:test/test.dart";
import "package:flutter_2048/swipe_mechanic.dart";
import "package:flutter_2048/position.dart";

void main() {
  group("rotation",() {
    test("rotate position",(){
      expect(rotatePosition(new Position(1,1)), equals(new Position(2,1)));
      expect(rotatePosition(new Position(2,1)), equals(new Position(2,2)));
      expect(rotatePosition(new Position(2,2)), equals(new Position(1,2)));
      expect(rotatePosition(new Position(1,2)), equals(new Position(1,1)));
    });

    test("rotate matrix", () {
      List<List<Cell>> m = [[ null, null, null, new Cell(1)]];
      var m2 = rotate(m);
      expect(m2[3][3].value, equals(1));

      var m3 = rotate(m2);
      expect(m3[3][0].value, equals(1));

      var m4 = rotate(m3);
      expect(m4[0][0].value, equals(1));
    });
  });

  group("pad matrix",() {
    test("pad zero matrix",() {
      var m1 = padMatrix(new List());
      expect(m1.length, equals(4));
      expect(m1[3].length, equals(4));
    });

    test("pad small matrix",() {
      var m1 = padMatrix([ [ null ] ]);
      expect(m1.length, equals(4));
      expect(m1[3].length, equals(4));
    });
  });

  group("strip nulls", () {
    test("strip from empty",(){
      var r = stripNulls([]);
      expect(r.length, equals(0));
    });

    test("strip from null",(){
      var r = stripNulls([[null]]);
      expect(r.length, equals(1));
      expect(r[0].length, equals(0));
    });

    test("strip from non null",(){
      var r = stripNulls([[new Cell(1)]]);
      expect(r.length, equals(1));
      expect(r[0].length, equals(1));
    });
  });

  group("update current positions", (){
    test("update empty", () {
      var llc = updateCurrentPositions([]);
      expect(llc.length, equals(0));
    });

    test("update one", () {
      var llc = updateCurrentPositions([[new Cell(1)]]);
      expect(llc.length, equals(1));
      expect(llc[0].length, equals(1));
      expect(llc[0][0].current, equals(new Position(0,0)));
    });

  });

  group("merge neighbors", () {
    test("merge none", () {
      List<List<Cell>> m1 = [ [ null ] ];
      var m2 = mergeNeighbors(m1);
      expect(m2[0].length, equals(0));
    });

    test("merge 2", () {
      List<List<Cell>> m1 = [ [ new Cell(1), new Cell(1) ] ];
      var m2 = mergeNeighbors(m1);
      expect(m2[0][0].value, equals(2));
    });

    test("merge 2 without 1", () {
      List<List<Cell>> m1 = [ [ new Cell(4), new Cell(1), new Cell(1) ] ];
      var m2 = mergeNeighbors(m1);
      print(m2);
      expect(m2[0][0].value, equals(4));
      expect(m2[0][1].value, equals(2));
    });
  });

  group("move right", () {
    test("moving nothing right", () {
      List<List<Cell>> m = [];
      var m2 = moveRight(m);
      expect(m2.length,equals(0));
    });

    test("moving 1 right", () {
      List<List<Cell>> m = [[new Cell(1)]];
      var m2 = moveRight(m);
      expect(m2.length, equals(1));
      expect(m2[0].length, equals(4));
      print (m2);
      expect(m2[0][3].value, equals(1));
    });
  });

  group("swipe", () {
    test("swipe nothing right", () {
      List<List<Cell>> m = [];
      var m2 = swipeRight(m);
      expect(m2.length, equals(0));
    });

    test("swipe 1 right", () {
      List<List<Cell>> m = [[ new Cell(1) ]];
      var m2 = swipeRight(m);
      expect(m2.length, equals(1));
      expect(m2[0].length, equals(4));
      expect(m2[0][3].value, equals(1));
    });

    test("swipe left",() {
      List<List<Cell>> m = [[ null, null, null, new Cell(1) ]];
      print("m");
      print(m);
      var m2 = rotateNum(2,m);
      print("m2");
      print(m2);
      var m3 = swipeRight(m2);
      print("m3");
      print(m3);
      var m4 = rotateNum(2,m3);
      print("m4");
      print(m4);
      //var m2 = swipeLeft(updateCurrentPositions(m));
      //print(m2);
      expect(m4[0][0].value, equals(1));
    });

    test("swipe up",() {
      List<List<Cell>> m = [
        [ null, ],
        [ null, ],
        [ null, ],
        [ new Cell(1) ],
        ];
      var m2 = swipeUp(updateCurrentPositions(m));
      expect(m2[0][0].value, equals(1));
    });

    test("swipe down",() {
      List<List<Cell>> m = [ [ new Cell(1) ] ];
      var m2 = swipeDown(updateCurrentPositions(m));
      expect(m2[3][0].value, equals(1));
    });
  });

  group("source position tracking",() {
    test("",(){
      List<List<Cell>> m = [ [ new Cell(1) ] ];
      var m2 = swipeDown(updateCurrentPositions(m));
      expect(m2[3][0].source, equals(new Position(0,0)));
    });
  });
}


