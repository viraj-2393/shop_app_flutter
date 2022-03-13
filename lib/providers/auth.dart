import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier{
   String _token='';
   DateTime? _expiryDate= null;
   String _userId='';
   Timer? _authTimer = null;

  bool get isAuth{
    return token != '';
  }

  String get token{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return '';
  }

  String get userId{
    return _userId;
  }

  Future<void> _authenticator(String email,String password,String urlSegment) async{
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCnYMHy6GWEwNtyKxWqhVSGVee2FzqbH5U');
    try{
      final response = await http.post(url,body:json.encode({
        'email':email,
        'password': password,
        'returnSecureToken':true
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData',userData);
    }catch(error){
      rethrow;
    }

  }

  Future<void> signup(String email,String password) async{
    return _authenticator(email, password, 'signUp');

  }

  Future<void> login(String email,String password) async{
    return _authenticator(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;

  }

  Future<void> logout() async{
    _token = '';
    _userId = '';
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }
  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry!),logout);
  }
}