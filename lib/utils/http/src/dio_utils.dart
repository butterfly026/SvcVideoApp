part of http;

class DioUtils {
  static Dio? _instance;
  static CancelToken? cancelToken;

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio(BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: 1000 * 60),
        receiveTimeout: const Duration(milliseconds: 1000 * 60),
      ));

      _instance!.interceptors.add(BasicInterceptor());
      _instance!.interceptors.add(ErrorInterceptor());
      _instance!.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseBody: true,
          requestBody: true,
        ),
      );
    }
// 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (false) {
      (_instance?.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          return "PROXY  10.8.12.107:8888";
          // return "proxy";
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
    return _instance!;
  }
}
