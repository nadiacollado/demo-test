import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/common_widgets/common_full_width.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/localized_pump.dart';

void main() {
  group('CommonFullWidth', () {
    testWidgets('renders child with full width', (WidgetTester tester) async {
      const double width = 600;
      await tester.localizedPump(
        const SizedBox(
          width: width,
          child: CommonFullWidth(
            child: Placeholder(),
          ),
        ),
      );

      final Finder sizedBox = find.ancestor(
        of: find.byType(CommonFullWidth),
        matching: find.byType(SizedBox),
      );
      final SizedBox sizedBoxWidget = tester.widget(sizedBox);
      expect(sizedBoxWidget.width, equals(width));

      final Finder placeholder = find.byType(Placeholder);
      final Size placeholderSize = tester.getSize(placeholder);

      expect(placeholderSize.width, equals(width));
    });
  });
}
