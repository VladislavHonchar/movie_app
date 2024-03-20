import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Theme/button_style.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';
import 'package:movie_app/ui/widgets/auth/auth_view_cubit.dart';
import 'package:movie_app/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:provider/provider.dart';

class _AuthDataStorage{
  String login = '';
  String password = '';
}


class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listener: _onAuthViewCubitStateChange,
      child: Provider(
        create: (_) =>  _AuthDataStorage(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Login to your account"),
          ),
          body: ListView(
            children: const [
              SizedBox(height: 25),
              _FormWidget(),
              SizedBox(height: 25),
             _HeaderWidget(),
            ],
          ),
          ),
      ),
    );
  }

  void _onAuthViewCubitStateChange(
    BuildContext context, 
    AuthViewCubitState state){
    if(state is AuthViewCubitSuccessAuthState){
      MainNavigation.resetNavigation(context);
    }
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
              fontSize: 16,
              color: Colors.black
            );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25,),
          const Text(
            "Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой.",
            style: textStyle
            ),
          const SizedBox(height: 5,),
          TextButton(
            style: AppButtonStyle.linkButton,
              onPressed: (){}, 
              child: const Text("Register")),
          const SizedBox(height: 25,),
          const Text("Если Вы зарегистрировались, но не получили письмо для подтверждения.",
          style: textStyle,),
          const SizedBox(height: 5,),
          TextButton(
            style: AppButtonStyle.linkButton,
            onPressed: (){}, 
            child: const Text("Verification email")),
        ],
      ),
    );
  }
}
class _FormWidget extends StatelessWidget {
  const _FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<_AuthDataStorage>();
     const textStyle = TextStyle(
              fontSize: 16,
              color: Color(0xFF212529)
    );
    const textFieldDecoration = InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            isCollapsed: true,
            //focusColor: color,
    );
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const _ErrorMessage(),
          const Text("Username",
          style: textStyle,),
          const SizedBox(height: 5),
          TextField(
            decoration: textFieldDecoration,
            onChanged: (value) => authDataStorage.login = value,
          ),
          const SizedBox(height: 20),
          const Text("Password",
          style: textStyle,),
          const SizedBox(height: 5),
          TextField(
            decoration: textFieldDecoration,
            obscureText: true,
            onChanged: (value) => authDataStorage.password = value,
            ),
            const SizedBox(height: 25,),
            Row(
              children:[
                const _AuthButtonWidget(),
                const SizedBox(width: 30),
                TextButton(
                  onPressed: (){},
                style: AppButtonStyle.linkButton, 
                child: const Text("Reset password")),
              ],
            )
        ],
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  

  const _AuthButtonWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<_AuthDataStorage>();
    final cubit = context.watch<AuthViewCubit>();
    const color = Color(0xFF01b4e4);
    final canStartAuth = cubit.state is AuthViewCubitFormFillInProgressState || cubit.state is AuthViewCubitErrorState;
    final onPressed = canStartAuth ? ()=> cubit.auth(login: authDataStorage.login, password: authDataStorage.password) : null;
    final child = cubit.state is AuthViewCubitAuthProgressState
    ? const SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(strokeWidth: 2,))
    : const Text("Login");
    return ElevatedButton(
                onPressed: onPressed, 
                style: const  ButtonStyle(
                  textStyle: MaterialStatePropertyAll(TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
                  backgroundColor: MaterialStatePropertyAll(color),
                  foregroundColor:   MaterialStatePropertyAll(Colors.white),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                    horizontal: 15,
                  vertical: 8)
                  )
                ),
                child: child,
                );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {

    final errorMessage = context.select((AuthViewCubit value){
      final state = value.state;
      return state is AuthViewCubitErrorState ? state.errorMessage : null;
    });
    if(errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 17),
              ),
    );
  }
}
