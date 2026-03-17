# Dokumentasi: Privilege Escalation (Privesc) — Lab Edukasi

> Dokumen ini dibuat untuk keperluan komunitas dan lab lokal (edukasi). Jangan gunakan teknik di luar lingkungan yang Anda miliki izin eksplisit untuk menguji.

---

## Ringkasan singkat

Dokumen ini menjelaskan apa itu *privilege escalation* (privesc), tipe-tipe umum, vektor serangan yang sering muncul di lab edukasi, langkah aman menjalankan lab ini, mitigasi khusus terhadap celah yang ada di lab, pedoman untuk instruktur dan peserta, serta template laporan dan checklist mitigasi.

---

## 1. Tujuan dan cakupan

* **Tujuan**: Menyediakan materi lengkap untuk mengajarkan konsep privesc secara aman dan bertanggung jawab dalam lingkungan lab.
* **Cakupan**: Penjelasan konsep, praktik lab (setup, aturan, cara pemakaian), pendekatan metodologi yang bersifat non-eksploitif (metodologi, bukan payload), mitigasi teknis dan kebijakan, template laporan, dan tips pengajaran.

---

## 2. Peringatan hukum & etika

* Semua aktivitas pengujian hanya boleh dilakukan pada lingkungan yang Anda kelola atau yang secara eksplisit mengizinkan pengujian (lab lokal, VM yang disediakan, CTF resmi).
* Jangan mencoba teknik ini pada sistem produksi, komputer orang lain, atau layanan publik tanpa izin tertulis.
* Dokumentasikan setiap langkah dan laporkan temuan ke pemilik/lampu hijau yang relevan.

---

## 3. Apa itu Privilege Escalation?

**Privilege escalation** adalah proses mendapatkan hak istimewa lebih tinggi di sistem daripada yang diberikan pada akun awal. Tujuan pembelajaran: memahami perbedaan *vertical* vs *horizontal*, bagaimana penyerang menemukan peluang, dan bagaimana mendeteksi/menghilangkan kemungkinan tersebut.

* **Vertical (privilege escalation vertikal)**: Mengangkat hak dari pengguna biasa menjadi akun dengan hak lebih tinggi (mis. admin/root).
* **Horizontal (privilege escalation horizontal)**: Mengakses sumber daya milik pengguna lain dengan level yang sama tanpa meningkatnya level hak (mis. mengakses file pengguna lain).

---

## 4. Vektor umum (konsep, tanpa instruksi eksploitatif)

> Catatan: ini hanya menjelaskan *kategori* vektor, bukan cara mengeksploitasi.

1. **Kesalahan konfigurasi izin (file/folder/service)** — file sensitif diletakkan dengan izin yang longgar.
2. **Setuid / SUID / Sticky bits yang salah** — program dengan bit khusus berjalan dengan hak pemiliknya.
3. **Layanan berjalan sebagai root** — daemon atau service yang dapat dipengaruhi oleh user tidak-privileged.
4. **Kredensial tersimpan / konfigurasi yang bocor** — file konfigurasi yang menyimpan password/token.
5. **Versi perangkat lunak rentan** — kernel atau service dengan kerentanan yang diketahui (di lab pastikan gunakan versi terkontrol).
6. **Misconfig pada sudoers** — aturan `sudo` yang terlalu longgar.
7. **Ekseskusi berkas yang dapat ditulis oleh pengguna** — membuat atau memodifikasi skrip yang dijalankan oleh proses privileged.
8. **Cron job/Task scheduler** — job berkala yang menjalankan skrip dengan hak tinggi dari direktori yang dapat ditulis user.

---

## 5. Mitigasi umum (tingkat sistem & kebijakan)

Berikut langkah mitigasi yang bisa diterapkan di lingkungan nyata maupun untuk memperbaiki lab sehingga lebih realistis dan aman.

### 5.1 Kebijakan & prosedur

* Batasi hak pengguna (principle of least privilege).
* Terapkan proses manajemen patch yang jelas (patching, pembaruan terjadwal)
* Audit berkala terhadap akun, grup, dan sudoers.
* Jangan simpan kredensial di file teks; gunakan secret manager untuk produksi.

### 5.2 Konfigurasi sistem

* Setiap file sensitif harus memiliki izin minimun (contoh: konfigurasi hanya dapat dibaca oleh pemilik dan root).
* Nonaktifkan layanan yang tidak diperlukan.
* Hindari menjalankan layanan yang menerima input user dengan hak root.
* Gunakan sandboxing / containment (containers, seccomp, AppArmor/SELinux) untuk membatasi jangkauan proses.

### 5.3 Logging & deteksi

* Aktifkan logging terpusat (syslog, SIEM) untuk memantau akses file berbahaya, perubahan permission, dan aktivitas `sudo`.
* Monitor perubahan crontab dan file di direktori penting.

---

## 6. Cara aman menjalankan lab ini (operasional)

Bagian ini menjelaskan bagaimana instruktur/penyelenggara menyiapkan lab agar aman, dapat di-reset, dan edukatif.

### 6.1 Persiapan lingkungan

* Jalankan lab pada jaringan terisolasi (host-only network / internal VLAN) tanpa akses ke jaringan produksi atau internet publik kecuali memang diperlukan dan dipantau.
* Gunakan VM atau container yang mudah di-snapshot (mis. VirtualBox, VMware, QEMU, atau Docker dengan image terkontrol).
* Siapkan snapshot/restore points sebelum tiap sesi sehingga peserta dapat mereset keadaan.
* Batasi resource (CPU/RAM) agar eksperimen tidak mempengaruhi host.

### 6.2 Kontrol akses & identitas lab

