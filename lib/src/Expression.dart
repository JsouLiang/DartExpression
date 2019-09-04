
import 'dart:collection';

class Expression {

  static final Map<String, int> _operator = HashMap.from({
    "(": 1,
    ")": 1,

    "!": 2,

    "*": 3,
    "/": 3,

    "+": 4,
    "-": 4,

    ">": 6,
    ">=": 6,
    "<": 6,
    "<=": 6,

    "==": 7,
    "!=": 7,

    "&": 11,
    "|": 12,

    "?:": 13,
    "?": 13,
    ":": 13,
  });

  /// 可以与右联= 的操作符集
  /// ==，!=, >=, <=
  static final Set<String> _leftOperatorSet = HashSet.from({
    "=", "!", ">" "<"
  });

  Expression(String expression): _expression = expression.replaceAll(" ", "") {
   _tokens = _tokenize(_expression);
  }

  List<String> _tokenize(String expression) {
    List<String> tokenizers = expression.split(_splitExpression);
    List<String> tokens = [];
    String previewToken;
    for (String tokenizer in tokenizers) {
      // tokenizer 为 =，前一个操作符previewToken 为可与 = 结合的操作符
      if (_isCombinable(previewToken, tokenizer)) {
        tokens.removeLast();
        String newToken = "${previewToken}${tokenizer}";
        tokens.add(newToken);
        previewToken = newToken;
      } else {
        tokens.add(tokenizer);
        previewToken = tokenizer;
      }
    }
    return tokens;
  }

  List<String> generatorReversePolish(List<String> tokens) {
    List<String> operationStack = [];
    /// 运算符栈：从栈底到栈顶的运算优先级越来越高
    List<String> numberStack = [];

    for (String token in tokens) {
      /// 操作数
      if (!_operator.containsKey(token)) {
        numberStack.add(token);
      } else {
        /// 运算符
        /// 1. 运算符栈为空栈，直接push
        if (operationStack.isEmpty) {
          operationStack.add(token);
        } else {
          if (token == "(") {
            operationStack.add(token);
          } else if (token == ")") {
            /// 找 (
            String leftBracket;
            while ((leftBracket = operationStack.removeAt(0)) != "(") {
              numberStack.add(leftBracket);
            }
          } else if (token == ":") {
            /// 找 ?
            String leftBracket;
            while ((leftBracket = operationStack.removeAt(0)) != "?") {
              numberStack.add(leftBracket);
            }
            operationStack.add("?:");
          }

          String prevOperator = operationStack.removeAt(0);
          /// 上一个操作符是 (
          if (prevOperator == "(") {
            operationStack.add(token);
          }
        }
      }
    }
  }

  /// 判断两个操作符是否可以联合
  bool _isCombinable(String left, String right) {
    if ('=' == right) {
      if (_leftOperatorSet.contains(left)) {
        return true;
      }
    }
    return false;
  }

  final RegExp _splitExpression = RegExp("");
  final String _expression;
  List<String> _tokens;
}