import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:faker/faker.dart' as faker_lib;
import 'package:intl/date_symbol_data_local.dart';

import 'models/kontak_model.dart';
import 'pages/kontak_page.dart';
import 'pages/cari_page.dart';
import 'pages/profil_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0), 
          brightness: Brightness.light,
        ),
        textTheme: TextTheme().apply(
          bodyColor: const Color(0xFF1C1B1F),
          displayColor: const Color(0xFF1C1B1F),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _halamanAktif = 0;

  late final List<KontakModel> _daftarKontak;

  @override
  void initState() {
    super.initState();
    _daftarKontak = _buatDataDummy();
  }

  List<KontakModel> _buatDataDummy() {
    final faker = faker_lib.Faker();

    final kategoriList = [
      KategoriKontak.keluarga,
      KategoriKontak.teman,
      KategoriKontak.kerja,
      KategoriKontak.teman,
      KategoriKontak.keluarga,
    ];

    return List.generate(20, (index) {
      final prefix = ['0812', '0813', '0821', '0822', '0851', '0852', '0878'];
      final p = prefix[index % prefix.length];
      final nomor = faker.randomGenerator.integer(99999999, min: 10000000);

      return KontakModel(
        id: 'kontak_$index',
        namaLengkap: '${faker.person.firstName()} ${faker.person.lastName()}',
        nomorTelepon: '$p$nomor',
        email: faker.internet.email(),
        tanggalDitambahkan: DateTime.now().subtract(
          Duration(days: faker.randomGenerator.integer(730, min: 1)),
        ),
        kategori: kategoriList[index % kategoriList.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final halamanList = <Widget>[
      KontakPage(daftarKontak: _daftarKontak),
      CariPage(daftarKontak: _daftarKontak),
      const ProfilPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _halamanAktif,
        children: halamanList,
      ),

      bottomNavigationBar: ConvexAppBar(
        color: colorScheme.onPrimary.withValues(alpha: 0.7),
        activeColor: Colors.white,
        backgroundColor: colorScheme.primary,
        items: const [
          TabItem(icon: Icons.contacts_rounded, title: 'Kontak'),
          TabItem(icon: Icons.search_rounded, title: 'Cari'),
          TabItem(icon: Icons.person_rounded, title: 'Profil'),
        ],
        initialActiveIndex: _halamanAktif,
        onTap: (int index) {
          setState(() {
            _halamanAktif = index;
          });
        },
      ),
    );
  }
}
