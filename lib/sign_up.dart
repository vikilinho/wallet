import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_wallet/sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String endPoint = 'https://oliphoenix.herokuapp.com/auth/sign_up';
  void _choose() async {
    File file;
    file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      //source: ImageSource.gallery,
    );
    if (file != null) {
      _upload(file);
      setState(() {});
    }
  }

  void _upload(File file) async {
    String fileName = file.path.split('/').last;
    print(fileName);

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "user_name": _controllerUsername.text,
      "password": _controllerPassword.text,
    });

    Dio dio = new Dio();

    dio.post(endPoint, data: data).then((response) {
      // var jsonResponse = jsonDecode(response.toString());
      print(response.statusCode);
    }).catchError((error) => print(error));
  }

  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
          CircleAvatar(
            backgroundColor: Colors.white,
            child: GestureDetector(
              onTap: () async {
                _choose();
              },
              child: Icon(
                Icons.camera_alt,
                color: Color.fromRGBO(104, 202, 215, 1),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                // createUser(
                //     _controllerUsername.text, _controllerPassword.text, _image);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: Text("SignUp")),
        ],
      )),
    );
  }
}
