import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginResponse.dart';

import 'memory_management.dart';

class SingletonCacheData {
  static final SingletonCacheData _singleton = SingletonCacheData._internal();
  LoginResponse _userData;

  LoginResponse getUserInfo() {
    if (_userData == null) {
      var userData = MemoryManagement.getUserData();
      if (userData != null) {
        Map<String, dynamic> data = jsonDecode(userData);
        _userData = LoginResponse.fromJson(data);
      }
    }
    return _userData;
  }

  void updateCache(LoginResponse loginResponse) {
    var userData = jsonEncode(loginResponse.toJson());
    MemoryManagement.setUserData(data: userData);
    _userData = null;
  }
  void resetCache()
  {
    _userData=null;
  }

  factory SingletonCacheData() {
    return _singleton;
  }

  SingletonCacheData._internal();
}
