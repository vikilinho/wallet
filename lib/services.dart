import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

var getTok;

class LogIn {
  final String user_name;
  final String password;

  LogIn({this.user_name, this.password});
  factory LogIn.fromJson(Map<String, dynamic> json) {
    return LogIn(
      user_name: json['user_name'],
      password: json['password'],
    );
  }
}

Future<LogIn> getUser(
  String user_name,
  String password,
) async {
  final response = await http.post(
    Uri.parse('https://oliphoenix.herokuapp.com/auth/login'),
    headers: {"Content-Type": "application/json"},
    // body: jsonEncode(Data)
    body: jsonEncode(<String, String>{
      'user_name': user_name,
      'password': password,
    }),
  );
  if (response.statusCode == 201) {
    print(response.statusCode);
    print(response.body);
    var resp = json.decode(response.body);

    String token = resp['accessToken'];

    storage.write('newtoken', '$token');
    getTok = token;
    print(getTok);
    print('I am here');

    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    return LogIn.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception("Login not successful");
  }
}

class Wallet {
  final String title;
  final String walletType;
  final String status;
  final int userId;
  final int id;

  Wallet({this.title, this.id, this.status, this.userId, this.walletType});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
        title: json['title'],
        walletType: json['walletType'],
        status: json['status'],
        userId: json['userId'],
        id: json['id']);
  }
}

Future<Wallet> createWallet(
  String title,
  String walletType,
) async {
  // String token = box.read('getTok');
  print('I am here too');
  // print(token);
  final response = await http.post(
    Uri.parse('https://oliphoenix.herokuapp.com/wallets'),

    // body: jsonEncode(Data)
    body: jsonEncode(<String, String>{
      'title': title,
      'walletType': walletType,
    }),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $getTok',
    },
  );

  if (response.statusCode == 201) {
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);

    // Wallet.fromJson(json.decode(response.body));

    // If the server did return a 201 CREATED response,
    return Wallet.fromJson(jsonDecode(response.body));
    // then parse the JSON.

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}
// To parse this JSON data, do
//
//     final getWallet = getWalletFromJson(jsonString);

List<GetWallet> getWalletFromJson(String str) =>
    List<GetWallet>.from(json.decode(str).map((x) => GetWallet.fromJson(x)));

String getWalletToJson(List<GetWallet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetWallet {
  GetWallet({
    this.id,
    this.walletType,
    this.status,
    this.title,
    this.userId,
  });

  int id;
  String walletType;
  String status;
  String title;
  int userId;

  factory GetWallet.fromJson(Map<String, dynamic> json) => GetWallet(
        id: json["id"],
        walletType: json["walletType"],
        status: json["status"],
        title: json["title"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "walletType": walletType,
        "status": status,
        "title": title,
        "userId": userId,
      };

  // Future<List<GetWallet>> fetchWallet() async {
  //   // String token = box.read('getTok');
  //   print('I am here too');
  //   // print(token);
  //   final response = await http.get(
  //     Uri.parse('https://oliphoenix.herokuapp.com/wallets'),

  //     // body: jsonEncode(Data)

  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $getTok',
  //     },
  //   );

  //   if (response.statusCode == 201) {
  //     // Wallet.fromJson(json.decode(response.body));
  //     print(response.body);

  //     // If the server did return a 201 CREATED response,
  //     List jsonResponse = json.decode(response.body);

  //     return jsonResponse.map((data) => new GetWallet.fromJson(data)).toList();
  //     // return GetWallet.fromJson(jsonDecode(response.body));
  //     // then parse the JSON.

  //   } else {
  //     // If the server did not return a 201 CREATED response,
  //     // then throw an exception.
  //     throw Exception(response.statusCode);
  //   }
  // }
}
