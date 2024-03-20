// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_app/domain/blocs/auth_bloc.dart';
//import 'package:movie_app/domain/services/auth_service.dart';
//import 'package:movie_app/ui/navigation/main_navigation.dart';

enum LoaderViewCubitState {
  authorized, unAuthorized, unknow
}

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;
  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState){
    Future.microtask((){
      _onState(authBloc.state);
      authBlocSubscription = authBloc.stream.listen(_onState);
      authBloc.add(AuthCheckStatusEvent());
    });
  }

  void _onState(AuthState state) {
    if(state is AuthAuthorizedState){
      emit(LoaderViewCubitState.authorized);
    }else if(state is AuthUnAuthorizedState){
      emit(LoaderViewCubitState.unAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }

}


// class LoaderViewModel{
//   final BuildContext context;
//   final _authService = AuthService();
//   LoaderViewModel(this.context){
//     asyncInit();
//   }
//   Future<void> asyncInit() async{
//     await checkAuth();
//   }

//   Future<void> checkAuth() async{
//     final isAuth = await _authService.isAuth();
//     final nextScreen = isAuth 
//     ? MainNavigationRouteName.mainScreen
//     : MainNavigationRouteName.auth;
//     navigateToScreen(nextScreen);
//   }

//   void navigateToScreen(String nextScreen) {
//     Navigator.of(context).pushReplacementNamed(nextScreen);
//   }
// }