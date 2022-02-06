import 'package:test/test.dart';
import 'package:budget_app/functions/test.dart';

void main() {
  //test jednostkowy
  test('Increament value by pure function', () {
    int a = 0;
    int b = increament(a);
    expect(a, 0);
    expect(b, a+1);
  });
}
