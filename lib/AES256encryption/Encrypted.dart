import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class AesEncryption{
  // static final key=Key.fromUtf8(base64Encode(randomBytes(32)));
  static final key=Key.fromLength(32);
  // static final iv=IV.fromUtf8(base64Encode(randomBytes(16)));
  static final iv=IV.fromLength(16);
  static final encrypter=encrypt.Encrypter(encrypt.AES(key,mode: AESMode.cbc));

  // final key = Key.fromUtf8('my 32 length key................');
  // final iv = IV.fromLength(16);


  static encryptAES(text){
    final encrypted=encrypter.encrypt(text,iv:iv);
    // print(encrypted.bytes);
    // print(encrypted.base64);

   // return key.base64+iv.base64+encrypted.base64;
   return '${base64Encode(key.bytes)}:${base64Encode(encrypted.bytes)}:${base64Encode(iv.bytes)}';
  }
}