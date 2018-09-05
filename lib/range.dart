
List<int> range(int start, end) {
  if ( end > start ) {
    var l = end  + 1 - start;
    return new List<int>.generate(l, (i) => start + i);
  } else {
    var l = start + 1 - end;
    return new List<int>.generate(l, (i) => start - i);
  }
}

