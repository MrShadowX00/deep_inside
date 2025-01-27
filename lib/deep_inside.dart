import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

class DeepInside {
  static late File _storageFile;
  static late Uint8List _encryptionKey;
  static late Map<String, dynamic> _storageData;
  static const int _ivLength = 16;
  static const int _saltLength = 16;
  static const int _iterationCount = 10000;

  /// Initializes the library, optionally with a custom path for testing.
  static Future<void> init({String? customPath}) async {
    final directory = customPath != null
        ? Directory(customPath)
        : await getApplicationDocumentsDirectory();

    _storageFile = File('${directory.path}/secure_storage.dat');
    final keyFile = File('${directory.path}/secure_storage.key');

    if (await keyFile.exists()) {
      _encryptionKey = await _deriveKey(await keyFile.readAsBytes());
    } else {
      final salt = _generateRandomBytes(_saltLength);
      await keyFile.writeAsBytes(salt);
      _encryptionKey = await _deriveKey(salt);
    }

    if (await _storageFile.exists()) {
      final encryptedContent = await _storageFile.readAsBytes();
      if (encryptedContent.isNotEmpty) {
        final decryptedContent = await _decrypt(encryptedContent);
        _storageData = jsonDecode(decryptedContent);
      } else {
        _storageData = {};
      }
    } else {
      _storageData = {};
      await _saveToFile();
    }
  }

  /// Generates cryptographically secure random bytes.
  static Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(length, (_) => random.nextInt(256)));
  }

  /// Derives an encryption key using PBKDF2.
  static Future<Uint8List> _deriveKey(Uint8List salt) async {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, _iterationCount, 32));
    return pbkdf2.process(Uint8List.fromList(Platform.localHostname.codeUnits));
  }

  /// Encrypts data using AES in CBC mode with PKCS7 padding.
  static Future<Uint8List> _encrypt(String plainText) async {
    final iv = _generateRandomBytes(_ivLength);
    final cipher = PaddedBlockCipher("AES/CBC/PKCS7")
      ..init(
        true,
        PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
          ParametersWithIV<KeyParameter>(KeyParameter(_encryptionKey), iv),
          null,
        ),
      );

    final plainData = Uint8List.fromList(utf8.encode(plainText));
    final cipherText = cipher.process(plainData);

    // Prepend IV to the encrypted data
    final result = Uint8List(_ivLength + cipherText.length);
    result.setRange(0, _ivLength, iv);
    result.setRange(_ivLength, result.length, cipherText);

    return result;
  }

  /// Decrypts data using AES in CBC mode with PKCS7 padding.
  static Future<String> _decrypt(Uint8List encryptedData) async {
    final iv = encryptedData.sublist(0, _ivLength);
    final cipherText = encryptedData.sublist(_ivLength);

    final cipher = PaddedBlockCipher("AES/CBC/PKCS7")
      ..init(
        false,
        PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
          ParametersWithIV<KeyParameter>(KeyParameter(_encryptionKey), iv),
          null,
        ),
      );

    final plainData = cipher.process(cipherText);
    return utf8.decode(plainData);
  }

  /// Saves the current storage data to the file.
  static Future<void> _saveToFile() async {
    final content = jsonEncode(_storageData);
    final encryptedContent = await _encrypt(content);
    await _storageFile.writeAsBytes(encryptedContent);
  }

  /// Sets a value for a given key and saves it.
  static Future<void> setValue(String key, dynamic value) async {
    _storageData[key] = value;
    await _saveToFile();
  }

  /// Retrieves a value for a given key.
  static T? getValue<T>(String key) {
    return _storageData[key] as T?;
  }

  /// Removes a value for a given key.
  static Future<void> remove(String key) async {
    _storageData.remove(key);
    await _saveToFile();
  }

  /// Clears all stored data.
  static Future<void> clear() async {
    _storageData.clear();
    await _saveToFile();
  }

  // --- Custom Save Methods ---

  /// Saves a token securely.
  static Future<void> saveToken(String token) async {
    await setValue('api_token', token);
  }

  /// Retrieves the saved token.
  static String? getToken() {
    return getValue<String>('api_token');
  }

  /// Saves the user's locale settings.
  static Future<void> saveLocale(String locale) async {
    await setValue('locale', locale);
  }

  /// Retrieves the saved locale settings.
  static String? getLocale() {
    return getValue<String>('locale');
  }

  /// Saves user data securely.
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await setValue('user', user);
  }

  /// Retrieves the saved user data.
  static Map<String, dynamic>? getUser() {
    return getValue<Map<String, dynamic>>('user');
  }
}
