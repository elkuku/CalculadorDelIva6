import 'package:calculador_del_iva_6/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculador extends StatefulWidget {
  const Calculador({super.key, required this.title});

  final String title;

  @override
  State<Calculador> createState() => _CalculadorState();
}

class _CalculadorState extends State<Calculador> {
  double _withoutTax = 0;
  double _tax = 0;
  final _textController = TextEditingController();

  int _taxValue = 0;

  @override
  void initState() {
    super.initState();

    _loadPreferences();
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _taxValue = preferences.getInt('taxValue') ?? 0;
    });

    return preferences;
  }

  void _clear() {
    _textController.text = '';
    setState(() {
      _tax = 0.0;
      _withoutTax = 0.0;
    });
  }

  void _updateResults() {
    var taxRate = 1 + _taxValue / 100;

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
        fontSize: 32,
        color: Colors.greenAccent);
    TextStyle ts2 = const TextStyle(
      fontFamily: "monospace",
      fontFamilyFallback: <String>["Courier"],
      fontSize: 32,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              print('opei');
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return const Settings();
//                    return Text('HEY');
                  }).then((onValue) async {
                print('SAving...');
                await _loadPreferences();
                _updateResults();
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              ).then((value) async {
                await _loadPreferences();
                _updateResults();
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('d - M - yyyy').format(DateTime.now()),
                style: const TextStyle(color: Colors.green, fontSize: 36),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                flex: 6,
                child: Text(
                  'Sin IVA',
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  _withoutTax.toStringAsFixed(2),
                  textAlign: TextAlign.end,
                  style: ts,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  'IVA ${_taxValue.toString()} %',
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  _tax.toStringAsFixed(2),
                  textAlign: TextAlign.end,
                  style: ts,
                ),
              ),
            ],
          ),
          const Divider(),
          TextField(
            textAlign: TextAlign.end,
            style: ts2,
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Total',
              hintText: 'Total',
            ),
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
        backgroundColor: Colors.white24,
        onPressed: _clear,
        tooltip: 'Clear',
        child: const Icon(Icons.restore_from_trash),
      ),
    );
  }
}
