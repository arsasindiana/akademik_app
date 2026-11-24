// lib/screens/form_mata_kuliah_screen.dart
import 'package:flutter/material.dart';
import '../models/mata_kuliah.dart';

class FormMataKuliahScreen extends StatefulWidget {
  final MataKuliah? mataKuliahEdit; // null = mode Tambah, terisi = mode Edit

  const FormMataKuliahScreen({super.key, this.mataKuliahEdit});

  @override
  State<FormMataKuliahScreen> createState() => _FormMataKuliahScreenState();
}

class _FormMataKuliahScreenState extends State<FormMataKuliahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kodeCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _sksCtrl = TextEditingController();
  final _semCtrl = TextEditingController();

  bool get _isEdit => widget.mataKuliahEdit != null;

  @override
  void initState() {
    super.initState();
    final m = widget.mataKuliahEdit;
    if (m != null) {
      _kodeCtrl.text = m.kode;
      _namaCtrl.text = m.namaMk;
      _sksCtrl.text = m.sks.toString();
      _semCtrl.text = m.semester.toString();
    }
  }

  @override
  void dispose() {
    _kodeCtrl.dispose();
    _namaCtrl.dispose();
    _sksCtrl.dispose();
    _semCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final hasil = MataKuliah(
      id: widget.mataKuliahEdit?.id ?? 'MK${DateTime.now().millisecondsSinceEpoch}',
      kode: _kodeCtrl.text.trim(),
      namaMk: _namaCtrl.text.trim(),
      sks: int.parse(_sksCtrl.text.trim()),
      semester: int.parse(_semCtrl.text.trim()),
    );
    Navigator.pop(context, hasil);
  }

  String? _validasiAngka(String? v, String label, int min, int max) {
    final n = int.tryParse(v?.trim() ?? '');
    if (n == null) return '$label harus berupa angka';
    if (n < min || n > max) return '$label harus antara $min dan $max';
    return null;
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
      appBar: AppBar(title: Text(_isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _kolom(_kodeCtrl, 'Kode Mata Kuliah'),
              _kolom(_namaCtrl, 'Nama Mata Kuliah'),
              _kolom(
                _sksCtrl,
                'SKS (1-6)',
                tipe: TextInputType.number,
                validator: (v) => _validasiAngka(v, 'SKS', 1, 6),
              ),
              _kolom(
                _semCtrl,
                'Semester (1-14)',
                tipe: TextInputType.number,
                validator: (v) => _validasiAngka(v, 'Semester', 1, 14),
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
