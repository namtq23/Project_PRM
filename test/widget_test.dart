import 'package:flutter_test/flutter_test.dart';
import 'package:project_prm/app/app.dart';

void main() {
  testWidgets('router starts on the splash route', (tester) async {
    await tester.pumpWidget(const TourBookingApp());
    await tester.pumpAndSettle();

    expect(find.text('Khám phá'), findsOneWidget);
    expect(find.text('Bắt đầu hành trình'), findsOneWidget);
  });
}
