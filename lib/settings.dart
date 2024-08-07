import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  int _taxValue = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _taxValue = prefs.getInt('taxValue') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.greenAccent,
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setInt('taxValue', _taxValue);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Tax Value'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value == "") {
                  return;
                }
                _taxValue = int.parse(value);
              },
              controller: TextEditingController(text: _taxValue.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
