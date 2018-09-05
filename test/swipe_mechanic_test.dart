import "package:test/test.dart";
import "package:flutter_2048/swipe_mechanic.dart";
import "package:flutter_2048/position.dart";

void main() {
  group("rotation",() {
    test("",(){
      expect(rotatePosition(new Position(1,1)), equals(new Position(2,1)));
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

  group("matrix", () {
    test("construct", () {
      new Matrix([]);
    });
  });

  group("strip nulls", () {
    test("strip from empty",(){
      var r = stripNulls([]);
      expect(r.length, equals(0));
    });

    test("strip from null",(){
      var r = stripNulls([[null]]);
      expect(r.length, equals(0));
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
      expect(m2.length, equals(0));
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
}


