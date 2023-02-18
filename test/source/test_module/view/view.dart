abstract class View {
  Iterable<String> build();

  void show() {
    print(toString());
  }

  @override
  String toString() {
    return build().join('\n');
  }
}