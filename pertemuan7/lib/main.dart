import 'package:flutter/material.dart';

import 'counter_display.dart';
import 'counter_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App - Pertemuan 7',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showCounter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showCounter = !_showCounter;
              });
            },
            icon: Icon(
              _showCounter ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            label: Text(
              _showCounter ? 'Lepas Widget' : 'Pasang Widget',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _showCounter
          ? const CounterPage()
          : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Widget counter dilepas.\n'
                    'Cek console untuk log "Counter ditutup".\n'
                    'Tekan "Pasang Widget" untuk memasang kembali.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('Counter dimulai');
  }

  @override
  void dispose() {
    debugPrint('Counter ditutup');
    super.dispose();
  }

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterDisplay(counter: _counter),
            const SizedBox(height: 40),
            CounterButtons(
              onAdd: _increment,
              onSubtract: _decrement,
              onReset: _reset,
            ),
          ],
        ),
      ),
    );
  }
}
