import 'package:intl/intl.dart';

String? getTanggalSelesai(String? tanggal, int? durasiJam) {
  if (tanggal == null || durasiJam == null) return null;

  final masukDate = DateTime.tryParse(tanggal);
  if (masukDate == null) return null;

  final selesaiDate = masukDate.add(Duration(hours: durasiJam));

  // Format TANPA jam:
  return DateFormat('dd/MM/yyyy').format(selesaiDate);
}

String? formatTanggal(String? rawDate) {
  if (rawDate == null) return null;

  final date = DateTime.tryParse(rawDate);
  if (date == null) return null;

  return DateFormat('dd/MM/yyyy').format(date);
}
