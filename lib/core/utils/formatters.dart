class NumberFormat {
  final String locale;
  final String symbol;
  final int decimalDigits;

  NumberFormat.currency({
    required this.locale,
    required this.symbol,
    required this.decimalDigits,
  });

  String format(num number) {
    final fixed = decimalDigits > 0
        ? number.toStringAsFixed(decimalDigits)
        : number.round().toString();

    final formatted = fixed.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}.',
    );

    return '$symbol$formatted';
  }
}

String formatRupiah(num number) {
  final formatCuci = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatCuci.format(number);
}