* Sediakan akun peserta dengan kredensial yang berbeda, non-privileged secara default.
* Gunakan password yang tercatat di lab README; gantilah antar sesi untuk menjaga integritas.
* Dokumentasikan peran tiap akun (mis. `user1`, `service-account`) dan apa yang boleh diakses.

### 6.3 Backup & reset

* Pastikan ada prosedur cepat untuk merestore snapshot.
* Simpan salinan logs lab untuk analisis pasca-sesi.

### 6.4 Rules of engagement untuk peserta

* Hanya gunakan teknik yang diajarkan; tidak mencoba teknik lain yang berpotensi merusak VM.
* Jangan mencoba mengakses VM peserta lain tanpa izin.
* Simpan bukti eksploitasi dalam folder yang ditentukan (mis. `/home/user/report/`) dan jangan menyebar keluar lab.

---

## 7. Cara pakai lab ini: panduan instruktur & peserta (langkah non-teknis)

> Ini bukan panduan eksploitasi. Ini panduan alur kerja yang aman dan terukur.

### 7.1 Untuk instruktur

1. Siapkan VM master dan buat snapshot "clean".
2. Siapkan akun peserta dan dokumentasi singkat (README) yang menyertakan tujuan, waktu, dan indikator kemenangan (flag atau bukti lain).
3. Jalankan sesi pembukaan: jelaskan tujuan, aturan lab, serta batasan etika.
4. Berikan modul latihan bertingkat: enumeration → identifikasi vektor → eksploitasi terkontrol → mitigasi.
5. Siapkan hints dan sistem poin.

### 7.2 Untuk peserta

1. Baca README lab dan pahami scope/tujuan.
2. Lakukan *reconnaissance* internal: lihat konfigurasi yang tersedia (file README, file konfigurasi yang sengaja disediakan), hak akses akun Anda, dan layanan yang berjalan.
3. Lakukan *enumeration*—inventarisasi file/direktori yang dapat diakses, daftar service yang berjalan, dan setingan sudoers. (catat; jangan menjalankan exploit tanpa izin eksplisit untuk tahap selanjutnya)
4. Jika Anda menemukan kemungkinan vektor, catat bukti non-destruktif (mis. path file yang dapat dibaca, output konfigurasi yang relevan).
5. Pelaporan: buat laporan singkat berisi langkah yang Anda ambil, bukti temuan (log, nama file, dsb.), dan rekomendasi mitigasi.

---

## 8. Contoh struktur tugas dan penilaian (non-instruktif)

* **Tingkat Pemula**: Menemukan file sensitif dengan izin baca untuk user yang salah.
* **Tingkat Menengah**: Menemukan konfigurasi yang memungkinkan akses horizontal.
* **Tingkat Lanjut**: Menemukan kombinasi perilaku yang bisa mengarah ke eskalasi (tanpa menuliskan exploit).

**Penilaian**: 50% temuan & bukti, 30% dokumentasi & metodologi, 20% rekomendasi mitigasi.

---

## 9. Template Laporan (singkat)

* Judul tugas / Lab
* Nama peserta
* Tanggal & waktu sesi
* Ringkasan (1-2 paragraf)
* Langkah yang diambil (metode)
* Bukti yang ditemukan (file, path, output) — simpan bukti non-destruktif
* Dampak (potensi risiko)
* Rekomendasi mitigasi (prioritas: high/medium/low)
* Tindakan pembersihan / restore yang dilakukan

---

## 10. Checklist mitigasi khusus untuk lab ini

Gunakan checklist ini untuk menutup celah umum di lingkungan lab yang Anda jalankan.

* [ ] Pastikan semua VM ditempatkan di jaringan terisolasi.
* [ ] Setiap sesi dimulai dari snapshot clean.
* [ ] Akun peserta diberi hak minimum.
* [ ] Tidak ada kredensial produksi di image lab.
* [ ] Logging aktivitas peserta diaktifkan dan diarsip.
* [ ] Sudoers diperiksa dan dibatasi.
* [ ] Direktori yang dieksekusi oleh cron/job tidak writable oleh peserta.
* [ ] SetUID biner yang tidak perlu dihapus atau dianalisis.

---

## 11. Deteksi & pemulihan (opsional)

* Simpan log akses `/var/log/auth.log`, `sudo` logs, dan crontab changes.
* Setelah sesi selesai, restore snapshot dan simpan artefak log untuk studi lebih lanjut.

---

## 12. Tips mengajar & materi tambahan

* Mulai dengan konsep dasar izin Unix/Windows sebelum masuk ke skenario lab.
* Jadwalkan sesi diskusi pasca-lab untuk membahas mitigasi nyata.
* Berikan penekanan besar pada etika, hukum, dan reporting.

---

## 13. Lampiran: contoh README lab (template singkat)

```
Nama Lab: Privesc Basics
Deskripsi: Lab ini mengajarkan konsep pengumpulan informasi dan identifikasi vektor eskalasi dalam lingkungan terkontrol.
Akun: user: `student1` / pass: `labpass123` (ganti setiap sesi)
Snapshot clean: snapshot-clean-2026-03-17
Rules: jangan merusak VM, jangan scanning jaringan luar, simpan bukti di /home/student1/report
Tujuan: Temukan 2 bukti konfigurasi yang salah dan buat rekomendasi mitigasi.
```

---

## 14. Penutup

Dokumen ini dimaksudkan sebagai sumber lengkap untuk mengoperasikan dan mengajar lab privilege escalation secara aman. Jika Anda ingin saya tambahkan: *contoh template slide*, *format quiz*, atau *versi bahasa Inggris*, beri tahu dan saya akan buatkan versi tambahan.

---

*Catatan: Dokumen sengaja tidak memuat instruksi eksploitatif atau payload untuk menjaga etika dan kepatuhan hukum.*
