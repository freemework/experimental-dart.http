import 'package:freemework/freemework.dart';
// import 'package:freemework_cancellation/freemework_cancellation.dart';
import 'package:freemework_http/freemework_http.dart';
import 'package:test/test.dart';

void main() {
  group('Simple requests', () {
    HttpClient httpClient;

    setUp(() {
      httpClient = HttpClient();
    });

    test('GET html', () async {
      var resposnse = await httpClient.get(ExecutionContext.EMPTY,
          Uri.parse('https://pub.dev/packages/freemework_http'));

      expect(resposnse.statusCode, 200);
    });
  });
}
