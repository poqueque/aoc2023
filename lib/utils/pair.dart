class Pair<T, U> {
  Pair(this.left, this.right);

  final T left;
  final U right;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          right == other.right;

  @override
  int get hashCode => left.hashCode ^ right.hashCode;

  @override
  String toString() => "Pair[${left.toString()}, ${right.toString()}]";
}