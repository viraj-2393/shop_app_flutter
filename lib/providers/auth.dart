import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
class Auth with ChangeNotifier{
   String _token='';
   DateTime _expiryDate=DateTime.now();
   String _userId='';

  bool get isAuth{
    return token != '';
  }

  String get token{
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
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
      notifyListeners();
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
}