import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/logging/v2.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';
import '/env/env.dart';

class GoogleCloudLoggingService {
  late LoggingApi _loggingApi;
  bool _isSetup = false;
  final String _projectId = Env.gcpProjectId;

  Future<void> setupLoggingApi() async {
    if (_isSetup) return;

    try {
      final Codec<String, String> stringToBase64 = utf8.fuse(base64);
      final String decodedAccountCredentials =
          stringToBase64.decode(Env.gcpLoggingServiceAccount);

      final ServiceAccountCredentials credentials =
          ServiceAccountCredentials.fromJson(decodedAccountCredentials);
      final AutoRefreshingAuthClient authClient = await clientViaServiceAccount(
        credentials,
        <String>[LoggingApi.loggingWriteScope],
      );

      _loggingApi = LoggingApi(authClient);
      _isSetup = true;
      debugPrint('Cloud Logging API setup for $_projectId');
    } catch (error) {
      debugPrint('Error setting up Cloud Logging API: $error');
    }
  }

  void writeLog({required Level level, required String message}) {
    if (!_isSetup) {
      debugPrint('Cloud Logging API is not setup');
      return;
    }

    final String logName = 'projects/$_projectId/logs/mobile-app';

    final MonitoredResource resource = MonitoredResource()..type = 'global';

    final String severityFromLevel = switch (level) {
      Level.fatal => 'CRITICAL',
      Level.error => 'ERROR',
      Level.warning => 'WARNING',
      Level.info => 'INFO',
      Level.debug => 'DEBUG',
      _ => 'NOTICE',
    };

    final LogEntry logEntry = LogEntry()
      ..logName = logName
      ..jsonPayload = <String, Object?>{'message': message}
      ..resource = resource
      ..severity = severityFromLevel
      ..labels = <String, String>{
        'project_id': _projectId,
        'level': level.name.toUpperCase(),
        'os-version':
            '${Platform.operatingSystem}-${Platform.operatingSystemVersion}',
      };

    final WriteLogEntriesRequest request = WriteLogEntriesRequest()
      ..entries = <LogEntry>[logEntry];

    _loggingApi.entries.write(request).catchError((dynamic error) {
      debugPrint('Error writing log entry: $error');
      return WriteLogEntriesResponse();
    });
  }
}
