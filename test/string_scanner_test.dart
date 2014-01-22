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
  
  group('beginning_of_line', () {
    StringScanner s;
    setUp(() {
      s = new StringScanner("test\nstring");
    });
    
    test('', () {
      var s = new StringScanner("test\nstring");
      expect(s.beginning_of_line(), isTrue);
    });
    
    test('new line', () {
      var s = new StringScanner("test\nstring");
      s.position = 4;
      expect(s.beginning_of_line(), isFalse);
    });
    
    test('next line', () {
      var s = new StringScanner("test\nstring");
      s.position = 5;
      expect(s.beginning_of_line(), isTrue);
    });
    
    test('last', () {
      var s = new StringScanner("test\nstring");
      s.position = 10;
      expect(s.beginning_of_line(), isFalse);
    });
    
    test('last new line', () {
      var s = new StringScanner("test\nstring\n");
      s.position = 12;
      expect(s.beginning_of_line(), isTrue);
    });
  });
  
  group("end of string", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test\nstring"));
    
    test("", () {
      s.position = 0;
      expect(s.end_of_string(), isFalse);
      s.position = 10;
      expect(s.end_of_string(), isFalse);
      s.position = 11;
      expect(s.end_of_string(), isTrue);
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
      expect(s.pre_match, equals("test"));
      expect(s.post_match, equals("string"));
    });
    
    test("not valid", () {
      var s = new StringScanner("test string");
      String text = s.check(new RegExp(r"\s+"));
      expect(text, equals(null));
    });
  });
  
  group("check_until", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    
    test("valid", () {
      String text = s.check_until(new RegExp(r"str"));
      expect(text, equals("test str"));
      expect(s.matched, equals("str"));
      expect(s.pre_match, equals("test "));
      expect(s.post_match, equals("ing"));
    });
    
    test("change position", () {
      s.position = 4;
      String text = s.check_until(new RegExp(r"t"));
      expect(text, equals(" st"));
      expect(s.matched, equals("t"));
      expect(s.pre_match, equals("test s"));
      expect(s.post_match, equals("ring"));
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
  
  group("pre_match", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    test("valid", () {
      s.check(new RegExp(r"\w+"));
      expect(s.pre_match, equals(""));
    });
    
    test("not valid", () {
      s.check(new RegExp(r"\s+"));
      expect(s.pre_match, isNull);
    });
  });
  
  group("post_match", () {
    StringScanner s;
    setUp(() => s = new StringScanner("test string"));
    test("valid", () {
      s.check(new RegExp(r"\w+"));
      expect(s.post_match, equals(" string"));
    });
    
    test("not valid", () {
      s.check(new RegExp(r"\s+"));
      expect(s.post_match, isNull);
    });
  });
}