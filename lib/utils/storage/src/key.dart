part of storage;

class StorageKey {

  static const String _keyPrefix = 'key';
  static const String token = '${_keyPrefix}_token';
  static const String login = '${_keyPrefix}_login';
  static const String userInfo = '${_keyPrefix}_user_info';
  static const String appConfig = '${_keyPrefix}_app_config';
  static const String mainApp = '${_keyPrefix}_main_app';
  static const String needUpdateUserInfo = '${_keyPrefix}_needUpdateUserInfo';

}
