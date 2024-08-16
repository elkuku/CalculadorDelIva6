import 'package:flutter/material.dart';
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

  void _taxUp() {
    setState(() {
      _taxValue++;
    });
  }

  void _taxDown() {
    if (_taxValue > 0) {
      setState(() {
        _taxValue--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setInt('taxValue', _taxValue);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Tax: $_taxValue %',
              style: const TextStyle(fontSize: 24),
            ),
            IconButton(
              onPressed: _taxUp,
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: _taxDown,
              icon: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
