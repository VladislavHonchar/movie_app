import 'package:movie_app/domain/api_client/account_api_client.dart';
import 'package:movie_app/domain/api_client/auth_api_client.dart';
import 'package:movie_app/domain/data_provider/session_data_provider.dart';

class AuthService {
  final _accountApiClient = AccountApiClient();
  final _authApiClient = AuthApiClient();
  final _sessionDataProvider = SessionDataProvider();
  
  
  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }


  Future<void> login (String login, String password) async {
    final sessionId = await _authApiClient.auth(
      username: login, 
      password: password
      );
    final accountId = await _accountApiClient.getAccountInfo(sessionId);
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }
  Future<void> logOutUser() async{
    await _sessionDataProvider.deleteSessionId();
    await _sessionDataProvider.deleteAccountId();
  }
}