import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/domain/api_client/api_client_exeption.dart';
import 'package:movie_app/domain/blocs/auth_bloc.dart';


abstract class AuthViewCubitState{}


class AuthViewCubitFormFillInProgressState extends AuthViewCubitState{

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}



class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

}

class AuthViewCubitAuthProgressState extends AuthViewCubitState{
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
class AuthViewCubitSuccessAuthState extends AuthViewCubitState{

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitSuccessAuthState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}


class AuthViewCubit extends Cubit<AuthViewCubitState>{
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(
    AuthViewCubitState initialState, 
    this.authBloc
    ) : super(initialState){
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }


  bool _isValid(String login, String password) =>
      login.isNotEmpty || password.isNotEmpty;

  void auth({required String login, required String password}){
    if(!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Please, enter your login or password');
      emit(state);
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));

  }
  void _onState(AuthState state) {
    if(state is AuthUnAuthorizedState){
      emit(AuthViewCubitFormFillInProgressState());
    }else if(state is AuthAuthorizedState){
      authBlocSubscription.cancel();
      emit(AuthViewCubitSuccessAuthState());
    }else if( state is AuthFailureState){
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    }else if( state is AuthinProgressState){
      emit(AuthViewCubitAuthProgressState());
    }else if( state is AuthCheckStatusInProgressState){
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error){
    if(error is! ApiClientExeption){
      return 'Somthing went wrong';
    }
    switch (error.type) {
        case ApiClientExeptionType.network:
          return "Сервер недоступний, перевірте з'єднання з інтернетом";
        case ApiClientExeptionType.auth:
          return "Невірний логін або пароль";
        case ApiClientExeptionType.sessionExpired:
          return "Ключ помер";
        case ApiClientExeptionType.other:
          return "Відбулась помилка. Спробуйте ще раз";
      }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }

}


