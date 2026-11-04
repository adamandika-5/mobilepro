// =============================================================
// FILE: pages/cari_page.dart
// DESKRIPSI: Halaman pencarian dan penyaringan kontak berdasarkan
//            kategori. Menggunakan package 'dropdown_search' v7.0.0.
//            Pilihan kategori benar-benar mempengaruhi daftar
//            kontak yang ditampilkan.
// =============================================================

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import '../models/kontak_model.dart';

/// Widget halaman Pencarian / Filter Kontak.
class CariPage extends StatefulWidget {
  // Daftar semua kontak diterima dari halaman induk (main page)
  // agar data tetap konsisten dengan halaman Kontak.
  final List<KontakModel> daftarKontak;

  const CariPage({super.key, required this.daftarKontak});

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  // Pilihan kategori saat ini. null berarti "Semua Kontak".
  String? _kategoriDipilih;

  // Opsi filter yang tersedia untuk dropdown
  static const List<String> _opsiKategori = [
    'Semua Kontak',
    'Keluarga',
    'Teman',
    'Kerja',
  ];

  /// Menyaring daftar kontak berdasarkan kategori yang dipilih.
  List<KontakModel> get _kontakTerfilter {
    if (_kategoriDipilih == null || _kategoriDipilih == 'Semua Kontak') {
      return widget.daftarKontak;
    }

    // Mapping nama kategori ke enum KategoriKontak
    final KategoriKontak? enumKategori = switch (_kategoriDipilih) {
      'Keluarga' => KategoriKontak.keluarga,
      'Teman' => KategoriKontak.teman,
      'Kerja' => KategoriKontak.kerja,
      _ => null,
    };

    if (enumKategori == null) return widget.daftarKontak;

    return widget.daftarKontak
        .where((k) => k.kategori == enumKategori)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasil = _kontakTerfilter;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Header dengan gradient
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: colorScheme.secondary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Cari Kontak',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.secondary,
                      colorScheme.primary,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Panel filter dropdown dan statistik
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label filter
                  Text(
                    'Filter berdasarkan Kategori',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown menggunakan package dropdown_search v7.0.0
                  // API v7: items menggunakan callback (filter, LoadProps?) => FutureOr<List<T>>
                  // Nama parameter callback: onSelected (bukan onChanged seperti versi lama)
                  DropdownSearch<String>(
                    // Mengambil pilihan dari daftar lokal (bukan API)
                    // LoadProps? adalah parameter kedua sesuai typedef DropdownSearchOnFind v7
                    items: (filter, loadProps) => _opsiKategori,
                    // Nilai awal yang ditampilkan
                    selectedItem: _kategoriDipilih ?? 'Semua Kontak',
                    // Konfigurasi tampilan dropdown (v7 menggunakan decoratorProps)
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.filter_list_rounded,
                          color: colorScheme.primary,
                        ),
                        hintText: 'Pilih kategori...',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    // Konfigurasi popup dropdown
                    // FIX: MenuProps sudah memiliki default 'shape' (RoundedRectangleBorder).
                    // Widget Material di dalam library melarang 'shape' dan 'borderRadius'
                    // diberikan bersamaan (assertion error). Gunakan 'shape' saja untuk
                    // menentukan sudut membulat, dan biarkan 'borderRadius' tetap null.
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      menuProps: MenuProps(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                    // Callback saat pengguna memilih kategori
                    // v7.0.0 menggunakan 'onSelected', bukan 'onChanged'
                    onSelected: (String? nilai) {
                      setState(() {
                        _kategoriDipilih = nilai;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Indikator hasil filter
                  _IndikatorFilter(
                    kategori: _kategoriDipilih ?? 'Semua Kontak',
                    jumlah: hasil.length,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Daftar hasil filter
          if (hasil.isEmpty)
            // Empty state jika tidak ada kontak yang cocok
            SliverFillRemaining(
              child: _EmptyState(
                kategori: _kategoriDipilih ?? 'Semua Kontak',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _KontakFilterCard(kontak: hasil[index]);
                  },
                  childCount: hasil.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget indikator yang menampilkan kategori aktif dan jumlah hasil.
class _IndikatorFilter extends StatelessWidget {
  final String kategori;
  final int jumlah;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _IndikatorFilter({
    required this.kategori,
    required this.jumlah,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
                children: [
                  const TextSpan(text: 'Menampilkan '),
                  TextSpan(
                    text: '$jumlah kontak',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' dari kategori '),
                  TextSpan(
                    text: kategori,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget card kontak untuk halaman filter.
/// Desain sedikit berbeda dengan halaman Kontak untuk variasi.
class _KontakFilterCard extends StatelessWidget {
  final KontakModel kontak;

  const _KontakFilterCard({required this.kontak});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final formatTanggal = DateFormat('dd MMMM yyyy', 'id_ID');

    // Warna berdasarkan kategori
    final warnaKategori = switch (kontak.kategori) {
      KategoriKontak.keluarga => Colors.green.shade500,
      KategoriKontak.teman => Colors.blue.shade500,
      KategoriKontak.kerja => Colors.orange.shade600,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        // Avatar dengan warna kategori
        leading: CircleAvatar(
          backgroundColor: warnaKategori.withValues(alpha: 0.2),
          child: Text(
            kontak.inisial,
            style: TextStyle(
              color: warnaKategori,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        // Nama kontak
        title: Text(
          kontak.namaLengkap,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        // Nomor telepon
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              kontak.nomorTelepon,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            Text(
              kontak.email,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              formatTanggal.format(kontak.tanggalDitambahkan),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
        // Badge kategori di sebelah kanan
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: warnaKategori.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            kontak.labelKategori,
            style: TextStyle(
              color: warnaKategori,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}

/// Widget empty state saat tidak ada kontak yang cocok dengan filter.
class _EmptyState extends StatelessWidget {
  final String kategori;

  const _EmptyState({required this.kategori});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak Ada Kontak',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ditemukan kontak dalam kategori\n"$kategori"',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
