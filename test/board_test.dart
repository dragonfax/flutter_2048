import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
