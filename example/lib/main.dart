import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3flutter/web3flutter.dart';
import 'smart_contracts/brlc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final web3 = Web3Flutter(
    url: 'https://rpc.mainnet.cloudwalk.io',
    publicKey: '0x75A9A96C4870eF0F269e653A25A3ff4De8F5C171',
  );

  double balance = 0;
  String owner = '';
  String symbol = '';
  late final Brlc brlc;

  @override
  void initState() {
    brlc = Brlc(web3: web3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web3Flutter'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(balance.toString()),
            ),
            Center(
              child: Text(owner),
            ),
            Center(
              child: Text(symbol),
            ),
            CupertinoButton(
              child: const Text('Contract'),
              onPressed: () async {
                // balance = await brlc.balanceOf(account: web3.address);
                // owner = (await brlc.owner()).hex;
                // symbol = await brlc.symbol();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
