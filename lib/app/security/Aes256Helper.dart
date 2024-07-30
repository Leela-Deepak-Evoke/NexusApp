import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Aes256Helper {
  static AesKeys generateRandomKeyAndIV() {
    final key = Key.fromSecureRandom(32); // 32 bytes for AES-256
    final iv = IV.fromSecureRandom(16); // 16 bytes for AES-256 in GCM mode

    return AesKeys(key: base64Encode(key.bytes), iv: base64Encode(iv.bytes));
  }

  static String encrypt(String text, AesKeys keys) {
    safePrint('------------------------ encrypt --------------------');
    Key key = Key.fromBase64(keys.key);
    IV iv = IV.fromBase64(keys.iv);
    safePrint('---- key: ----- $key');
    safePrint('---- iv: ----- $iv');
    // final encrypter = Encrypter(AES(key));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(text, iv: iv);
    final encryptedBase64 = encrypted.base64;
    safePrint(
        '---- ---- ---- encryptedBase64: ---- ---- ----- $encryptedBase64');

    return encryptedBase64;
  }

  static String decrypt(String cipherText, AesKeys keys) {
    safePrint('------------------------ decrypt --------------------');
    safePrint('---- cipherText: ----- $cipherText');
    safePrint('---- AesKeys: ----- $keys');

    Key key = Key.fromBase64(keys.key);
    IV iv = IV.fromBase64(keys.iv);

    // final encrypter = Encrypter(AES(key));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS5'));
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(cipherText), iv: iv);
    final decryptedText = decrypted;
    safePrint('---- ---- ---- decryptedText: ---- ---- ----- $decryptedText');
    return decryptedText;
  }
}

class AesKeys {
  final String key, iv;
  const AesKeys({required this.key, required this.iv});
}

class SecureStorage {
  static Future<void> saveEncryptedData(String key, String value) async {
    // Generate random key and IV for encryption
    final keys = Aes256Helper.generateRandomKeyAndIV();
    // Encrypt the value using the generated keys
    final encryptedValue = Aes256Helper.encrypt(value, keys);
    // Save the encrypted value and keys to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$key-key', keys.key);
    await prefs.setString('$key-iv', keys.iv);
    await prefs.setString(key, encryptedValue);
  }

  static Future<String?> getDecryptedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedValue = prefs.getString(key);
    final keyString = prefs.getString('$key-key');
    final ivString = prefs.getString('$key-iv');
    if (encryptedValue != null && keyString != null && ivString != null) {
      final keys = AesKeys(key: keyString, iv: ivString);
      // Decrypt the encrypted value
      return Aes256Helper.decrypt(encryptedValue, keys);
    }
    return null;
  }
}
