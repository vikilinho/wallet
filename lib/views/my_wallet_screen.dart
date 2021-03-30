import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_wallet/services.dart';

class AllWalletScreen extends StatefulWidget {
  @override
  _AllWalletScreenState createState() => _AllWalletScreenState();
}

class _AllWalletScreenState extends State<AllWalletScreen> {
  TextEditingController _title = TextEditingController();
  String dropdownValue = 'Dollar';

  Future<List<GetWallet>> _futureWallet;
  @override
  void initState() {
    super.initState();
    _futureWallet = fetchWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: (_futureWallet == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 200,
                        child: TextField(
                          controller: _title,
                          decoration: InputDecoration(
                            hintText: "TItle",
                          ),
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Dollar', 'Naira']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // MyStatefulWidget(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // _futureWallet = fetchWallet();
                            });
                          },
                          child: Text("Create Wallets")),
                    )
                  ],
                )
              : FutureBuilder<List<GetWallet>>(
                  future: _futureWallet,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<GetWallet> data = snapshot.data;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Text(data[index].title),
                                    leading: CircleAvatar(
                                        child: Text(data[index].id.toString())),
                                    subtitle: Text(data[index].walletType),
                                    trailing: Text(data[index].status),
                                  ),
                                ),
                                Text(
                                  "UserId: ${data[index].userId.toString()}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  })),
    );
  }
}

Future<List<GetWallet>> fetchWallet() async {
  // String token = box.read('getTok');
  print('I am here too');
  // print(token);
  final response = await http.get(
    Uri.parse('https://oliphoenix.herokuapp.com/wallets'),

    // body: jsonEncode(Data)

    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $getTok',
    },
  );

  if (response.statusCode == 200) {
    // Wallet.fromJson(json.decode(response.body));
    print('I got here');
    print(response.body);

    // If the server did return a 201 CREATED response,
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((data) => new GetWallet.fromJson(data)).toList();
    // return GetWallet.fromJson(jsonDecode(response.body));
    // then parse the JSON.

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}
