// =============================================================
// FILE: pages/profil_page.dart
// DESKRIPSI: Halaman profil mahasiswa dengan efek AvatarGlow
//            dari package 'avatar_glow' v3.0.1.
// =============================================================

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

/// Widget halaman Profil.
/// Menampilkan identitas mahasiswa dengan efek cahaya AvatarGlow.
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ================================================
                // JUDUL HALAMAN
                // ================================================
                Text(
                  'Profil Saya',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 40),

                // ================================================
                // FOTO PROFIL dengan efek AvatarGlow v3.0.1
                // ================================================
                AvatarGlow(
                  glowColor: colorScheme.primary,
                  glowCount: 3,
                  duration: const Duration(milliseconds: 2000),
                  animate: true,
                  repeat: true,
                  curve: Curves.easeInOut,
                  glowShape: BoxShape.circle,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: colorScheme.primaryContainer,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: colorScheme.primary,
                      // Inisial sebagai placeholder foto profil
                      child: Text(
                        'NM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ================================================
                // NAMA MAHASISWA
                // ================================================
                Text(
                  'Nama Mahasiswa',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                // ================================================
                // NIM MAHASISWA
                // ================================================
                Text(
                  'NIM: XXXXX-XXXXX',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
