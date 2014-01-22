import 'package:unittest/unittest.dart';
import 'package:string_scanner/string_scanner.dart';

main() {
  test('constructor', () {
    var s = new StringScanner("hoge");
  });
  
  group('position', () {
    StringScanner s;
    setUp(() {
      s = new StringScanner("test\nstring");
    });
    test("out of range", () {
      expect(() => s.position = 12, throwsA(new isInstanceOf<RangeError>()));
    });
    
    test("minus", () {
      s.position = -1;
      expect(s.position, equals(10));
      s.position = -11;
      expect(s.position, equals(0));
      
      expect(() => s.position = -12, throwsA(new isInstanceOf<RangeError>()));
    });
  });
  
  group('isBeginningOfLine', () {
    StringScanner s;
    setUp(() {
      s = new StringScanner("test\nstring");
    });
    
    test('', () {
      var s = new StringScanner("test\nstring");
      expect(s.isBeginningOfLine, isTrue);
    });
    
    test('new line', () {
      var s = new StringScanner("test\nstring");
      s.position = 4;
      expect(s.isBeginningOfLine, isFalse);
    });
    
    test('next line', () {
      var s = new StringScanner("test\nstring");
      s.position = 5;
      expect(s.isBeginningOfLine, isTrue);
    });
    
    test('last', () {
      var s = new StringScanner("test\nstring");
      s.position = 10;
      expect(s.isBeginningOfLine, isFalse);
    });
    
    test('last new line', () {
      var s = new StringScanner("test\nstring\n");
      s.position = 12;
      expect(s.isBeginningOfLine, isTrue);
    });
  });
  
  group("isEndOfString", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test\nstring"));
    
    test("", () {
      s.position = 0;
      expect(s.isEndOfString, isFalse);
      s.position = 10;
      expect(s.isEndOfString, isFalse);
      s.position = 11;
      expect(s.isEndOfString, isTrue);
    });
  });
  
  group("concat", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test"));
    
    test("", () {
      s.concat(" string");
      expect(s.string, equals("test string"));
    });
  });
  
  group("unscan", () {
    test("", () {
      var s = new StringScanner("test string");
      s.scan(new RegExp(r"\w+"));
      s.unscan();
      expect(s.scan(new RegExp(r".+")), equals("test string"));
    });
    
    test("exception", () {
      var s = new StringScanner("test string");
      expect(() => s.unscan(), throwsA(new isInstanceOf<StringScannerError>()));
    });
  });
  
  group("scan", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    
    test("valid", () {
      String text = s.scan(new RegExp(r"\w+"));
      expect(text, equals("test"));
      expect(s.position, 4);
    });
    
    test("日本語", () {
      var s = new StringScanner("あいう えお");
      String text = s.scan(new RegExp(r"[^\s]+"));
      expect(text, equals("あいう"));
      expect(s.position, 3);
    });
    
    test("seq", () {
      StringScanner s = new StringScanner("test string");
      expect(s.scan(new RegExp(r"\w+")), equals("test"));
      expect(s.scan(new RegExp(r"\w+")), isNull);
      expect(s.scan(new RegExp(r"\s+")), equals(" "));
      expect(s.scan(new RegExp(r"\w+")), equals("string"));
      expect(s.scan(new RegExp(r".")), isNull);
    });
  });
  
  group("scanUntil", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    
    test("valid", () {
      String text = s.scanUntil(new RegExp(r"str"));
      expect(text, equals("test str"));
      expect(s.matched, equals("str"));
      expect(s.position, equals(8));
      expect(s.preMatch, equals("test "));
      expect(s.postMatch, equals("ing"));
    });
  });
  
  group("skip", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    
    test("valid", () {
      expect(s.skip(new RegExp(r"test")), equals(4));
      expect(s.position, equals(4));
    });
    
    test("seq", () {
      expect(s.skip(new RegExp(r"\w+")), equals(4));
      expect(s.skip(new RegExp(r"\w+")), isNull);
      expect(s.skip(new RegExp(r"\s+")), equals(1));
      expect(s.skip(new RegExp(r"\w+")), equals(6));
      expect(s.skip(new RegExp(r".")), isNull);
    });
  });
  
  group("skipUntil", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    
    test("valid", () {
      expect(s.skipUntil(new RegExp(r"str")), equals(8));
      expect(s.matched, equals("str"));
      expect(s.position, equals(8));
      expect(s.preMatch, equals("test "));
      expect(s.postMatch, equals("ing"));
    });
  });
  
  group("match", () {
    test("valid", () {
      var s = new StringScanner("test string");
      expect(s.match(r"\w+"), equals(4));
      expect(s.match(r"\w+"), equals(4));
      expect(s.match(r"\s+"), isNull);
    });
  });
  
  group("check", () {
    test("valid", () {
      var s = new StringScanner("test string");
      String text = s.check(new RegExp(r"\w+"));
      expect(text, equals("test"));
      expect(s.position, equals(0));
    });
    
    test("change position", () {
      var s = new StringScanner("test string");
      s.position = 4;
      String text = s.check(new RegExp(r"\s+"));
      expect(text, equals(" "));
      expect(s.matched, equals(" "));
      expect(s.preMatch, equals("test"));
      expect(s.postMatch, equals("string"));
    });
    
    test("not valid", () {
      var s = new StringScanner("test string");
      String text = s.check(new RegExp(r"\s+"));
      expect(text, equals(null));
    });
  });
  
  group("checkUntil", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    
    test("valid", () {
      String text = s.checkUntil(new RegExp(r"str"));
      expect(text, equals("test str"));
      expect(s.matched, equals("str"));
      expect(s.preMatch, equals("test "));
      expect(s.postMatch, equals("ing"));
    });
    
    test("change position", () {
      s.position = 4;
      String text = s.checkUntil(new RegExp(r"t"));
      expect(text, equals(" st"));
      expect(s.matched, equals("t"));
      expect(s.preMatch, equals("test s"));
      expect(s.postMatch, equals("ring"));
    });
  });
  
  group("peek", () {
    test("valid", () {
      var s = new StringScanner("test string");
      expect(s.peek(4), equals("test"));
    });
  });
  
  group("matched", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    test("valid", () {
      s.check(new RegExp(r"\w+"));
      expect(s.matched, equals("test"));
    });
    
    test("not valid", () {
      s.check(new RegExp(r"\s+"));
      expect(s.matched, isNull);
    });
  });
  
  group("preMatch", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    test("valid", () {
      s.check(new RegExp(r"\w+"));
      expect(s.preMatch, equals(""));
    });
    
    test("not valid", () {
      s.check(new RegExp(r"\s+"));
      expect(s.preMatch, isNull);
    });
  });
  
  group("postMatch", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    test("valid", () {
      s.check(new RegExp(r"\w+"));
      expect(s.postMatch, equals(" string"));
    });
    
    test("not valid", () {
      s.check(new RegExp(r"\s+"));
      expect(s.postMatch, isNull);
    });
  });
  
  group("operator []", () {
    test("seq", () {
      var s = new StringScanner("test string");
      expect(s.scan(new RegExp(r"\w(\w)(\w*)")), equals("test"));
      expect(s[0], equals("test"));
      expect(s[1], equals("e"));
      expect(s[2], equals("st"));
      expect(s[3], isNull);
      expect(s.scan(new RegExp(r"\w+")), isNull);
      expect(s[0], isNull);
      expect(s[1], isNull);
      expect(s[2], isNull);
      expect(s.scan(new RegExp(r"\s+")), equals(" "));
      expect(s[0], equals(" "));
      expect(s[1], isNull);
    });
  });
}