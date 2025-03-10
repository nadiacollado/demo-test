import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/features/navigation/presentation/nav_drawer_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/localized_pump.dart';

void main() {
  testWidgets('displays correct icon and title', (WidgetTester tester) async {
    const IconData testIcon = Icons.home;
    final String testTitle = tester.t.nav_home;
    bool wasTapped = false;

    await tester.localizedPump(
      NavDrawerItem(
        icon: testIcon,
        title: testTitle,
        onTap: () => wasTapped = true,
      ),
    );

    expect(find.byIcon(testIcon), findsOneWidget);
    expect(find.text(testTitle.toUpperCase()), findsOneWidget);

    await tester.tap(find.byType(ListTile));

    expect(wasTapped, isTrue);
  });
}
