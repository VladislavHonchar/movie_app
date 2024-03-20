import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';
import 'package:movie_app/ui/widgets/loader_widget/loader_view_cubit.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (previous, current) => current != LoaderViewCubitState.unknow,
      listener: onLoaderViewCubitStateChange,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void onLoaderViewCubitStateChange(BuildContext context, LoaderViewCubitState state){
    final nextScreen = state == LoaderViewCubitState.authorized 
        ? MainNavigationRouteName.mainScreen 
        : MainNavigationRouteName.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}