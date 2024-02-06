import 'dart:convert';
import 'dart:io';

import 'package:movie_app/domain/entity/popular_movie_response.dart';


enum ApiClientExeptionType{Network, Auth, Other}

class ApiClientExeption implements Exception{
  final ApiClientExeptionType type;

  ApiClientExeption(this.type);
}

class ApiClient {
   final _client = HttpClient();
   static const _host = 'https://api.themoviedb.org/3';
   static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
   static const _apiKey = 'aed2cbc8df99e936e75f28ad7fea27f5';

   static String imageUrl(String path) => _imageUrl + path;

   Future<String> auth(
    {required String username, 
    required String password,
    }) async {
      final token = await _makeToken();
      final validToken = await _validateUser(
        username: username, 
        password: password, 
        requestToken: token
      );
      final sessionId = await _makeSession(requestToken: validToken);
      return sessionId;
    }
   Future<T> _get<T>(
    String path, 
    T Function(dynamic json) parser, 
    [Map<String, dynamic>? parameters]) 
    async{
    final url = _makeUri(path, parameters);
    try{
    final request = await _client.getUrl(url);
    final response = await request.close();
    final dynamic json = (await response.jsonDecode());
    _validateResponse(response, json);
    final result = parser(json);
    return result;
    }on SocketException{
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption{
      rethrow;
    }catch (_){
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
   }
   Future<T> _post<T>(String path, T Function(dynamic json) parser, Map<String, dynamic> bodyParameters, [Map<String, dynamic>? urlParameters]) async{
    try{
    final url = _makeUri(
      path, 
      urlParameters,
    );
    final request = await _client.postUrl(url);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(bodyParameters));
    final response = await request.close();
    final dynamic json = (await response.jsonDecode());
    _validateResponse(response, json);
    final result = parser(json);
    return result;
    }on SocketException{
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption{
      rethrow;
    }catch (error){
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
   }

   Uri _makeUri(String path, [Map<String, dynamic>? parameters]){
    final uri = Uri.parse('$_host$path');
    if(parameters != null){
      return uri.replace(queryParameters: parameters);
    }else {
      return uri;
    }
   }
   

   Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }
    final result = _get('/authentication/token/new',parser, <String, dynamic>{'api_key': _apiKey});
    return result;
   }

   Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    parser(dynamic json) {
       final jsonMap = json as Map<String, dynamic>;
       final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }
    final result = _get('/movie/popular',
    parser, 
    <String, dynamic>{
      'api_key': _apiKey,
      'page': page.toString(),
      'language': locale,
      });
    return result;
   }

   Future<String> _validateUser(
    {required String username, 
    required String password, 
    required String requestToken}
    ) async {
      parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken
    };
    final result = _post('/authentication/token/validate_with_login', parser, parameters, <String, dynamic>{'api_key': _apiKey});
    return result;
   }


    Future<String> _makeSession(
    {
    required String requestToken}
    ) async {
      parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
    return sessionId;
    }
    final parameters = <String, dynamic>{
      'request_token': requestToken
    };
    final result = _post('/authentication/session/new', parser, parameters, <String, dynamic>{'api_key': _apiKey});
    return result;
   }

   
   
   }

   extension HttpClientResponseJsoneDecode on HttpClientResponse {
    Future<dynamic> jsonDecode() async {
      return transform(utf8.decoder)
          .toList()
          .then((value) => value.join())
          .then<dynamic>((v) => json.decode(v));
    }
   }
    void _validateResponse(HttpClientResponse response, dynamic json) {
      if(response.statusCode == 401){
        final dynamic status = json['status_code']; 
        final code = status is int ? status : 0;
        if(code == 30){
        throw ApiClientExeption(ApiClientExeptionType.Auth);
        }else {
          throw ApiClientExeption(ApiClientExeptionType.Other);
        }
      }
    }