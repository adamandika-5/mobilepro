import 'package:flutter/material.dart';

import 'counter_display.dart';
import 'counter_buttons.dart';

void main() {
  runApp(const MyApp());
}

/// Widget root aplikasi.
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

/// Halaman utama yang mengelola tampilan counter
/// dan menyediakan tombol untuk menguji widget lifecycle.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Mengontrol apakah widget CounterPage sedang ditampilkan.
  /// Digunakan untuk menguji lifecycle (initState / dispose).
  bool _showCounter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Tombol kecil untuk menguji lifecycle (mount / unmount)
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

/// Widget StatefulWidget utama yang mengelola state counter.
/// Mengimplementasikan initState() dan dispose() untuk
/// mendemonstrasikan widget lifecycle.
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

  /// Menambah counter sebanyak 1.
  void _increment() {
    setState(() {
      _counter++;
    });
  }

  /// Mengurangi counter sebanyak 1.
  /// Tidak akan mengurangi jika counter sudah 0.
  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  /// Mengembalikan counter ke 0.
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
            // Menampilkan counter melalui widget terpisah
            CounterDisplay(counter: _counter),
            const SizedBox(height: 40),
            // Tombol-tombol counter melalui widget terpisah
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
