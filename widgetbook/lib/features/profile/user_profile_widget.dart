import 'package:flutter/material.dart';
import 'package:demo_test/widgets.dart' show UserProfileWidget;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'User Profile Widget',
  type: UserProfileWidget,
)
Widget useCaseUserProfileWidget(BuildContext context) {
  return UserProfileWidget(
    username: 'JohnDoe',
    email: 'john.doe@example.com',
    firstName: 'John',
    lastName: 'Doe',
    age: '30',
    location: 'New York',
    pronouns: 'He/Him',
    bio: 'Software Developer',
  );
}
