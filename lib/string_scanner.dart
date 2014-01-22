library string_scanner;

class StringScanner {
  String string;
  int _position = 0;
  List<String> _groups = new List<String>();
  String matched;
  String pre_match;
  String post_match;
  
  StringScanner(String string) : string = string;
  
  int get position => _position;
  void set position(int position) {
    if (position.abs() > string.length) {
      throw new RangeError("index out of range");
    }
    int pos = (position < 0) ? string.length - position.abs() : position;
    _position = pos;
  }
  
  bool beginning_of_line() => position == 0 || string[position-1] == "\n";
  bool end_of_string() => position == string.length;
  
  StringScanner concat(String str) {
    string += str;
    return this;
  }
  
  StringScanner operator <<(String str) => concat(str);
  
  void _reset() {
    matched = null;
    pre_match = null;
    post_match = null;
  }
  
  String _match(RegExp regexp, bool until, bool advancePosition) {
    if (!until) regexp = new RegExp(r"^" + regexp.pattern);
    Match match = regexp.firstMatch(string.substring(position));
    
    if (match == null) {
      _reset();
      return null;
    }
    
    if (advancePosition) {
      position = match.end;
    }
    
    _groups.clear();
    _groups.add(match.group(0));
    for (int i = 0;i < match.groupCount;i++) {
      _groups.add(match[0]);
    }
    
    // set matched,pre_match. post_match
    String input = match.input;
    String pre = string.substring(0, position);
    matched = match.group(0);
    pre_match = string.substring(0, position) + input.substring(0, match.start);
    post_match = input.substring(match.end);
    
    return string.substring(position, pre.length + match.end);
  }
  
  String check(RegExp regexp) => _match(regexp, false, false);
  String check_until(RegExp regexp) => _match(regexp, true, false);
}