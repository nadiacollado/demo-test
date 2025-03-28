import 'package:flutter/material.dart';
import 'package:demo_test/widgets.dart' show EditUserProfileWidget;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Edit User Profile Widget',
  type: EditUserProfileWidget,
)
Widget useCaseEditUserProfileWidget(BuildContext context) {
  return EditUserProfileWidget(
    onUsernameChanged: (username) {},
    onFirstNameChanged: (firstName) {},
    onLastNameChanged: (lastName) {},
    onPronounsChanged: (pronouns) {},
    onAgeChanged: (age) {},
    onLocationChanged: (location) {},
    onBioChanged: (bio) {},
    disableSaveButtonExperiment: true,
    onSave: () {},
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
