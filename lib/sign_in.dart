import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:my_wallet/create_wallet_screen.dart';
import 'package:my_wallet/services.dart';

final String url = 'https://oliphoenix.herokuapp.com/auth/sign_up';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // void signIn(String url, Map data) async {
  //   FormData data = FormData.fromMap({
  //     "user_name": _controllerUsername.text,
  //     "password": _controllerPassword.text,
  //   });
  //   try {
  //     Response response = await dio.post(url, data: data);
  //     print(response.statusCode);
  //     // Do whatever
  //   } on DioError {
  //     print('There is an error');
  //   }
  // }

  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controllerUsername,
              decoration: InputDecoration(hintText: "Username"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controllerPassword,
              decoration: InputDecoration(hintText: "Password"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                getUser(_controllerUsername.text, _controllerPassword.text);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletScreen()),
                );
              },
              child: Text("SignIn"))
        ],
      )),
    );
  }
}
