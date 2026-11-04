// =============================================================
// FILE: pages/cari_page.dart
// DESKRIPSI: Halaman pencarian dan penyaringan kontak berdasarkan
//            kategori menggunakan package 'dropdown_search' v7.0.0.
// =============================================================

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import '../models/kontak_model.dart';

/// Halaman pencarian dan filter kontak berdasarkan kategori.
class CariPage extends StatefulWidget {
  final List<KontakModel> daftarKontak;

  const CariPage({super.key, required this.daftarKontak});

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  // Pilihan kategori aktif. null atau 'Semua Kontak' berarti menampilkan seluruh kontak.
  String? _kategoriDipilih;

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
    final formatTanggal = DateFormat('dd MMMM yyyy', 'id_ID');
    final hasil = _kontakTerfilter;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Cari Kontak',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ==========================================================
          // FILTER DROPDOWN
          // ==========================================================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Berdasarkan Kategori',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                // Widget DropdownSearch versi 7.0.0
                DropdownSearch<String>(
                  items: (filter, loadProps) => _opsiKategori,
                  selectedItem: _kategoriDipilih ?? 'Semua Kontak',
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
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    menuProps: MenuProps(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                  onSelected: (String? nilai) {
                    setState(() {
                      _kategoriDipilih = nilai;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Indikator jumlah kontak yang ditemukan
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                        child: Text(
                          'Menampilkan ${hasil.length} kontak (${_kategoriDipilih ?? 'Semua Kontak'})',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==========================================================
          // DAFTAR HASIL FILTER
          // ==========================================================
          Expanded(
            child: hasil.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
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
                          const SizedBox(height: 6),
                          Text(
                            'Tidak ada kontak untuk kategori "${_kategoriDipilih ?? 'Semua Kontak'}"',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: hasil.length,
                    itemBuilder: (context, index) {
                      final kontak = hasil[index];
                      final warnaKategori =
                          _warnaBerdasarkanKategori(kontak.kategori);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                warnaKategori.withValues(alpha: 0.2),
                            child: Text(
                              kontak.inisial,
                              style: TextStyle(
                                color: warnaKategori,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          title: Text(
                            kontak.namaLengkap,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                kontak.nomorTelepon,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                kontak.email,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatTanggal.format(kontak.tanggalDitambahkan),
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: warnaKategori.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              kontak.labelKategori,
                              style: TextStyle(
                                color: warnaKategori,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _warnaBerdasarkanKategori(KategoriKontak kategori) {
    switch (kategori) {
      case KategoriKontak.keluarga:
        return Colors.green.shade600;
      case KategoriKontak.teman:
        return Colors.blue.shade600;
      case KategoriKontak.kerja:
        return Colors.orange.shade700;
    }
  }
}

