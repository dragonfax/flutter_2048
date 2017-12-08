
List<int> range(int start, end) {
  if ( start == end ) {
    return [start];
  }
  if ( start < end ) {
    var l = end + 1 - start;
    return new List<int>.generate(l, (i) => start + i);
  }
  // end < start
  return range(end,start).reversed.toList();
}

