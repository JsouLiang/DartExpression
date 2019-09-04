import 'ExpressionToken.dart';
class Node {
  String name;
  int tag;
  List<String> attributes;
  List<Node> children;
  Node(this.name, this.tag, this.attributes, this.children);
}

void Render(List<dynamic> tplData, Map<String, dynamic> context) {
  var name = tplData[0];
  var dynamicFlag = tplData[1];
  var attrs = tplData[2];
  List<dynamic> children;
  if (tplData.length > 3) {
    children = tplData[3];
  }
  if (name == 'block') {
    var value;
    if (attrs[1] != null) {
      switch (attrs[1]) {
        case 'if':
          value = evaluate(attrs[3][0] as List, context);
          if (value != null) {
            for (int i = 0, len = children.length; i < len; i++) {
              Render(children[i], context);
            }
          }
          break;
        case 'for':
          value = evaluate(attrs[3][0] as List, context);

          Map<String, dynamic> newContext = Map.from(context);
          var itemName = attrs[5];
          var indexName = attrs[7];
          var index = 0;
          for (var item in value) {
            index++;
            newContext[itemName] = item;
            newContext[indexName] = index;
            for (int i = 0, len = children.length; i < len; i++) {
              Render(children[i], newContext);
            }
          }
      }
    } else {
      for (int i = 0, len = children.length; i < len; i++) {
        Render(children[i], context);
      }
    }
  } else if (name == '#') {
    if (attrs != null) {
      var value = dynamicFlag == 1 ?evaluate(attrs[0] as List, context):attrs;
    }
  } else {
    for (int i = 0, len = attrs.length; i < len;) {
      var an = attrs[i++];
      var av = attrs[i++];
      if (av is List) {
        av = evaluate(av[0] as List, context);
      }
      if (children.length > 0) {
        for (int i = 0, len = children.length; i < len; i++) {
          Render(children[i], context);
        }
      }
    }
  }
}

dynamic evaluate(List<dynamic> el, Map<String, dynamic> context) {
  var result = _evaluate(el, context);
  return _realValue(result);
}

dynamic _evaluate(List<dynamic> item, var context) {
  int type = item[0];
  var arg1;
  var arg2;

  switch (type) {
    case VALUE_LIST:
      return [];
    case VALUE_MAP:
      return {};
    case VALUE_VAR:
      arg1 = item[1];
      if (context[arg1] != null) {
        var result = context[arg1];
        return result;
      }
      return arg1;    // TODO: var
    case VALUE_CONSTANTS:
      arg1 = item[1];

      return arg1;

    case OP_AND:
      return _realValue(_evaluate(item[1], context)) && _realValue(_evaluate(item[2], context));
    case OP_OR:
      return _realValue(_evaluate(item[1], context)) || _realValue(_evaluate(item[2], context));
    case OP_QUESTION:
      var result = _realValue(_evaluate(item[1], context));
      if (result != null) {
        if (result is bool && result == true) {
          return _evaluate(item[2], context);
        } else {
          return PropertyValue;
        }
      } else {
        return PropertyValue;
      }
      break;
    case OP_QUESTION_SELECT:
      arg1 = _realValue(_evaluate(item[1], context));
      if (arg1 == PropertyValue) {
        return _evaluate(item[2], context);
      } else {
        return arg1;
      }
  }
  arg1 = _evaluate(item[1], context);
  if (getTokenParamIndex(type) == 3) {
    arg2 = _realValue(_evaluate(item[2], context));
  }
  arg1 = _realValue(arg1);
  switch (type) {
    case OP_GET:
      return PropertyValue(arg1, arg2);
    case OP_NOT:
      return !arg1;
//    case OP_POS:
//      return +arg1;
    case OP_NEG:
      return -arg1;
  ///* +-*%/ */
    case OP_ADD: {
      if (arg1 is String || arg2 is String) {
        return "${arg1}${arg2}";
      }
      return arg1 + arg2;
    }
    case OP_SUB:
      return arg1-arg2;
    case OP_MUL:
      return arg1*arg2;
    case OP_DIV:
      return arg1/arg2;
    case OP_MOD:
      return arg1%arg2;
    case OP_GT:
      return arg1 > arg2;
    case OP_GTEQ:
      return arg1 >= arg2;
    case OP_NE:
    case OP_NE_STRICT:
      return arg1 != arg2;
    case OP_EQ:
    case OP_EQ_STRICT:
      return arg1 == arg2;
    case OP_LT:
      return arg1 < arg2;
    case OP_LTEQ:
      return arg1 <= arg2;
    case OP_JOIN:
      (arg1 as List).add(arg2);
      return arg1;
  }
}

class PropertyValue {
  Map<String, dynamic> obj;
  String name;
  PropertyValue(this.obj, this.name);
}

dynamic _realValue(var arg1) {
  if (arg1 is PropertyValue) {
    return arg1.obj[arg1.name];
  }
  return arg1;
}

int getTokenParamIndex(type) {
  if(type<0){
    return 1;
  }
  var c = (type & BIT_ARGS) >> 6;
  return c + 2;
}