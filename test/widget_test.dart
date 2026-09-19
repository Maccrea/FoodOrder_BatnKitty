// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter_test/flutter_test.dart';

// import 'package:batnkitty_food/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const Batnkitty_food());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:batnkitty_food/logic/customer/customer_catalog_bloc.dart';
import 'package:batnkitty_food/presentation/pages/customer/customer_home_dashboard.dart';

void main() {
	testWidgets('customer dashboard renders', (tester) async {
		await tester.pumpWidget(
			BlocProvider(
				create: (_) => CustomerCatalogBloc(),
				child: const MaterialApp(home: CustomerHomeDashboard()),
			),
		);
		await tester.pump();

		expect(find.text('Lapar?'), findsOneWidget);
		expect(find.text('Lihat Menu'), findsOneWidget);
	});
}
