import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController bilangan1Controller = TextEditingController();
  TextEditingController bilangan2Controller = TextEditingController();
  TextEditingController operatorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: bilangan1Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bilangan 1'),
              ),
              TextField(
                controller: bilangan2Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bilangan 2'),
              ),
              TextField(
                controller: operatorController,
                decoration: InputDecoration(labelText: 'Operator (+, -, *, /)'),
              ),
              ElevatedButton(
                onPressed: hitungHasil,
                child: Text('Hitung'),
              ),
              ElevatedButton(
                onPressed: tampilkanHasil,
                child: Text('Tampilkan Hasil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> hitungHasil() async {
    final bilangan1 = double.tryParse(bilangan1Controller.text) ?? 0.0;
    final bilangan2 = double.tryParse(bilangan2Controller.text) ?? 0.0;
    final operator = operatorController.text;

    double hasil = 0.0;

    if (operator == '+') {
      hasil = bilangan1 + bilangan2;
    } else if (operator == '-') {
      hasil = bilangan1 - bilangan2;
    } else if (operator == '*') {
      hasil = bilangan1 * bilangan2;
    } else if (operator == '/') {
      hasil = bilangan1 / bilangan2;
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('hasil', hasil);
    await preferences.setString('operator', operator);
  }

  Future<void> tampilkanHasil() async {
    final preferences = await SharedPreferences.getInstance();
    final hasil = preferences.getDouble('hasil') ?? 0.0;
    final operator = preferences.getString('operator') ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hasil Operasi Aritmatik'),
          content: Text('Hasil: $hasil\nOperator: $operator'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}