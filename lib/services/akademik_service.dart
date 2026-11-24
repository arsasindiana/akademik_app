// lib/services/akademik_service.dart
import '../models/mahasiswa.dart';
import '../models/mata_kuliah.dart';

/// Menyediakan data awal (seed) untuk aplikasi.
class AkademikService {
  static List<Mahasiswa> ambilDataAwalMahasiswa() {
    return [
      const Mahasiswa(
        id: 'M001',
        nim: '2023001',
        nama: 'Rina Amelia',
        prodi: 'Sistem Informasi',
        semester: 5,
        email: 'rina@uinjambi.ac.id',
      ),
      const Mahasiswa(
        id: 'M002',
        nim: '2023002',
        nama: 'Budi Santoso',
        prodi: 'Sistem Informasi',
        semester: 5,
        email: 'budi@uinjambi.ac.id',
      ),
      const Mahasiswa(
        id: 'M003',
        nim: '2024003',
        nama: 'Siti Rahma',
        prodi: 'Sistem Informasi',
        semester: 3,
        email: 'siti@uinjambi.ac.id',
      ),
    ];
  }

  static List<MataKuliah> ambilDataAwalMataKuliah() {
    return [
      const MataKuliah(id: 'MK01', kode: 'SIF65005', namaMk: 'Pemrograman Mobile', sks: 3, semester: 5),
      const MataKuliah(id: 'MK02', kode: 'SIF63002', namaMk: 'Basis Data', sks: 3, semester: 3),
      const MataKuliah(id: 'MK03', kode: 'SIF61001', namaMk: 'Algoritma', sks: 2, semester: 1),
    ];
  }
}
