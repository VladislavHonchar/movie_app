// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:movie_app/domain/api_client/account_api_client.dart';
import 'package:movie_app/domain/api_client/auth_api_client.dart';
import 'package:movie_app/domain/data_provider/session_data_provider.dart';

abstract class AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;

  AuthLoginEvent({
    required this.login,
    required this.password,
  });
}



abstract class AuthState {}

class AuthAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
  other is AuthAuthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthUnAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      other is AuthUnAuthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFailureState extends AuthState {
  final Object error;
  AuthFailureState({
    required this.error,
  });



  @override
  bool operator ==(covariant AuthFailureState other) {
    if (identical(this, other)) return true;
  
    return 
      other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class AuthinProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
  other is AuthinProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthCheckStatusInProgressState extends AuthState {
   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCheckStatusInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _accountApiClient = AccountApiClient();
  final _authApiClient = AuthApiClient();
  final _sessionDataProvider = SessionDataProvider();

  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckStatusEvent) {
        await onAuthCheckStatusEvent(event, emit);
      } else if (event is AuthLoginEvent) {
        await onAuthLoginEvent(event, emit);
      } else if (event is AuthLogoutEvent) {
        await onAuthLogoutEvent(event, emit);
      }
    }, transformer: sequential());
    add(AuthCheckStatusEvent());
  }

  Future<void> onAuthCheckStatusEvent(
      AuthCheckStatusEvent event, 
      Emitter<AuthState> emit) async {
    emit(AuthinProgressState());
    final sessionId = await _sessionDataProvider.getSessionId() ?? '';
    final newState =
        sessionId != '' ? AuthAuthorizedState() : AuthUnAuthorizedState();
    emit(newState);
  }

  Future<void> onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthinProgressState());
      final sessionId = await _authApiClient.auth(
          username: event.login, password: event.password);
      final accountId = await _accountApiClient.getAccountInfo(sessionId);
      await _sessionDataProvider.setSessionId(sessionId);
      await _sessionDataProvider.setAccountId(accountId);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailureState(error: e));
    }
  }

  Future<void> onAuthLogoutEvent(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataProvider.deleteSessionId();
      await _sessionDataProvider.deleteAccountId();
    } catch (e) {
      emit(AuthFailureState(error: e));
    }
  }
}