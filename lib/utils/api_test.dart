

import 'dart:convert';

import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/utils/encrypt_util.dart';

import 'http/http.dart';

class ApiTest {

  Future<String> testApiSpeed() async {
    List<String> apiEndpoints = AppConfig.apiBinList;

    String fastestEndpoint = '';
    double fastestResponseTime = double.infinity;
    String fastestResponse = '';
    String secondFastestEndpoint = ''; //第二次最优baseUrl

    List<Future<void>> futures = [];

    for (String endpoint in apiEndpoints) {
      futures.add(_testEndpoint(endpoint, fastestResponseTime, (elapsedMilliseconds, response) {
        if (elapsedMilliseconds < fastestResponseTime) {
          fastestResponseTime = elapsedMilliseconds;
          fastestEndpoint = endpoint;
          fastestResponse = response;
        }
      }));
    }

    await Future.wait(futures);

    print('第一次选优，最快的 API 是：$fastestEndpoint');
    // 解码 Base64
    String decodedResponse = utf8.decode(base64.decode(fastestResponse));
    print('第一次选优，最快的 API 的响应：$decodedResponse');
    //处理加解密
    Map<String, dynamic> map = await jsonDecode(decodedResponse);
    if (map.containsKey('headerFlag')) {
      EncryptUtil.encKeyAttrName = map['headerFlag'] ?? 'encrypt-key';
      EncryptUtil.rsaPrvKey = map['privateKey'] ?? '';
      EncryptUtil.rsaPubKey = map['publicKey'] ?? '';
    }

    // 提取新的 API 列表
    List<String> newApiList = extractApiList(decodedResponse);
    return newApiList[0];
    // // 第二次选优
    // secondFastestEndpoint =   await testApiSpeedAgain(newApiList);
    // return secondFastestEndpoint;
  }

  List<String> extractApiList(String decodedResponse) {
    try {
      Map<String, dynamic> responseData = json.decode(decodedResponse);
      List<dynamic> apiList = responseData['api'];
      return apiList.map((api) => api.toString()).toList();
    } catch (error) {
      print('解析 API 列表时发生错误: $error');
      return [];
    }
  }

  Future<String> testApiSpeedAgain(List<String> apiList) async {
    String fastestEndpoint = '';
    double fastestResponseTime = double.infinity;
    List<Future<void>> futures = [];

    for (String endpoint in apiList) {
      futures.add(_testEndpoint(endpoint, fastestResponseTime, (elapsedMilliseconds, _) {
        if (elapsedMilliseconds < fastestResponseTime) {
          fastestResponseTime = elapsedMilliseconds;
          fastestEndpoint = endpoint;
        }
      }));
    }

    await Future.wait(futures);

    print('第二次选优，最快的 API 是：$fastestEndpoint');
    // setState(() {
    //   fastestApi = fastestEndpoint;
    //   fastestApiResponse = '第二次选优无需解码内容';
    // });
    return fastestEndpoint;
  }

  Future<void> _testEndpoint(String endpoint, double currentFastestTime, Function(double, dynamic) updateFastestTime) async {
    Stopwatch stopwatch = Stopwatch()..start();
    print('发出请求：$endpoint，时间：${DateTime.now()}');

    try {
      final response = await http.get(endpoint);
      stopwatch.stop();

      if (response.statusCode == 200) {
        double elapsedMilliseconds = stopwatch.elapsedMilliseconds.toDouble();
        print('得到响应，API：$endpoint，耗时：$elapsedMilliseconds 毫秒');
        updateFastestTime(elapsedMilliseconds, response.data);
      } else {
        print('请求失败，状态码: ${response.statusCode}');
      }
    } catch (error) {
      print('请求期间发生错误: $error');
    }
  }
}