// will be generated

library app;

import 'dart:html';

import 'package:piko/runtime.dart';

class App extends Component<App> {
  App({this.name = 'world'});

  final String name;

  @override
  Fragment<App> render(RenderTree tree) {
    return AppFragment(this, tree);
  }
}

class AppFragment extends Fragment<App> {
  AppFragment(App context, RenderTree tree) : super(context, tree);

  late Element p1;

  late Text t1;

  late Text t2;

  late Text t3;

  @override
  void create() {
    p1 = element('p');
    t1 = text('hello ');
    t2 = text(context.name);
    t3 = text('!');
    attr(p1, 'id', 'title');
  }

  @override
  void mount(Element target, [Node? anchor]) {
    insert(target, p1, anchor);
    append(p1, t1);
    append(p1, t2);
    append(p1, t3);
  }

  @override
  void detach(bool detaching) {
    if (detaching) {
      remove(p1);
    }
  }
}
