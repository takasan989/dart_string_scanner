library string_scanner;

class StringScanner {
  String _string;
  int _position = 0;
  int _oldPosition;
  List<String> _groups = new List<String>();
  
  String matched;
  String preMatch;
  String postMatch;
  
  /**
   * constructor
   */
  StringScanner(this._string);
  
  /**
   * string
   */
  String get string => _string;
  void set string(String str) {
    _string = str;
    _reset();
  }
  
  /**
   * position
   */
  int  get position => _position;
  void set position(int position) {
    if (position.abs() > string.length) {
      throw new RangeError("index out of range");
    }
    _position = (position < 0) ? string.length - position.abs() : position;
  }
  
  /**
   * isBeginningOfLine
   * isEndOfString
   */
  bool get isBeginningOfLine => position == 0 || string[position-1] == "\n";
  bool get isEndOfString     => position == string.length;
  
  /**
   * reset
   */
  StringScanner reset() {
    position = 0;
    _reset();
    return this;
  }
  
  /**
   * terminate
   */
  StringScanner terminate() {
    position = string.length;
    _reset();
    return this;
  }
  
  /**
   * concat
   * <<
   */
  StringScanner concat(String str) {
    string += str;
    return this;
  }
  StringScanner operator <<(String str) => concat(str);
  
  /**
   * rest
   */
  String get rest => string.substring(position);
  
  /**
   * unscan
   */
  StringScanner unscan() {
    if (_oldPosition == null) throw new StringScannerError("previous match record not exist");
    position = _oldPosition;
    _oldPosition = null;
    return this;
  }
  
  /**
   * scan
   * scanUntil
   */
  String scan(regexp)      => _match(regexp, false, true);
  String scanUntil(regexp) => _match(regexp, true, true);
  
  /**
   * skip
   * skipUntil
   */
  int skip(regexp) {
    String match = _match(regexp, false, true);
    return (match == null) ? null : match.length;
  }
  int skipUntil(regexp) {
    String match = _match(regexp, true, true);
    return (match == null) ? null : match.length;
  }
  
  /**
   * match
   */
  int match(regexp) {
    String match = _match(regexp, false, false);
    return (match == null) ? null : match.length;
  }
  
  /**
   * check
   * checkUntil
   */
  String check(regexp)      => _match(regexp, false, false);
  String checkUntil(regexp) => _match(regexp, true, false);
  
  /**
   * peek
   */
  String peek(int num) => string.substring(position, position + num);
  
  /**
   * []
   */
  String operator [](int index) {
    if (index > _groups.length-1) return null;
    return _groups[index];
  }
  
  void _reset() {
    matched = null;
    preMatch = null;
    postMatch = null;
    _groups.clear();
  }
  
  String _match(regexp, bool until, bool advancePosition) {
    if (regexp is String) {
      regexp = new RegExp(regexp);
    } else if (regexp is RegExp) {
      
    } else 
      throw new ArgumentError("invalid argument");
    
    _oldPosition = position;
    if (!until) regexp = new RegExp(r"^" + regexp.pattern);
    Match match = regexp.firstMatch(string.substring(position));
    
    if (match == null) {
      _reset();
      return null;
    }
   
    _groups.clear();
    _groups.add(match.group(0));
    for (int i = 0;i < match.groupCount;i++) {
      _groups.add(match.group(i+1));
    }
    
    // set matched,preMatch. postMatch
    String input = match.input;
    String pre = string.substring(0, position);
    matched = match.group(0);
    preMatch = pre + input.substring(0, match.start);
    postMatch = input.substring(match.end);
    
    String result = string.substring(position, pre.length + match.end);
    
    if (advancePosition) {
      position = pre.length + match.end;
    }
    
    return result;
  }
}

class StringScannerError extends StateError {
  StringScannerError(String message) : super(message) {
  }
}