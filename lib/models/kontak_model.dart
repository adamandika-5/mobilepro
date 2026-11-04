// =============================================================
// FILE: models/kontak_model.dart
// DESKRIPSI: Model data untuk kontak.
//            Berisi struktur data (nama, telepon, email, dll)
//            yang digunakan di seluruh aplikasi.
// =============================================================

/// Enum untuk kategori kontak.
/// Memudahkan pengelompokan kontak berdasarkan hubungan.
enum KategoriKontak {
  keluarga,
  teman,
  kerja,
}

/// Model data untuk satu kontak.
class KontakModel {
  final String id;
  final String namaLengkap;
  final String nomorTelepon;
  final String email;
  final DateTime tanggalDitambahkan;
  final KategoriKontak kategori;

  const KontakModel({
    required this.id,
    required this.namaLengkap,
    required this.nomorTelepon,
    required this.email,
    required this.tanggalDitambahkan,
    required this.kategori,
  });

  /// Mendapatkan label kategori dalam Bahasa Indonesia
  String get labelKategori {
    switch (kategori) {
      case KategoriKontak.keluarga:
        return 'Keluarga';
      case KategoriKontak.teman:
        return 'Teman';
      case KategoriKontak.kerja:
        return 'Kerja';
    }
  }

  /// Mendapatkan inisial nama untuk avatar (maksimal 2 huruf)
  String get inisial {
    final parts = namaLengkap.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return namaLengkap.isNotEmpty ? namaLengkap[0].toUpperCase() : '?';
  }
}
