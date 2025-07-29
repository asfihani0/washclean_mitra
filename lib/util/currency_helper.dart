import 'package:intl/intl.dart';

String formatRupiah(String? raw) {
  if (raw == null) return '0';
  final double? number = double.tryParse(raw);
  if (number == null) return '0';
  final formatter = NumberFormat.decimalPattern('id');
  return formatter.format(number.toInt());
}

String formatRupiahFull(String? raw) {
  if (raw == null) return 'Rp 0';
  final double? number = double.tryParse(raw);
  if (number == null) return 'Rp 0';
  final formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(number);
}
