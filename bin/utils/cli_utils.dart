import 'dart:io' as io;
import './general_utils.dart';

abstract class ProcessManager {
  Future<io.ProcessResult> run(String command, List<String> arguments, {String? workingDirectory});

  Future<io.Process> start(String command, List<String> arguments, {String? workingDirectory});
}

class IoProcessManager implements ProcessManager {
  @override
  Future<io.ProcessResult> run(
    String command,
    List<String> arguments, {
    String? workingDirectory,
  }) =>
      io.Process.run(command, arguments, workingDirectory: workingDirectory);

  @override
  Future<io.Process> start(String command, List<String> arguments, {String? workingDirectory}) =>
      io.Process.start(command, arguments, workingDirectory: workingDirectory);
}

class CliUtils {
  CliUtils({ProcessManager? processManager})
      : _processManager = processManager ?? IoProcessManager();

  final ProcessManager _processManager;

  Future<String> runCommand(
    String command, {
    List<String> arguments = const <String>[],
    String? workingDirectory,
  }) async {
    final io.ProcessResult result = await _processManager.run(
      command,
      arguments,
      workingDirectory: workingDirectory,
    );

    if (result.exitCode != 0) {
      throw CliException(
        command: command,
        arguments: arguments,
        errorOutput: result.stderr.toString(),
        exitCode: result.exitCode,
      );
    }

    return result.stdout.toString().trim();
  }

  Future<io.Process> startCommand(
    String command, {
    List<String> arguments = const <String>[],
    String? workingDirectory,
  }) async {
    return _processManager.start(command, arguments, workingDirectory: workingDirectory);
  }

  Future<void> commitChanges(String commitMessage) async {
    final String repoRoot = getRepositoryRoot();

    await runCommand('git', arguments: <String>['add', '.'], workingDirectory: repoRoot);

    await runCommand(
      'git',
      arguments: <String>['commit', '-m', '"$commitMessage"', '--no-verify'],
      workingDirectory: repoRoot,
    );
  }

  Future<void> pushChanges({String? rootDir}) async {
    final String repoRoot = rootDir ?? getRepositoryRoot();

    await runCommand(
      'git',
      arguments: <String>['push', '-u', 'origin', 'main', '--no-verify'],
      workingDirectory: repoRoot,
    );
  }
}

class CliException implements Exception {
  CliException({
    required this.command,
    required this.arguments,
    required this.errorOutput,
    required this.exitCode,
  });

  final String command;
  final List<String> arguments;
  final String errorOutput;
  final int exitCode;

  @override
  String toString() {
    final String args = arguments.join(' ');
    return 'Command "$command $args" failed with exit code $exitCode:\n$errorOutput';
  }
}
