// =============================================================
// FILE: pages/kontak_page.dart
// DESKRIPSI: Halaman utama yang menampilkan daftar kontak.
//            Data diterima dari main.dart (dibuat satu kali)
//            agar konsisten saat berpindah antar halaman.
//            Tanggal diformat menggunakan package 'intl' dengan
//            locale Bahasa Indonesia (id_ID).
// =============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/kontak_model.dart';

/// Widget halaman Daftar Kontak.
/// Menerima daftarKontak dari parent agar data konsisten.
class KontakPage extends StatelessWidget {
  final List<KontakModel> daftarKontak;

  const KontakPage({super.key, required this.daftarKontak});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar dengan efek collapse saat di-scroll
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Daftar Kontak',
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
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
              ),
            ),
            // Badge total kontak
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${daftarKontak.length} Kontak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Daftar kontak menggunakan SliverList
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _KontakCard(kontak: daftarKontak[index]);
                },
                childCount: daftarKontak.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget card untuk menampilkan satu item kontak.
/// Dipisahkan agar kode lebih bersih dan mudah dibaca.
class _KontakCard extends StatelessWidget {
  final KontakModel kontak;

  const _KontakCard({required this.kontak});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Format tanggal ke Bahasa Indonesia, contoh: 05 September 2026
    final formatTanggal = DateFormat('dd MMMM yyyy', 'id_ID');
    final tanggalFormatted = formatTanggal.format(kontak.tanggalDitambahkan);

    // Warna avatar dan badge berdasarkan kategori
    final (warnaBadge, warnaAvatar) = _warnaKategori(kontak.kategori, colorScheme);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar dengan inisial nama
            CircleAvatar(
              radius: 26,
              backgroundColor: warnaAvatar,
              child: Text(
                kontak.inisial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Informasi kontak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris nama + badge kategori
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          kontak.namaLengkap,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge kategori
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: warnaBadge.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: warnaBadge.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          kontak.labelKategori,
                          style: TextStyle(
                            color: warnaBadge,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Nomor telepon
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    text: kontak.nomorTelepon,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 2),

                  // Email
                  _InfoRow(
                    icon: Icons.email_outlined,
                    text: kontak.email,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(height: 2),

                  // Tanggal ditambahkan (format Indonesia)
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: tanggalFormatted,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menentukan warna badge dan avatar berdasarkan kategori kontak.
  (Color, Color) _warnaKategori(
    KategoriKontak kategori,
    ColorScheme colorScheme,
  ) {
    switch (kategori) {
      case KategoriKontak.keluarga:
        return (Colors.green.shade600, Colors.green.shade400);
      case KategoriKontak.teman:
        return (Colors.blue.shade600, Colors.blue.shade400);
      case KategoriKontak.kerja:
        return (Colors.orange.shade700, Colors.orange.shade400);
    }
  }
}

/// Widget baris informasi kecil dengan ikon di depan teks.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
