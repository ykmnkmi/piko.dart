import 'visitor.dart';

abstract class Node {
  Node({this.children = const <Node>[]});

  List<Node> children;

  bool get isEmpty {
    return children.isEmpty;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }

  R accept<R>(Visitor<R> visitor);
}

class Text extends Node {
  Text(this.data);

  String data;

  String get escaped {
    return data.replaceAll("'", r"\'").replaceAll('\r', r'\r').replaceAll('\n', r'\n');
  }

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitText(this);
  }

  @override
  String toString() {
    return "'$escaped'";
  }
}

class Comment extends Text {
  Comment(String data) : super(data);

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitComment(this);
  }

  @override
  String toString() {
    return "#'$escaped'";
  }
}

abstract class Expression extends Node {}

class Identifier extends Expression {
  Identifier(this.identifier);

  String identifier;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitIdentifier(this);
  }

  @override
  String toString() {
    return identifier;
  }
}

class Fragment extends Node {
  Fragment({List<Node>? children}) : super(children: children ?? <Node>[]);

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitFragment(this);
  }

  @override
  String toString() {
    return 'Fragment { ${children.join(', ')} }';
  }
}

class Element extends Fragment {
  Element(this.tag, {List<Node>? children}) : super(children: children);

  String tag;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitElement(this);
  }

  @override
  String toString() {
    return 'Element.$tag { ${children.join(', ')} }';
  }
}