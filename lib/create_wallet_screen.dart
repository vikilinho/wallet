import 'package:flutter/material.dart';
import 'package:my_wallet/views/my_wallet_screen.dart';
import 'package:my_wallet/services.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController _title = TextEditingController();
  String dropdownValue = 'Dollar';
  Future<Wallet> _futureWallet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              _futureWallet =
                                  createWallet(_title.text, dropdownValue);
                            });
                          },
                          child: Text("Create Wallets")),
                    )
                  ],
                )
              : FutureBuilder<Wallet>(
                  future: _futureWallet,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Title: ${snapshot.data.title}',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('WalletType: ${snapshot.data.walletType}',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('Status: ${snapshot.data.status}',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'UserId: ${snapshot.data.userId.toString()}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('TicketId: ${snapshot.data.id.toString()}',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllWalletScreen()),
                                  );
                                });
                              },
                              child: Text("View More Wallets")),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  })),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Dollar';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
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
      items: <String>[
        'Dollar',
        'Naira',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

ListView _jobsListView(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].title, data[index].status, data[index].id,
            data[index].walletType, data[index].id);
      });
}

ListTile _tile(String title, String subtitle, String leading, String trailing,
        String id) =>
    ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Row(children: [
        Text(leading),
        Text(id),
      ]),
      trailing: Text(trailing),
    );
