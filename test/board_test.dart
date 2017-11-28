import 'package:flutter/material.dart';
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
    expect(b.Get(3,3), null);
  });

  test('#getRows',() {

    var b = new Board();
    b.Set(3,1, new Peice(99));
    expect(b.getRows()[1][3].value,99);

  });

  test('#getColumns',() {

    var b = new Board();
    b.Set(3,1, new Peice(99));
    expect(b.getColumns()[3][1].value,99);

  });

  test('#setRows',() {

    var b = new Board();
    b.Set(3,1,new Peice(99));

    var c = new Board();
    c.setRows(b.getRows());
    expect(b.Get(3,1).value,99);

  });

  test('#setColumns',() {

    var b = new Board();
    b.Set(3,1, new Peice(99));

    var c = new Board();
    c.setColumns(b.getRows());
    expect(c.Get(1,3)?.value,99, reason: "c: " + c.toString());

  });

  test('#swipe(Left) Move one peice', () {
    var b = new Board();
    b.Set(3, 1, new Peice(1));
    b.swipe(Direction.left);
    expect(b.Get(0,1)?.value,1, reason: b.toString());
  });

  test('#swipe(Left) Move two peices', () {
    var b = new Board();
    b.Set(3, 1, new Peice(1));
    b.Set(2, 1, new Peice(2));
    b.swipe(Direction.left);
    expect(b.Get(0,1)?.value,2, reason: b.toString());
    expect(b.Get(1,1)?.value,1, reason: b.toString());
  });

  test('#swipe(Left) Merge two peices', () {
    var b = new Board();
    b.Set(3, 1, new Peice(2));
    b.Set(2, 1, new Peice(2));
    b.swipe(Direction.left);
    expect(b.Get(0,1)?.value,4, reason: b.toString());
    expect(b.Get(1,1),null, reason: b.toString());
  });

 }
