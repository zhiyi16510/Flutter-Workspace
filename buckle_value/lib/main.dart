import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Buckle(),
    );
  }
}

class Buckle extends StatefulWidget {
  const Buckle({Key? key}) : super(key: key);

  @override
  State<Buckle> createState() => _BuckleState();
}

class _BuckleState extends State<Buckle> {
  TextEditingController numberEditingController = TextEditingController();

  String? selectedType;
  String? selectedUnit;
  double value = 0;
  double number = 0;
  double finalValue = 0;
  String unit = " ";
  String exchangedValue = " ";

  List<String> selectList = ["Crypto", "Fiat", "Commodity"];
  List<String> units = [];
  List<String> commodityList = ["xag", "xau"];
  List<String> cryptoList = [
    "btc",
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "bits",
    "sats"
  ];
  List<String> fiatList = [
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uah",
    "vef",
    "vnd",
    "zar",
    "xdr"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
              backgroundColor: const Color.fromARGB(255, 30, 47, 198),
              centerTitle: true,
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              )),
              leading: const Icon(Icons.account_circle),
              leadingWidth: 100,
              title: const Text(
                "Buckle",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              )),
        ),
        body: Center(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/images/buckle_logo.png',
                height: 150, width: 150),
            Container(
              width: 350,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: const Text(
                    " i. crypto is a digital asset that derives from its native blockchain\n ii. fiat money is legal tender tied to government-issued currency",
                    style:
                        TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              ),
            ),
            const Text("Value Exchange",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 300),
                child: TextField(
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                        hintText: 'Enter bitcoin value...',
                        border: const OutlineInputBorder()),
                    textAlign: TextAlign.center,
                    controller: numberEditingController)),
            DropdownButton(
              hint: const Text("Select Convert Type"),
              itemHeight: 60,
              value: selectedType,
              items: selectList.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _onChangedCallback,
            ),
            Scrollbar(
              child: DropdownButton(
                hint: const Text("Select Unit"),
                itemHeight: 60,
                value: selectedUnit,
                items: units.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (unit) {
                  setState(() {
                    selectedUnit = unit.toString();
                  });
                },
              ),
            ),
            ElevatedButton(onPressed: _convert, child: const Text("convert")),
            const Text("Converted Value: ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            Text(exchangedValue,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
          ]),
        )));
  }

  void _onChangedCallback(type) {
    if (type == "Commodity") {
      units = commodityList;
    } else if (type == "Fiat") {
      units = fiatList;
    } else if (type == "Crypto") {
      units = cryptoList;
    } else {
      units = [];
    }

    setState(() {
      selectedType = type.toString();
      selectedUnit = null;
    });
  }

  Future<void> _convert() async {
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);

      number = double.parse(numberEditingController.text);

      setState(() {
        unit = parsedData['rates'][selectedUnit]['unit'];
        value = parsedData['rates'][selectedUnit]['value'];
        finalValue = number * value;

        exchangedValue = "$finalValue $unit";
      });
    }
  }
}
