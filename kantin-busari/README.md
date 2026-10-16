# Kantin Bu Sari

Aplikasi pemesanan makanan kantin berbasis Flutter untuk tugas pengembangan UI.

## Fitur
- Beranda dengan pencarian menu dan filter kategori.
- Kartu menu dengan harga, rating, dan kategori.
- Detail menu dengan informasi produk dan pengatur jumlah.
- Keranjang dengan pengubahan jumlah dan perhitungan total.
- Checkout dengan nama pemesan, metode pembayaran, dan catatan.
- Konfirmasi pesanan dan riwayat pesanan selama aplikasi berjalan.

## Menjalankan project
1. Buka folder utama project yang berisi `pubspec.yaml`.
2. Jalankan `flutter pub get`.
3. Jalankan `flutter run`.

Project menggunakan widget bawaan Flutter dan tidak memerlukan package tambahan di luar dependency standar.

Catatan: data keranjang dan riwayat disimpan sementara di memori. Data akan kembali kosong saat aplikasi ditutup sepenuhnya; database belum diimplementasikan.
