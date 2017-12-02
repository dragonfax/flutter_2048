import 'package:test/test.dart';

import '../lib/board.dart';

void main() {
  test('#range', () {
    var r = range(0,1);
    expect(r[0],0);
    expect(r[1],1);

    r = range(0,10);
    expect(r[10],10);

    r = range(3,4);
    expect(r[0],3);
    expect(r[1],4);

    r = range(3,10);
    expect(r.length,8);
    expect(r[0],3);
    expect(r[7],10);
  });

  test('construct', () {
    var b = new Board();
    expect(b.get(3,3).value, null);
  });

  test('#getRows',() {

    var b = new Board();
    b.set(3,1, new Piece(99));
    expect(b.getRows()[1][3].value,99);

  });

  test('#getColumns',() {

    var b = new Board();
    b.set(3,1, new Piece(99));
    expect(b.getColumns()[3][1].value,99);

  });

  test('#setRows',() {

    var b = new Board();
    b.set(3,1,new Piece(99));

    var c = new Board();
    c.setRows(b.getRows());
    expect(b.get(3,1).value,99);

  });

  test('#setColumns',() {

    var b = new Board();
    b.set(3,1, new Piece(99));

    var c = new Board();
    c.setColumns(b.getRows());
    expect(c.get(1,3).value,99, reason: "c: " + c.toString());

  });

  test('#swipeColumn', () {
    var b = new Board();

    var swiped = b.swipeColumn(<Piece>[new Piece(1),new Piece(1), new Piece(null), new Piece(null)]);
    expect(swiped[0].value, 2);
    expect(swiped[1].value, null);

    swiped = b.swipeColumn(<Piece>[new Piece(1),new Piece(2), new Piece(null), new Piece(null)]);
    expect(swiped[0].value, 1);
    expect(swiped[1].value, 2);

    swiped = b.swipeColumn(<Piece>[new Piece(null), new Piece(null), new Piece(1), new Piece(2)]);
    expect(swiped[0].value, 1);
    expect(swiped[1].value, 2);

    swiped = b.swipeColumn(<Piece>[new Piece(null), new Piece(null), new Piece(1), new Piece(1)]);
    expect(swiped[0].value, 2);
    expect(swiped[1].value, null);
  });

  test('#swipe(Left) Move one peice', () {
    var b = new Board();
    b.set(3, 1, new Piece(1));
    b.swipe(Direction.left);
    expect(b.get(0,1).value,1, reason: b.toString());
  });

  test('#swipe(Left) Move two peices', () {
    var b = new Board();
    b.set(3, 1, new Piece(1));
    b.set(2, 1, new Piece(2));
    b.swipe(Direction.left);
    expect(b.get(0,1).value,2, reason: b.toString());
    expect(b.get(1,1).value,1, reason: b.toString());
  });

  test('#swipe(Left) Merge two peices', () {
    var b = new Board();
    b.set(3, 1, new Piece(2));
    b.set(2, 1, new Piece(2));
    b.swipe(Direction.left);
    expect(b.get(0,1).value,4, reason: b.toString());
    expect(b.get(1,1).value,null, reason: b.toString());
  });

  test('#removeEmpty', () {
    var b = new Board();

    var c = b.removeEmpty(<Piece>[]);
    expect(c.isEmpty, true);

    c = b.removeEmpty(<Piece>[new Piece(null)]);
    expect(c.isEmpty, true);

    c = b.removeEmpty(<Piece>[new Piece(null), new Piece(1), new Piece(null)]);
    expect(c.isEmpty, false);

  });

  test('#mergeNeighbor', () {
    var b = new Board();

    var c = b.mergeNeighbor(<Piece>[new Piece(1),new Piece(1)]);
    expect(c.length, 2);
    expect(c[0].value, 2);
    expect(c[1].value, null);

    var c1 = <Piece>[new Piece(1),new Piece(2),new Piece(1)];
    var c2 = b.mergeNeighbor(c1);
    expect(c2.length, 3);
    expect(c2[2].value, 1);
    expect(c1, c2);
    expect(c1 == c2, true);
  });

 }
