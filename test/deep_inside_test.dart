import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:deep_inside/deep_inside.dart';

void main() {
  late Directory testDirectory;

  setUp(() async {
    // Create a temporary directory for isolated testing
    testDirectory = Directory.systemTemp.createTempSync('deep_inside_test');
    await DeepInside.init(customPath: testDirectory.path);
  });

  tearDown(() async {
    // Clean up the temporary directory after tests
    await testDirectory.delete(recursive: true);
  });

  group('DeepInside Tests', () {
    test('Set and get a value', () async {
      await DeepInside.setValue('test_key', 'test_value');
      final result = DeepInside.getValue<String>('test_key');
      expect(result, 'test_value');
    });

    test('Remove a value', () async {
      await DeepInside.setValue('remove_key', 'remove_value');
      await DeepInside.remove('remove_key');
      final result = DeepInside.getValue<String>('remove_key');
      expect(result, null);
    });

    test('Clear all data', () async {
      await DeepInside.setValue('key1', 'value1');
      await DeepInside.setValue('key2', 'value2');
      await DeepInside.clear();
      expect(DeepInside.getValue<String>('key1'), null);
      expect(DeepInside.getValue<String>('key2'), null);
    });

    test('Save and retrieve token', () async {
      await DeepInside.saveToken('secure_token');
      final token = DeepInside.getToken();
      expect(token, 'secure_token');
    });

    test('Save and retrieve locale', () async {
      await DeepInside.saveLocale('en_US');
      final locale = DeepInside.getLocale();
      expect(locale, 'en_US');
    });

    test('Save and retrieve user data', () async {
      final userData = {'id': 1, 'name': 'John Doe'};
      await DeepInside.saveUser(userData);
      final user = DeepInside.getUser();
      expect(user, userData);
    });

    test('Overwrite token', () async {
      await DeepInside.saveToken('old_token');
      await DeepInside.saveToken('new_token');
      final token = DeepInside.getToken();
      expect(token, 'new_token');
    });

    test('Overwrite user data', () async {
      final oldUserData = {'id': 1, 'name': 'John Doe'};
      final newUserData = {'id': 2, 'name': 'Jane Doe'};
      await DeepInside.saveUser(oldUserData);
      await DeepInside.saveUser(newUserData);
      final user = DeepInside.getUser();
      expect(user, newUserData);
    });

    test('Persist data between sessions', () async {
      await DeepInside.saveToken('persistent_token');

      // Reinitialize DeepInside
      await DeepInside.init(customPath: testDirectory.path);

      final token = DeepInside.getToken();
      expect(token, 'persistent_token');
    });
  });
}
