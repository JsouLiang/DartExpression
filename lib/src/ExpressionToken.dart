
//class ExpressionToken {
const BIT_PRIORITY        = 60;
const BIT_PRIORITY_SUB    = 3840;
const BIT_ARGS            = 192;
const POS_INC             = 12;
const VALUE_CONSTANTS     = -1;
  /// var
const VALUE_VAR           = -2;
  /// []
const VALUE_LIST          = -3;
  /// {}
const VALUE_MAP           = -4;
  /// . get
const OP_GET              = 96;
  /// ()
const OP_INVOKE           = 97;
const OP_NOT              = 28;
const OP_BIT_NOT          = 29;
const OP_POS              = 30;
const OP_NEG              = 31;
const OP_MUL              = 88;
const OP_DIV              = 89;
const OP_MOD              = 90;
const OP_ADD              = 84;
const OP_SUB              = 85;
const OP_LSH              = 80;
const OP_RSH              = 81;
const OP_URSH             = 82;
const OP_LT               = 332;
const OP_GT               = 333;
const OP_LTEQ             = 334;
const OP_GTEQ             = 335;
const OP_IN               = 4428;
const OP_EQ               = 76;
const OP_NE               = 77;
const OP_EQ_STRICT        = 78;
const OP_NE_STRICT        = 79;
const OP_BIT_AND          = 1096;
const OP_BIT_XOR          = 840;
const OP_BIT_OR           = 584;
const OP_AND              = 328;
const OP_OR               = 72;
  /// ?
const OP_QUESTION         = 68;
  /// :
const OP_QUESTION_SELECT  = 69;
const OP_JOIN             = 64;
const OP_PUT              = 65;
const _TYPE_TOKE_MAP = {};
const _TOKEN_TYPE_MAP = {};


//}