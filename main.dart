
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const RegistrasiPage(),
    );
  }
}

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _namaFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String? _jenisKelamin;
  String? _programStudi;
  bool _setuju = false;

  final List<String> _programStudiList = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Sistem Enterprise',
  ];

  void _daftar() {
    if (!_setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan setujui syarat dan ketentuan terlebih dahulu.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jenis kelamin.'),
        ),
      );
      return;
    }

    if (_programStudi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih program studi.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 45,
          ),
          title: const Text('Konfirmasi Registrasi'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Periksa kembali data berikut:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                _barisData('Nama', _namaController.text),
                _barisData('Email', _emailController.text),
                _barisData('Jenis Kelamin', _jenisKelamin!),
                _barisData('Program Studi', _programStudi!),
                _barisData('Syarat & Ketentuan', 'Disetujui'),
                const SizedBox(height: 12),
                const Text(
                  'Password tidak ditampilkan demi keamanan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Periksa Lagi'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Registrasi berhasil disimulasikan!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  Widget _barisData(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _namaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 55,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Buat Akun Baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Lengkapi data diri untuk mendaftar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 28),

                      TextFormField(
                        controller: _namaController,
                        focusNode: _namaFocus,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          hintText: 'Masukkan nama lengkap',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_emailFocus);
                        },
                      ),
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'contoh@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Email harus mengandung @';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocus);
                        },
                      ),
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Minimal 6 karakter',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 22),

                      const Text(
                        'Jenis Kelamin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      RadioGroup<String>(
                        groupValue: _jenisKelamin,
                        onChanged: (value) {
                          setState(() {
                            _jenisKelamin = value;
                          });
                        },
                        child: const Column(
                          children: [
                            RadioListTile<String>(
                              title: Text('Laki-laki'),
                              value: 'Laki-laki',
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              title: Text('Perempuan'),
                              value: 'Perempuan',
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        initialValue: _programStudi,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Program Studi',
                          prefixIcon: Icon(Icons.school_outlined),
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text('Pilih program studi'),
                        items: _programStudiList.map((prodi) {
                          return DropdownMenuItem<String>(
                            value: prodi,
                            child: Text(prodi),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _programStudi = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      CheckboxListTile(
                        value: _setuju,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'Saya setuju dengan Syarat & Ketentuan',
                          style: TextStyle(fontSize: 14),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _setuju = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: _daftar,
                          icon: const Icon(Icons.app_registration),
                          label: const Text(
                            'Daftar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        ' Semua data wajib dilengkapi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
