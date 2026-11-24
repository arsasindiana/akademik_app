// lib/screens/form_mahasiswa_screen.dart
import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';

class FormMahasiswaScreen extends StatefulWidget {
  final Mahasiswa? mahasiswaEdit; // null = mode Tambah, terisi = mode Edit

  const FormMahasiswaScreen({super.key, this.mahasiswaEdit});

  @override
  State<FormMahasiswaScreen> createState() => _FormMahasiswaScreenState();
}

class _FormMahasiswaScreenState extends State<FormMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _prodiCtrl = TextEditingController();
  final _semCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  bool get _isEdit => widget.mahasiswaEdit != null;

  @override
  void initState() {
    super.initState();
    final m = widget.mahasiswaEdit;
    if (m != null) {
      _namaCtrl.text = m.nama;
      _nimCtrl.text = m.nim;
      _prodiCtrl.text = m.prodi;
      _semCtrl.text = m.semester.toString();
      _emailCtrl.text = m.email;
    } else {
      _prodiCtrl.text = 'Sistem Informasi';
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _prodiCtrl.dispose();
    _semCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final hasil = Mahasiswa(
      id: widget.mahasiswaEdit?.id ?? 'M${DateTime.now().millisecondsSinceEpoch}',
      nim: _nimCtrl.text.trim(),
      nama: _namaCtrl.text.trim(),
      prodi: _prodiCtrl.text.trim(),
      semester: int.parse(_semCtrl.text.trim()),
      email: _emailCtrl.text.trim(),
    );
    Navigator.pop(context, hasil);
  }

  Widget _kolom(
    TextEditingController c,
    String label, {
    TextInputType tipe = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: tipe,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
            (v) => (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _kolom(_namaCtrl, 'Nama Lengkap'),
              _kolom(_nimCtrl, 'NIM', tipe: TextInputType.number),
              _kolom(_prodiCtrl, 'Program Studi'),
              _kolom(
                _semCtrl,
                'Semester (1-14)',
                tipe: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null) return 'Semester harus berupa angka';
                  if (n < 1 || n > 14) return 'Semester harus antara 1 dan 14';
                  return null;
                },
              ),
              _kolom(
                _emailCtrl,
                'Email Kampus',
                tipe: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email Kampus wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save),
                  label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Baru'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
