// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/core/common_widgets/common_full_width.dart'
    as _i2;
import 'package:widgetbook_workspace/core/common_widgets/common_public_scaffold.dart'
    as _i3;
import 'package:widgetbook_workspace/core/common_widgets/common_scaffold.dart'
    as _i4;
import 'package:widgetbook_workspace/core/common_widgets/common_text_form_field.dart'
    as _i5;
import 'package:widgetbook_workspace/core/common_widgets/counter_stepper.dart'
    as _i6;
import 'package:widgetbook_workspace/features/authentication/email_verification_widget.dart'
    as _i7;
import 'package:widgetbook_workspace/features/authentication/login_widget.dart'
    as _i8;
import 'package:widgetbook_workspace/features/authentication/sign_up_widget.dart'
    as _i9;
import 'package:widgetbook_workspace/features/profile/edit_user_profile_widget.dart'
    as _i10;
import 'package:widgetbook_workspace/features/profile/user_profile_widget.dart'
    as _i11;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'core',
    children: [
      _i1.WidgetbookFolder(
        name: 'common_widgets',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'CommonFullWidth',
            useCase: _i1.WidgetbookUseCase(
              name: 'default',
              builder: _i2.useCaseCommonFullWidth,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'CommonPublicScaffold',
            useCase: _i1.WidgetbookUseCase(
              name: 'default',
              builder: _i3.useCaseCommonScaffold,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'CommonScaffold',
            useCase: _i1.WidgetbookUseCase(
              name: 'default',
              builder: _i4.useCaseCommonScaffold,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'CommonTextFormField',
            useCase: _i1.WidgetbookUseCase(
              name: 'default',
              builder: _i5.useCaseCommonTextFormField,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'CounterStepper',
            useCase: _i1.WidgetbookUseCase(
              name: 'default',
              builder: _i6.useCaseCounterStepper,
            ),
          ),
        ],
      )
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'features',
    children: [
      _i1.WidgetbookFolder(
        name: 'authentication',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'email_verification',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'EmailVerificationWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'default',
                      builder: _i7.useCaseEmailVerificationWidget,
                    ),
                  )
                ],
              ),
              _i1.WidgetbookFolder(
                name: 'login_screen',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'LoginWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Login Widget',
                      builder: _i8.useCaseLoginWidget,
                    ),
                  )
                ],
              ),
              _i1.WidgetbookFolder(
                name: 'sign_up_screen',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'SignUpWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Sign Up Widget',
                      builder: _i9.useCaseSignUpWidget,
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'profile',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'EditUserProfileWidget',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Edit User Profile Widget',
                  builder: _i10.useCaseEditUserProfileWidget,
                ),
              ),
              _i1.WidgetbookLeafComponent(
                name: 'UserProfileWidget',
                useCase: _i1.WidgetbookUseCase(
                  name: 'User Profile Widget',
                  builder: _i11.useCaseUserProfileWidget,
                ),
              ),
            ],
          )
        ],
      ),
    ],
  ),
];
