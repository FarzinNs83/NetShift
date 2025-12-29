// import 'dart:math';
// import 'dart:convert';
// import 'package:encrypt/encrypt.dart' as encrypt;

// class EncryptionData {
//   static final String keyString = generateRandomKey(32);
//   static final encrypt.Key key = encrypt.Key.fromUtf8(keyString);
//   static final encrypt.IV iv = encrypt.IV.fromLength(16);
//   static final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(key));

//   static String encryptData(String plainText) {
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     return encrypted.base64;
//   }

//   static String decryptData(String encryptedText) {
//     final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
//     return decrypted;
//   }

//   static String generateRandomKey(int length) {
//     final Random random = Random.secure();
//     final List<int> values = List<int>.generate(length, (i) => random.nextInt(256));
//     return base64Url.encode(values).substring(0, length);
//   }
// }
