import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculador del IVA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculador del IVA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _withoutTax = 0;
  double _tax = 0;
  final _textController = TextEditingController();

  void _clear() {
    _textController.text = "";
    setState(() {
      _tax = 0.0;
      _withoutTax = 0.0;
    });
  }

  void _updateResults() {
    var taxPercent = 12;
    var taxRate = 1 + taxPercent / 100;

    double? total = 0.0;
    var tax = 0.0;
    var withoutTax = 0.0;
    if (_textController.text != "") {
      total = double.tryParse(_textController.text);
      if (total != null) {
        withoutTax = total / taxRate;
        tax = total - withoutTax;
      }
    }
    setState(
          () {
        _tax = tax;
        _withoutTax = withoutTax;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle ts = const TextStyle(
        fontFamily: "monospace",
        fontFamilyFallback: <String>["Courier"],
        fontSize: 27,
        color: Colors.blueAccent
    );
    TextStyle ts2 = const TextStyle(
      fontFamily: "monospace",
      fontFamilyFallback: <String>["Courier"],
      fontSize: 27,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('d - M - yyyy').format(DateTime.now()),
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 24
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Sin IVA'),
              Text(
                _withoutTax.toStringAsFixed(2),
                style: ts,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('IVA'),
              Text(
                _tax.toStringAsFixed(2),
                style: ts,
              ),
            ],
          ),
          TextField(
            textAlign: TextAlign.end,
            style: ts2,
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Total'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              //FilteringTextInputFormatter.digitsOnly
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            onChanged: (text) => {_updateResults()},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clear,
        tooltip: 'Clear',
        child: const Icon(Icons.restore_from_trash),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
