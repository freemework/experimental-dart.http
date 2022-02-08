// import 'package:cancellation/cancellation.dart';
// import 'package:test/test.dart';

// void main() {
//   group('SimpleCancellationTokenSource tests', () {
//     SimpleCancellationTokenSource cts;

//     setUp(() {
//       cts = SimpleCancellationTokenSource();
//     });

//     test('Should cancel two listeners', () {
//       bool cancel1 = false;
//       bool cancel2 = false;

//       final token = cts.token;

//       token.addCancelListener(() {
//         cancel1 = true;
//       });
//       token.addCancelListener(() {
//         cancel2 = true;
//       });

//       cts.cancel();

//       expect(cancel1, isTrue);
//       expect(cancel2, isTrue);
//     });
//   });
// }
