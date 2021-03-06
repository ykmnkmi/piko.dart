@JS()
library js_dom;

import 'package:js/js.dart';
import 'package:meta/dart2js.dart';

@JS()
@anonymous
abstract class EventTarget {
  void addEventListener(String type, Function callback);

  void removeEventListener(String type, Function callback);
}

@JS()
@anonymous
abstract class Node {
  external Node get parentNode;

  external String get textContent;

  external set textContent(String text);

  external void appendChild(Node node);

  external void insertBefore(Node node, [Node? reference]);

  external void removeChild(Node node);
}

@JS()
@anonymous
abstract class Document implements Node, EventTarget {
  external Element get body;

  external Element createElement(String tag);

  external Text createTextNode(String text);
}

@JS()
@anonymous
abstract class Text implements Node {
  external String get wholeText;

  external String get data;

  external set data(String data);
}

@JS()
@anonymous
abstract class Element implements Node, EventTarget {
  external String get innerHTML;

  external set innerHTML(String innerHTML);

  external String? getAttribute(String name);

  external void removeAttribute(String name);

  external void setAttribute(String name, String value);
}

@JS('document')
external Document get document;

@noInline
void append(Node target, Node node) {
  target.appendChild(node);
}

@noInline
void insert(Node target, Node node, [Node? anchor]) {
  target.insertBefore(node, anchor);
}

@noInline
void remove(Node node) {
  node.parentNode.removeChild(node);
}

@noInline
Element element(String tag) {
  return document.createElement(tag);
}

@noInline
Text text(String text) {
  return document.createTextNode(text);
}

@tryInline
Text space() {
  return text(' ');
}

@tryInline
Text empty() {
  return text('');
}

@noInline
void Function() listen(EventTarget target, String type, Function handler) {
  final jsHandler = allowInterop(handler);

  target.addEventListener(type, jsHandler);
  return () {
    target.removeEventListener(type, jsHandler);
  };
}

@noInline
void attr(Element node, String attribute, String? value) {
  if (value == null) {
    node.removeAttribute(attribute);
  } else if (node.getAttribute(attribute) != value) {
    node.setAttribute(attribute, value);
  }
}

@noInline
void setData(Text node, String data) {
  if (node.wholeText != data) {
    node.data = data;
  }
}
