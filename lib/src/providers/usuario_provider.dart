import 'dart:convert';

import 'package:formvalidators/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebaseTokent = 'AIzaSyBRQUZva7UGCtaSNiy1znlUvp_-USY6J28';

  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {

    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseTokent',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if( decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return { 'ok' : true, 'token' : decodedResp['idToken'] };
    } else {
      return { 'ok' : false, 'mensaje' : decodedResp['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> crearUsuario(String email, String password) async {

    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseTokent',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if( decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return { 'ok' : true, 'token' : decodedResp['idToken'] };
    } else {
      return { 'ok' : false, 'mensaje' : decodedResp['error']['message'] };
    }
  }

}