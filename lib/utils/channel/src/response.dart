const String _errCode = 'code';
const String _errStr = 'error';

typedef _RhChannelResponseInvoker = RhChannelResponse Function(
    Map<dynamic, dynamic> argument);

Map<String, _RhChannelResponseInvoker> _nameAndResponseMapper = {
  'onQRCodeResponse': (Map<dynamic, dynamic> argument) =>
      QRCodeResponse.fromMap(argument),
};

class RhChannelResponse {
  RhChannelResponse._(this.errCode, this.errStr);

  factory RhChannelResponse.create(
    String name,
    Map<dynamic, dynamic> argument,
  ) {
    final result = _nameAndResponseMapper[name];
    if (result == null) {
      throw ArgumentError("Can't found instance of $name");
    }
    return result(argument);
  }

  int? errCode;
  String? errStr;

  bool get isSuccessful => errCode == 200;
}

class QRCodeResponse extends RhChannelResponse {
  QRCodeResponse.fromMap(Map<dynamic, dynamic> map)
      : value = map['data'] as String,
        super._(map[_errCode] as int, map[_errStr] as String);

  String value;
}
