enum LangType {
  zhCN, ///简体
  enUS, ///英文
}

extension LangTypeExt on LangType {
  String get name {
    String result;
    switch(this) {
      case LangType.zhCN:
        result = 'zh_CN';
        break;
      case LangType.enUS:
        result = 'en_US';
        break;
    }
    return result;
  }

  static LangType? str2Enum(String? value) {
    LangType? result;
    switch(value) {
      case 'en_US':
        result = LangType.enUS;
        break;
      case 'zh_CN':
        result = LangType.zhCN;
        break;
    }
    return result;
  }
}