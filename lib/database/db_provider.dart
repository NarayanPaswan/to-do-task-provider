import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/exports.dart';

class DatabaseProvider extends ChangeNotifier{

final _pref =  SharedPreferences.getInstance();
  String _token = '';
  String _userId = '';
  String get token => _token;
  String get userId => _userId;

  String _responseMessage = '';
  //getter
  
  String get responseMessage => _responseMessage;
  
   void saveToken(String token) async {
    SharedPreferences value = await _pref;
    value.setString('token', token);
    }


    Future<void> saveUserId(String id) async {
    SharedPreferences value = await _pref;
    value.setString('id', id);
    }
  
    Future<String> getToken() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('token')) {
      String data = value.getString('token')!;
      _token = data;
      notifyListeners();
      return data;
    } else {
      _token = '';
      notifyListeners();
      return '';
    }
    }

    Future<String> getUserId() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('id')) {
      String data = value.getString('id')!;
      _userId = data;
      notifyListeners();
      return data;
    } else {
      _userId = '';
      notifyListeners();
      return '';
    }
  }

    Future<void> logOut() async {
    final value = await _pref;
    value.clear();
    _responseMessage = "Logut successful!";
     notifyListeners();
    
    }




}