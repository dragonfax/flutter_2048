import "package:test/test.dart";
import "package:flutter_2048/range.dart";


void main () {
  test("forward",() {
    expect(range(0,3),equals([0,1,2,3]));
  });

  test("zero", () {
    expect(range(0,0), equals([0]));
  });

  test("backward",() {
    expect(range(3,0), equals([3,2,1,0]));
  });
}