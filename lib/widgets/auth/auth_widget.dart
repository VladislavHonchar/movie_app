

import 'package:flutter/material.dart';
import 'package:movie_app/Theme/button_style.dart';
import 'package:movie_app/widgets/main_screen/main_screen_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login to your account"),
      ),
      body: ListView(
        children: [
          SizedBox(height: 25),
          _FormWidget(),
          SizedBox(height: 25),
          _HeaderWidget(),
        ],
      ),
      );
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25,),
          Text(
            "Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой.",
            style: textStyle
            ),
          SizedBox(height: 5,),
          TextButton(
            style: AppButtonStyle.linkButton,
              onPressed: (){}, 
              child: Text("Register")),
          SizedBox(height: 25,),
          Text("Если Вы зарегистрировались, но не получили письмо для подтверждения.",
          style: textStyle,),
          SizedBox(height: 5,),
          TextButton(
            style: AppButtonStyle.linkButton,
            onPressed: (){}, 
            child: Text("Verification email")),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({super.key});

  @override
  State<_FormWidget> createState() => __FormWidgetState();
}

class __FormWidgetState extends State<_FormWidget> {
  final _loginTextController = TextEditingController(text: 'admin');
  final _passwordTextController = TextEditingController(text: 'admin');
  String? errorText = null;
  
  void _auth(){
    final login = _loginTextController.text;
    final password = _passwordTextController.text;
    if(login == "admin" && password == "admin"){
      errorText = null;
     //Navigator.of(context).pushNamed('/main_screen');
     Navigator.of(context).pushReplacementNamed('/main_screen');
    }else{
      errorText = "Wrong Username or password";
      print(errorText);
    }
    setState(() {
      
    });
  }
  void _resetPassword(){
    print("reset password");
  }
  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF01b4e4);
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
    final errorText = this.errorText;
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(errorText != null )... [
            Text(
            errorText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 17),
            ),
            SizedBox(height: 20),
            ],
          Text("Username",
          style: textStyle,),
          SizedBox(height: 5),
          TextField(
            controller: _loginTextController,
            decoration: textFieldDecoration
          ),
          SizedBox(height: 20),
          Text("Password",
          style: textStyle,),
          SizedBox(height: 5),
          TextField(
            controller: _passwordTextController,
            decoration: textFieldDecoration,
            obscureText: true,
            ),
            SizedBox(height: 25,),
            Row(
              children: <Widget>[
                
                ElevatedButton(onPressed: _auth, 
                child: Text("Login"),
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll(TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
                  backgroundColor: MaterialStatePropertyAll(color),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                    horizontal: 15,
                  vertical: 8)
                  )
                ),
                ),
                SizedBox(width: 30),
                TextButton(
                  onPressed: _resetPassword,
                style: AppButtonStyle.linkButton, 
                child: Text("Reset password")),
              ],
            )
        ],
      ),
    );
  }
}