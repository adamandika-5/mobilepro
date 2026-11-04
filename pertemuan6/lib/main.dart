// =============================================================
// FILE: main.dart
// DESKRIPSI: Titik masuk aplikasi (entry point).
//            - Menginisialisasi locale Bahasa Indonesia untuk intl
//            - Mengatur tema Material Design 3
//            - Mengelola navigasi bawah dengan ConvexAppBar
//            - Menyimpan data kontak agar konsisten di semua halaman
// =============================================================

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// Gunakan alias agar tidak terjadi konflik nama 'Color' antara
// package faker (src/colors.dart) dengan Color milik Flutter.
import 'package:faker/faker.dart' as faker_lib;
import 'package:intl/date_symbol_data_local.dart';

import 'models/kontak_model.dart';
import 'pages/kontak_page.dart';
import 'pages/cari_page.dart';
import 'pages/profil_page.dart';

/// Entry point aplikasi.
/// initializeDateFormatting harus dipanggil sebelum runApp
/// agar format tanggal Bahasa Indonesia siap digunakan.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale Indonesia untuk package intl
  // Ini wajib dilakukan agar DateFormat('dd MMMM yyyy', 'id_ID') bekerja
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

      // Material Design 3 dengan palet warna indigo
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0), // Indigo 400
          brightness: Brightness.light,
        ),
        // Tipografi menggunakan font sistem yang bersih
        // Catatan: tidak menggunakan 'const' agar Color Flutter digunakan
        // (bukan Color dari faker yang bisa konflik)
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

/// Halaman utama yang mengelola navigasi antar halaman.
/// Menggunakan StatefulWidget untuk menyimpan:
/// - Indeks halaman aktif
/// - Data kontak (agar konsisten di halaman Kontak dan Cari)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Indeks halaman yang sedang aktif (0 = Kontak, 1 = Cari, 2 = Profil)
  int _halamanAktif = 0;

  // Data kontak disimpan di sini agar bisa dibagikan ke halaman
  // Kontak dan Cari tanpa perlu membuat ulang data
  late final List<KontakModel> _daftarKontak;

  @override
  void initState() {
    super.initState();
    // Buat data dummy sekali saja saat aplikasi pertama dibuka
    _daftarKontak = _buatDataDummy();
  }

  /// Membuat 20 data kontak dummy menggunakan package Faker.
  /// Menggunakan alias 'faker_lib' agar tidak konflik dengan Color Flutter.
  List<KontakModel> _buatDataDummy() {
    // Inisialisasi Faker menggunakan alias yang sudah dideklarasikan
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
      // integer(max, min:) mengembalikan tipe int — ini sudah benar
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

    // Daftar halaman — meneruskan data kontak ke halaman yang membutuhkan
    final halamanList = <Widget>[
      // Halaman Kontak menerima data langsung dari sini
      KontakPage(daftarKontak: _daftarKontak),
      // Halaman Cari menerima data yang sama untuk filter yang konsisten
      CariPage(daftarKontak: _daftarKontak),
      // Halaman Profil tidak membutuhkan data kontak
      const ProfilPage(),
    ];

    return Scaffold(
      // Menggunakan IndexedStack agar state halaman dipertahankan
      // ketika pengguna berpindah antar menu navigasi
      body: IndexedStack(
        index: _halamanAktif,
        children: halamanList,
      ),

      // ============================================================
      // ConvexAppBar - Navigasi bawah dari package convex_bottom_bar
      // ============================================================
      bottomNavigationBar: ConvexAppBar(
        // Warna utama navigasi
        color: colorScheme.onPrimary.withValues(alpha: 0.7),
        activeColor: Colors.white,
        backgroundColor: colorScheme.primary,
        // Item navigasi dengan ikon dan label
        items: const [
          TabItem(icon: Icons.contacts_rounded, title: 'Kontak'),
          TabItem(icon: Icons.search_rounded, title: 'Cari'),
          TabItem(icon: Icons.person_rounded, title: 'Profil'),
        ],
        // Indeks awal
        initialActiveIndex: _halamanAktif,
        // Callback saat pengguna menekan menu
        onTap: (int index) {
          setState(() {
            _halamanAktif = index;
          });
        },
      ),
    );
  }
}

// Catatan: KontakPageWithData dihapus karena KontakPage sudah menerima
// parameter daftarKontak secara langsung, sehingga wrapper tidak diperlukan.
