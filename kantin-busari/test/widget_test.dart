import 'package:flutter_test/flutter_test.dart';
import 'package:app1/main.dart';

void main() {
  testWidgets('Kantin Bu Sari menampilkan beranda dan menu', (WidgetTester tester) async {
    await tester.pumpWidget(const KantinBuSariApp());

    expect(find.text('Kantin Bu Sari'), findsOneWidget);
    expect(find.text('Menu pilihan'), findsOneWidget);
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
  });
}
