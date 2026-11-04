/// Kategori kontak yang tersedia dalam aplikasi.
enum KategoriKontak {
  keluarga,
  teman,
  kerja,
}

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

  String get inisial {
    final bagian = namaLengkap.trim().split(RegExp(r'\s+'));
    if (bagian.isEmpty || bagian.first.isEmpty) return '?';
    if (bagian.length == 1) {
      return bagian.first.substring(0, 1).toUpperCase();
    }
    return (bagian.first.substring(0, 1) + bagian.last.substring(0, 1))
        .toUpperCase();
  }

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
}

