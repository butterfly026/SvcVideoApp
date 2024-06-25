import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/encrypt_util.dart';
import 'package:get/get.dart' hide Response;
import 'package:oktoast/oktoast.dart';

import 'view_state_error_type.dart';

enum HttpMethod { get, post, delete, put, patch, formData }

class ApiService {
  Dio dio;

  dynamic showErrorToast = true;

  ApiService({
    required this.dio,
  });

  /// get 请求体
  Future<HttpResponse> get(
    String url, {
    dynamic data,
    Options? options,
    showErrorToast = true,
  }) {
    if (showErrorToast != null) {
      this.showErrorToast = showErrorToast;
    }
    return _sendRequest(
      url,
      HttpMethod.get,
      data: data,
      options: options,
    );
  }

  /// post 请求体
  Future<HttpResponse> post(
    String url, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    showErrorToast = true,
  }) {
    if (showErrorToast != null) {
      this.showErrorToast = showErrorToast;
    }
    return _sendRequest(
      url,
      HttpMethod.post,
      data: data,
      options: options,
      queryParameters: queryParameters,
    );
  }

  /// delete 请求体
  Future<HttpResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _sendRequest(
      url,
      HttpMethod.delete,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// put 请求体
  Future<HttpResponse> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _sendRequest(
      url,
      HttpMethod.put,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// 发送请求
  Future<HttpResponse> _sendRequest(
    String url,
    HttpMethod method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      Response? response;
      data ??= <String, dynamic>{
        'TenantId': '000000',
      };
      options ??= Options();
      options.preserveHeaderCase = true;
      options.headers ??= {};
      options.headers?['Content-Type'] = 'application/json';
      if (AppConfig.isEncEnabled) {
        options.responseType = ResponseType.plain;
      }
      if(AppConfig.isEncEnabled) {        
        if(method != HttpMethod.get) {
          String aesKey = EncryptUtil.generateAESKey(AppConfig.aesKeyLength);
          options.headers![EncryptUtil.encKeyAttrName] = EncryptUtil.getRSAEncryptedAESKey(aesKey);
          data = EncryptUtil.encryptRequest(data, aesKey);
          // data = jsonEncode(data);
        }
      }
      
      if (method == HttpMethod.get) {
        if (data == null) {
          response = await dio.get(url);
        } else {
          response = await dio.get(
            url,
            options: options,
            queryParameters: data,
          );
        }
      }

      if (method == HttpMethod.post) {
        if (data == null) {
          response = await dio.post(
            url,
            options: options,
            queryParameters: queryParameters,
          );
        } else {
          response = await dio.post(
            url,
            data: data,
            options: options,
            queryParameters: queryParameters,
          );
        }
      }

      if (method == HttpMethod.delete) {
        if (data == null) {
          response = await dio.delete(url);
        } else {
          response = await dio.delete(
            url,
            options: options,
            data: data,
            queryParameters: queryParameters,
          );
        }
      }

      if (method == HttpMethod.put) {
        if (data == null) {
          response = await dio.put(url);
        } else {
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        }
      }

      

      /// 接口响应成功
      if (response!.statusCode == 200) {
        String codeFieldName = AppConfig.codeFiledName;
        String messageFiledName = AppConfig.messageFiledName;        
        
        Map<String, dynamic> dataMap = <String, dynamic>{};        
        try {
          if (null != response.data) {
            if (response.data is Map<String, dynamic>) {
              dataMap = response.data as Map<String, dynamic>;
            } else if (response.data is String) {
              if(CommonUtil.isJson(response.data)) {
                dataMap = jsonDecode(response.data) as Map<String, dynamic>;
              } else if (AppConfig.isEncEnabled) {
                String aesKey = response.headers.value(EncryptUtil.encKeyAttrName).toString();
                dataMap = EncryptUtil.decryptResponse(response.data, aesKey);
                debugPrint('\n********** Decrypted Response **********\n ${dataMap.toString()}');
              }
            }
          }
        } catch (error) {
          /// void
          debugPrint('error ======> $error');
        }

        var resultCode = dataMap[codeFieldName];
        var message = dataMap[messageFiledName];
        debugPrint("Message of the response: $message");
        if (resultCode != 200) {
          if (resultCode == 401) {
            IndexRepository repository = Global.getIt<IndexRepository>();
            await repository.login(dataMap);
            repository.userInfo();
            // final currentRoute = Get.currentRoute;
            // if (currentRoute == AppRouter.splash) {
            //   // eventBus.fire(SplashReloadEvent());
            // } else {
            //   Get.offAllNamed(AppRouter.splash);
            // }
          } else {
            String? errorMsg;
            if (dataMap['code'] == 500) {
              if (showErrorToast) {
                showToast(message);
              }
            } else {
              errorMsg = message;
              if (showErrorToast) {
                showToast('$errorMsg');
              }
            }
            throw HttpException(
              type: ViewStateErrorType.serverError,
              code: resultCode,
              message: errorMsg,
            );
          }
        }
        return HttpResponse(
          message: message,
          success: true,
          // data: dataMap,
          data: dataMap['data'],
          list: dataMap,
        );
      }

      /// 接口请求失败 http状态码 != 200
      var type = ViewStateErrorType.defaultError;
      if (response.statusCode == 401 || response.statusCode == 402) {
        type = ViewStateErrorType.unauthorized;
      }
      // if (response.statusCode == 500 || response.statusCode == 502) {
      //   type = ViewStateErrorType.serverError;
      // }
      if (response.statusCode == 502) {
        type = ViewStateErrorType.serverError;
      }

      showToast("网络不给力，休息一会再试");

      throw HttpException(
        type: type,
        code: response.statusCode,
        message: response.data.toString(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          final currentRoute = Get.currentRoute;
          if (currentRoute == AppRouter.splash) {
            // eventBus.fire(SplashReloadEvent());
          } else {
            Get.offAllNamed(AppRouter.splash);
          }
        }
      }
      return HttpResponse(
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }
}

class HttpResponse {
  HttpResponse({
    required this.success,
    required this.message,
    this.data,
    this.list,
  });

  bool success;
  dynamic data;
  String message = "";
  dynamic list;
}

class HttpException implements Exception {
  HttpException({
    this.code,
    this.type = ViewStateErrorType.defaultError,
    this.message,
  });

  int? code;

  ViewStateErrorType? type;

  String? message;

  @override
  String toString() {
    return 'GlobalException httpCode: $code, resp: $message, type: $type';
  }
}
