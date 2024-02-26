enum ApiClientExeptionType{network, auth, other, sessionExpired}

class ApiClientExeption implements Exception{
  final ApiClientExeptionType type;

  ApiClientExeption(this.type);
}