import 'nodes.dart';

const Map<String, Set<String>> disallowedContents = <String, Set<String>>{
  'li': {'li'},
  'dt': {'dt', 'dd'},
  'dd': {'dt', 'dd'},
  'p': {
    'address',
    'article',
    'aside',
    'blockquote',
    'div',
    'dl',
    'fieldset',
    'footer',
    'form',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'header',
    'hgroup',
    'hr',
    'main',
    'menu',
    'nav',
    'ol',
    'p',
    'pre',
    'section',
    'table',
    'ul'
  },
  'rt': {'rt', 'rp'},
  'rp': {'rt', 'rp'},
  'optgroup': {'optgroup'},
  'option': {'option', 'optgroup'},
  'thead': {'tbody', 'tfoot'},
  'tbody': {'tbody', 'tfoot'},
  'tfoot': {'tbody'},
  'tr': {'tr', 'tbody'},
  'td': {'td', 'th', 'tr'},
  'th': {'td', 'th', 'tr'},
};

const String voids = 'area|base|br|col|command|embed|hr|img|input|keygen|link|meta|param|source|track|wbr';

bool closingTagOmitted(String current, String? next) {
  if (disallowedContents.containsKey(current)) {
    if (next == null || disallowedContents[current]!.contains(next)) {
      return true;
    }
  }

  return false;
}

String getLibraryName(String name) {
  return name.replaceAllMapped(RegExp('([A-Z])[A-Z]*'), (match) => match.start == 0 ? match[0]!.toLowerCase() : '_${match[0]!.toLowerCase()}');
}

bool isVoid(String tag) {
  tag = tag.toLowerCase();
  return RegExp('^(?:$voids)\$').hasMatch(tag) || tag == '!doctype';
}

void removeComments(Node node) {
  if (node is Fragment && node.isNotEmpty) {
    final children = node.children;

    for (var i = 0; i < children.length;) {
      final child = children[i];

      if (child is Comment) {
        children.removeAt(i);
        continue;
      }

      if (child is Fragment) {
        removeComments(child);
      }

      i += 1;
    }
  }
}

void trim(Node node) {
  if (node is Fragment && node.isNotEmpty) {
    final children = node.children;

    for (var i = 1; i < children.length - 1;) {
      final current = children[i];

      if (current is Text) {
        final previous = children[i - 1];

        if (previous is Text) {
          previous.data += current.data;
          children.removeAt(i);
          continue;
        }
      }

      i += 1;
    }

    final first = children.first;

    if (first is Text) {
      first.data = first.data.trimLeft();

      if (first.isEmpty) {
        children.removeAt(0);
      }
    }

    if (children.isNotEmpty) {
      final last = children.last;

      if (last is Text) {
        last.data = last.data.trimRight();

        if (last.isEmpty) {
          children.removeLast();
        }
      }
    }

    for (var i = 0; i < children.length;) {
      if (children[i] is Fragment) {
        if ((children[i] as Fragment).isEmpty) {
          children.removeAt(i);
          continue;
        } else {
          trim(children[i]);
        }
      }

      i += 1;
    }
  }
}