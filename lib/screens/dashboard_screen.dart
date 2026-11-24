// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../models/mata_kuliah.dart';
import '../services/akademik_service.dart';
import '../widgets/kartu_mahasiswa.dart';
import '../widgets/kartu_mata_kuliah.dart';
import 'form_mahasiswa_screen.dart';
import 'form_mata_kuliah_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final List<Mahasiswa> _mahasiswa = AkademikService.ambilDataAwalMahasiswa();
  final List<MataKuliah> _mataKuliah = AkademikService.ambilDataAwalMataKuliah();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ---------- Util ----------
  void _snack(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<bool> _konfirmasi(String judul, String pesan) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(judul),
        content: Text(pesan),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return ya ?? false;
  }

  void _detail(String judul, List<String> baris) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(judul),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: baris
              .map((b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(b),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  // ---------- CRUD Mahasiswa ----------
  Future<void> _tambahMahasiswa() async {
    final hasil = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(builder: (_) => const FormMahasiswaScreen()),
    );
    if (hasil == null) return;
    setState(() => _mahasiswa.add(hasil));
    _snack('Mahasiswa "${hasil.nama}" berhasil ditambahkan');
  }

  Future<void> _editMahasiswa(Mahasiswa m) async {
    final hasil = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(builder: (_) => FormMahasiswaScreen(mahasiswaEdit: m)),
    );
    if (hasil == null) return;
    setState(() {
      final i = _mahasiswa.indexWhere((e) => e.id == m.id);
      if (i != -1) _mahasiswa[i] = hasil;
    });
    _snack('Data "${hasil.nama}" berhasil diperbarui');
  }

  Future<void> _hapusMahasiswa(Mahasiswa m) async {
    final ya = await _konfirmasi(
      'Hapus Mahasiswa?',
      'Yakin ingin menghapus "${m.nama}" (NIM: ${m.nim})?',
    );
    if (!ya) return;
    setState(() => _mahasiswa.removeWhere((e) => e.id == m.id));
    _snack('Mahasiswa "${m.nama}" dihapus');
  }

  // ---------- CRUD Mata Kuliah ----------
  Future<void> _tambahMataKuliah() async {
    final hasil = await Navigator.push<MataKuliah>(
      context,
      MaterialPageRoute(builder: (_) => const FormMataKuliahScreen()),
    );
    if (hasil == null) return;
    setState(() => _mataKuliah.add(hasil));
    _snack('Mata kuliah "${hasil.namaMk}" berhasil ditambahkan');
  }

  Future<void> _editMataKuliah(MataKuliah m) async {
    final hasil = await Navigator.push<MataKuliah>(
      context,
      MaterialPageRoute(builder: (_) => FormMataKuliahScreen(mataKuliahEdit: m)),
    );
    if (hasil == null) return;
    setState(() {
      final i = _mataKuliah.indexWhere((e) => e.id == m.id);
      if (i != -1) _mataKuliah[i] = hasil;
    });
    _snack('Mata kuliah "${hasil.namaMk}" berhasil diperbarui');
  }

  Future<void> _hapusMataKuliah(MataKuliah m) async {
    final ya = await _konfirmasi(
      'Hapus Mata Kuliah?',
      'Yakin ingin menghapus "${m.namaMk}"?',
    );
    if (!ya) return;
    setState(() => _mataKuliah.removeWhere((e) => e.id == m.id));
    _snack('Mata kuliah "${m.namaMk}" dihapus');
  }

  // ---------- Tampilan ----------
  Widget _daftarMahasiswa() {
    if (_mahasiswa.isEmpty) {
      return const Center(child: Text('Belum ada data mahasiswa'));
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: _mahasiswa
          .map((m) => KartuMahasiswa(
                mahasiswa: m,
                onTap: () => _detail('Detail Mahasiswa', [
                  'ID: ${m.id}',
                  'NIM: ${m.nim}',
                  'Nama: ${m.nama}',
                  'Prodi: ${m.prodi}',
                  'Semester: ${m.semester}',
                  'Email: ${m.email}',
                ]),
                onEdit: () => _editMahasiswa(m),
                onDelete: () => _hapusMahasiswa(m),
              ))
          .toList(),
    );
  }

  Widget _daftarMataKuliah() {
    if (_mataKuliah.isEmpty) {
      return const Center(child: Text('Belum ada data mata kuliah'));
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: _mataKuliah
          .map((m) => KartuMataKuliah(
                mataKuliah: m,
                onTap: () => _detail('Detail Mata Kuliah', [
                  'ID: ${m.id}',
                  'Kode: ${m.kode}',
                  'Nama: ${m.namaMk}',
                  'SKS: ${m.sks}',
                  'Semester: ${m.semester}',
                ]),
                onEdit: () => _editMataKuliah(m),
                onDelete: () => _hapusMataKuliah(m),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMhs = _tab.index == 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Akademik'),
        bottom: TabBar(
          controller: _tab,
          tabs: [
            Tab(icon: const Icon(Icons.people), text: 'Mahasiswa (${_mahasiswa.length})'),
            Tab(icon: const Icon(Icons.menu_book), text: 'Mata Kuliah (${_mataKuliah.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [_daftarMahasiswa(), _daftarMataKuliah()],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isMhs ? 'Tambah Mahasiswa' : 'Tambah Mata Kuliah',
        onPressed: isMhs ? _tambahMahasiswa : _tambahMataKuliah,
        child: const Icon(Icons.add),
      ),
    );
  }
}
