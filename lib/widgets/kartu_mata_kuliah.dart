// lib/widgets/kartu_mata_kuliah.dart
import 'package:flutter/material.dart';
import '../models/mata_kuliah.dart';

class KartuMataKuliah extends StatelessWidget {
  final MataKuliah mataKuliah;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const KartuMataKuliah({
    super.key,
    required this.mataKuliah,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Text('${mataKuliah.sks}')),
        title: Text(
          mataKuliah.namaMk,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Kode: ${mataKuliah.kode} • ${mataKuliah.sks} SKS\nSemester ${mataKuliah.semester}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.teal),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
