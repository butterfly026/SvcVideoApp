import 'dart:convert';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:crypto/crypto.dart';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Encrypt Util.
class EncryptUtil {
  static String rsaPrvKey = "";
  static String rsaPubKey = "";
  static String encKeyAttrName = "";

  static dynamic decryptResponse(String encryptedText, String aesKey) {
    /// After a lot of research on how to convert the public key [String] to [RSA PUBLIC KEY]
    /// We would have to use PEM Cert Type and the convert it from a PEM to an RSA PUBLIC KEY through basic_utils
    var pem =
        '-----BEGIN RSA PRIVATE KEY-----\n$rsaPrvKey\n-----END RSA PRIVATE KEY-----';
    var prv = CryptoUtils.rsaPrivateKeyFromPem(pem);

    final decrypter = enc.Encrypter(enc.RSA(privateKey: prv));
    final decrypted = decrypter.decrypt64(aesKey);

    // Convert decrypted bytes to string
    String aesDecKey = utf8.decode(base64.decode(decrypted));
    Uint8List aesKeyBytes = Uint8List.fromList(utf8.encode(aesDecKey));
    String decRspStr = EncryptUtil.aesDecrypt(encryptedText, aesKeyBytes);
    if(decRspStr.isEmpty) {
      return {
        'code': 200,
        'data' : null
      };
    } else {
      return json.decode(decRspStr);
    }
  }

  static String generateAESKey(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return Iterable.generate(
        length, (_) => characters[random.nextInt(characters.length)]).join();
  }

  static String getRSAEncryptedAESKey(String aesKey) {
    Uint8List aesKeyBytes = utf8.encode(aesKey);
    var pem =
        '-----BEGIN RSA PUBLIC KEY-----\n$rsaPubKey\n-----END RSA PUBLIC KEY-----';
    var pub = CryptoUtils.rsaPublicKeyFromPem(pem);
    final encrypter = enc.Encrypter(enc.RSA(publicKey: pub));
    String bs64AesKey = base64.encode(aesKeyBytes);
    final encryptedAesBytes = encrypter.encrypt(bs64AesKey);

    return encryptedAesBytes.base64;
  }

  static String encryptRequest(dynamic data, String aesKey) {
    Uint8List aesKeyBytes = utf8.encode(aesKey);
    String concatenatedParameters = jsonEncode(data);
    return aesEncrypt(concatenatedParameters, aesKeyBytes);
  }

  ///AES解密
  static String aesDecrypt(String bs64EncryptedData, Uint8List keyBytes) {
    // Create a PointyCastle BlockCipher object using AES
    final encrypter =
        enc.Encrypter(enc.AES(enc.Key(keyBytes), mode: enc.AESMode.ecb));
    return encrypter.decrypt64(bs64EncryptedData);
  }
  
  ///AES加密
  static String aesEncrypt(String plainText, Uint8List keyBytes) {
    final encrypter =
        enc.Encrypter(enc.AES(enc.Key(keyBytes), mode: enc.AESMode.ecb));
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }

  static String generateSignature(Map<String, String> parameters) {
    // Concatenate parameters
    String concatenatedParameters = concatenateParameters(parameters);
    debugPrint(concatenatedParameters);
    // MD5 hash
    String signature = generateMd5(concatenatedParameters);
    return signature.toUpperCase();
  }

  static String concatenateParameters(Map<String, String> parameters) {
    // Sort parameters alphabetically
    List<String> sortedKeys = parameters.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    // Construct concatenated string
    String concatenatedParameters = sortedKeys.map((key) {
      return '$key=${parameters[key]}';
    }).join('&');

    return concatenatedParameters;
  }

  /// md5 加密
  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String signedReqData(dynamic data) {
    Map<String, String> requestData = {};
    List<String> standardKeys = [
      'content-type',
      'accept',
      'authorization',
      'content-length'
    ];
    // List<String> defaultParams = ['clientid', 'packagename', 'tenantid', 'version'];
    (data as Map).forEach((key, value) {
      if (!standardKeys.contains(key.toString().toLowerCase())) {
        requestData[key as String] = value == null ? '' : value.toString();
      }
    });
    return generateSignature(requestData);
  }
  
}
