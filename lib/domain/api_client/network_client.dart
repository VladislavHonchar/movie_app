import 'dart:convert';
import 'dart:io';

import 'package:movie_app/config/configuration.dart';
import 'package:movie_app/domain/api_client/api_client_exeption.dart';

class NetworkClient {
  final _client = HttpClient();


  Uri _makeUri(String path, [Map<String, dynamic>? parameters]){
    final uri = Uri.parse('${Configuration.host}$path');
    if(parameters != null){
      return uri.replace(queryParameters: parameters);
    }else {
      return uri;
    }
   }
  Future<T> get<T>(
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
      throw ApiClientExeption(ApiClientExeptionType.network);
    } on ApiClientExeption{
      rethrow;
    }catch (_){
      throw ApiClientExeption(ApiClientExeptionType.other);
    }
   }
   
   
   Future<T> post<T>(String path, T Function(dynamic json) parser, Map<String, dynamic> bodyParameters, [Map<String, dynamic>? urlParameters]) async{
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
      throw ApiClientExeption(ApiClientExeptionType.network);
    } on ApiClientExeption{
      rethrow;
    }catch (error){
      throw ApiClientExeption(ApiClientExeptionType.other);
    }
   }
   
    void _validateResponse(HttpClientResponse response, dynamic json) {
      if(response.statusCode == 401){
        final dynamic status = json['status_code']; 
        final code = status is int ? status : 0;
        if(code == 30){
        throw ApiClientExeption(ApiClientExeptionType.auth);
        }else if (code == 3) {
          throw ApiClientExeption(ApiClientExeptionType.sessionExpired);
        }else {
          throw ApiClientExeption(ApiClientExeptionType.other);
        }
      }
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