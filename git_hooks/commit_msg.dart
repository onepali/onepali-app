// ignore_for_file: avoid_print

import 'dart:io';

import 'package:onepali/src/src.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    logger.d('❌ No commit message file provided.');
    exit(1);
  }

  final messageFile = File(args[0]);
  final message = messageFile.readAsStringSync().trim();

  if (!isValidCommitMessage(message)) {
    logger.d('❌ Invalid commit message.');
    logger.d('✅ Format: <type> : <scope> : <short description>');
    logger.d('👉 Example: feat : auth : add login functionality');
    exit(1);
  }

  logger.d('✅ Commit message is valid.');
}

/// Validates the commit message against the Conventional Commits standard.
/// Example of valid format: "feat(auth): add login functionality"
bool isValidCommitMessage(String commitMessage) {
  final pattern = RegExp(
    r'^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert) ?: ?[a-zA-Z0-9_\-]+ ?: .+',
  );
  return pattern.hasMatch(commitMessage);
}
